const path = require('node:path');
const { readFile } = require('node:fs/promises');
const express = require('express');
const session = require('express-session');
const bcrypt = require('bcryptjs');
const mysql = require('mysql2/promise');

const { DB_HOST = 'localhost', DB_PORT = '3306', DB_USER, DB_PASSWORD, SESSION_SECRET, PORT = '3000' } = process.env;
if (!DB_USER || !SESSION_SECRET) {
    throw new Error('Set DB_USER and SESSION_SECRET before starting the server.');
}

const db = mysql.createPool({
    host: DB_HOST,
    port: Number(DB_PORT),
    user: DB_USER,
    password: DB_PASSWORD,
    database: 'group6_music'
});

const app = express();
const siteRoot = path.resolve(__dirname, '../..');
for (const folder of ['audio', 'css', 'fonts', 'img', 'js', 'scss']) {
    app.use('/assets/' + folder, express.static(path.join(siteRoot, 'assets', folder)));
}

app.use(express.json({ limit: '8kb' }));
app.use(session({
    secret: SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: { httpOnly: true, sameSite: 'lax' }
}));

const validName = /^[\p{L}\p{M}_-]{1,100}$/u;
const validEmail = /^[^\s@]+@[^\s@]+\.[^\s@.]+$/u;
const validPassword = /^(?=.*\p{Lu})(?=.*[0-9])(?=.*[\p{P}\p{S}]).{6,}$/u;

function validNames(firstName, lastName) {
    return typeof firstName === 'string' && validName.test(firstName) &&
        typeof lastName === 'string' && validName.test(lastName);
}

app.post('/api/register', async (req, res) => {
    const { firstName, lastName, email, password } = req.body ?? {};
    if (!validNames(firstName, lastName) ||
        typeof email !== 'string' || email.length > 255 || !validEmail.test(email) ||
        typeof password !== 'string' || !validPassword.test(password) || bcrypt.truncates(password)) {
        return res.status(400).json({ message: 'Check your name, email, and password. Passwords can be up to 72 bytes.' });
    }

    const passwordHash = await bcrypt.hash(password, 12);
    try {
        await db.execute(
            'INSERT INTO customers (first_name, last_name, email, password_hash) VALUES (?, ?, ?, ?)',
            [firstName, lastName, email, passwordHash]
        );
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ message: 'An account already exists for that email. Please log in.' });
        }
        throw error;
    }
    res.status(201).json({ message: 'Account created. You can now log in.' });
});

app.post('/api/login', async (req, res) => {
    const { email, password } = req.body ?? {};
    const invalidCredentials = () => res.status(401).json({ message: 'Email or password is incorrect.' });
    if (typeof email !== 'string' || email.length > 255 || !validEmail.test(email) ||
        typeof password !== 'string' || !password || bcrypt.truncates(password)) {
        return invalidCredentials();
    }

    const [[customer]] = await db.execute(
        'SELECT customer_id, password_hash FROM customers WHERE email = ?',
        [email]
    );
    if (!customer || !(await bcrypt.compare(password, customer.password_hash))) {
        return invalidCredentials();
    }

    await new Promise((resolve, reject) => {
        req.session.regenerate((error) => error ? reject(error) : resolve());
    });
    req.session.customerId = customer.customer_id;
    await new Promise((resolve, reject) => {
        req.session.save((error) => error ? reject(error) : resolve());
    });
    res.json({ message: 'Logged in.' });
});

app.post('/api/logout', (req, res, next) => {
    req.session.destroy((error) => {
        if (error) return next(error);
        res.clearCookie('connect.sid');
        res.redirect(303, '/index.html');
    });
});

app.use('/api/profile', (req, res, next) => {
    res.set('Cache-Control', 'no-store');
    if (!req.session.customerId) {
        return res.status(401).json({ message: 'Please log in to view your profile.' });
    }
    next();
});

app.get('/api/profile', async (req, res) => {
    const [[customer]] = await db.execute(
        `SELECT first_name AS firstName, last_name AS lastName, email, address_line AS addressLine, city, state, zip
         FROM customers WHERE customer_id = ?`,
        [req.session.customerId]
    );
    if (!customer) return res.status(401).json({ message: 'Please log in to view your profile.' });
    res.json(customer);
});

app.put('/api/profile', async (req, res) => {
    const { firstName, lastName, addressLine, city, state, zip } = req.body ?? {};
    if (!validNames(firstName, lastName)) {
        return res.status(400).json({ message: 'Enter valid first and last names.' });
    }

    const address = [addressLine, city, state, zip];
    const limits = [255, 100, 2, 10];
    if (address.some((value, index) => value != null &&
        (typeof value !== 'string' || Array.from(value.trim()).length > limits[index]))) {
        return res.status(400).json({ message: 'Check the lengths of the address fields.' });
    }
    const addressValues = address.map((value) => value?.trim() || null);
    if (addressValues.some(Boolean) && addressValues.some((value) => value === null)) {
        return res.status(400).json({ message: 'Address line, city, state, and ZIP code cannot be null when an address is provided.' });
    }
    if (addressValues[3] !== null && (zip.length !== 5 || !/^[0-9]{5}$/.test(zip))) {
        return res.status(400).json({ message: 'ZIP code must be exactly five digits.' });
    }

    const [result] = await db.execute(
        `UPDATE customers SET first_name = ?, last_name = ?,
         address_line = ?, city = ?, state = ?, zip = ? WHERE customer_id = ?`,
        [firstName, lastName, ...addressValues, req.session.customerId]
    );
    if (!result.affectedRows) {
        return res.status(401).json({ message: 'Please log in to edit your profile.' });
    }
    res.json({ message: 'Profile updated.' });
});

const signedOutLink = '<a href="login.html" id="loginBtn">Login / Register</a>';
const signedInMenu = `<details class="account-menu">
    <summary aria-label="Account menu">
        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
    </summary>
    <div class="account-menu-options">
        <a href="profile.html">Profiles</a>
        <form method="post" action="/api/logout">
            <button type="submit">Sign Out</button>
        </form>
    </div>
</details>`;

async function servePage(req, res) {
    const filename = req.path === '/' ? 'index.html' : req.path.slice(1);
    try {
        const html = await readFile(path.join(siteRoot, filename), 'utf8');
        res.set('Cache-Control', 'no-store');
        res.type('html').send(req.session.customerId ? html.replace(signedOutLink, signedInMenu) : html);
    } catch (error) {
        if (error.code === 'ENOENT') return res.sendStatus(404);
        throw error;
    }
}

app.get('/', servePage);
app.get(/^\/[a-zA-Z-]+\.html$/, servePage);

app.use((error, req, res, next) => {
    if (res.headersSent) return next(error);
    if (error.status === 400 || error.status === 413) {
        return res.status(error.status).json({ message: 'Invalid request.' });
    }
    console.error('Request failed:', error.code || error.name);
    res.status(500).json({ message: 'Something went wrong. Please try again.' });
});

app.listen(Number(PORT), 'localhost', () => {
    console.log(`Music site running at http://localhost:${PORT}/login.html`);
});
