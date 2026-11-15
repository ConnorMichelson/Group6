const accountHeading = document.getElementById("account-heading");
const loginButton = document.getElementById("show-login");
const registerButton = document.getElementById("show-register");
const loginForm = document.getElementById("login-form");
const registerForm = document.getElementById("register-form");
const registrationStatus = document.getElementById("registration-status");
const loginStatus = document.getElementById("login-status");
const loginEmail = document.getElementById("exampleInputEmail1");
const loginPassword = document.getElementById("exampleInputPassword1");
const registerPassword = document.getElementById("register-password");
const passwordToggles = [
  {
    input: loginPassword,
    button: document.getElementById("toggle-login-password"),
  },
  {
    input: registerPassword,
    button: document.getElementById("toggle-register-password"),
  },
].filter(({ button }) => button);

function setPasswordVisibility({ input, button }, visible) {
  input.type = visible ? "text" : "password";
  button.setAttribute(
    "aria-label",
    visible ? "Hide password" : "Show password",
  );
  button.firstElementChild.className = visible
    ? "bi bi-eye"
    : "bi bi-eye-slash";
}

for (const toggle of passwordToggles) {
  toggle.button.addEventListener("click", () =>
    setPasswordVisibility(toggle, toggle.input.type === "password"),
  );
}

function showAccountForm(registering) {
  accountHeading.textContent = registering ? "Sign Up Now" : "Welcome Back";
  loginForm.hidden = registering;
  registerForm.hidden = !registering;
  loginButton.setAttribute("aria-pressed", String(!registering));
  registerButton.setAttribute("aria-pressed", String(registering));
  loginButton.classList.toggle("btn-dark", !registering);
  loginButton.classList.toggle("btn-outline-dark", registering);
  registerButton.classList.toggle("btn-dark", registering);
  registerButton.classList.toggle("btn-outline-dark", !registering);
  registrationStatus.textContent = "";
  loginStatus.textContent = "";
  passwordToggles.forEach((toggle) => setPasswordVisibility(toggle, false));
}

loginButton.addEventListener("click", () => showAccountForm(false));
registerButton.addEventListener("click", () => showAccountForm(true));
loginForm.querySelector("form").addEventListener("submit", async (event) => {
  const result = await submitAccountForm(
    event,
    "/api/login",
    {
      email: loginEmail.value,
      password: loginPassword.value,
    },
    loginStatus,
  );
  if (result) window.location.assign("index.html");
});

[loginEmail, loginPassword, ...registerForm.querySelectorAll("input")].forEach(
  (input) => {
    const error = document.createElement("small");
    error.id = input.id + "-error";
    error.className = "form-text text-danger";
    error.setAttribute("aria-live", "polite");
    input.closest(".form-group").append(error);
    const description = input.getAttribute("aria-describedby");
    input.setAttribute(
      "aria-describedby",
      description ? description + " " + error.id : error.id,
    );

    function showFieldError() {
      const formatError =
        input.validity.typeMismatch ||
        input.validity.patternMismatch ||
        input.validity.tooShort;
      error.textContent =
        (formatError && (input.dataset.error || input.title)) ||
        input.validationMessage;
      input.setAttribute("aria-invalid", String(!input.validity.valid));
    }

    input.addEventListener("blur", showFieldError);
    input.addEventListener("invalid", (event) => {
      event.preventDefault();
      showFieldError();
    });
    input.addEventListener("input", () => {
      if (input.validity.valid) {
        error.textContent = "";
        input.removeAttribute("aria-invalid");
      }
    });
  },
);

async function submitAccountForm(event, url, fields, status) {
  event.preventDefault();
  const submitButton = event.currentTarget.querySelector(
    'button[type="submit"]',
  );
  submitButton.disabled = true;
  status.textContent = "";
  try {
    const response = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(fields),
    });
    const result = await response.json();
    if (response.ok) return result;
    status.classList.add("text-danger");
    status.textContent = result.message;
  } catch {
    status.classList.add("text-danger");
    status.textContent =
      "Could not reach the account server. Please try again.";
  } finally {
    submitButton.disabled = false;
  }
  return null;
}

registerForm.querySelector("form").addEventListener("submit", async (event) => {
  const form = event.currentTarget;
  const email = document.getElementById("register-email").value;
  const result = await submitAccountForm(
    event,
    "/api/register",
    {
      firstName: document.getElementById("register-first-name").value,
      lastName: document.getElementById("register-last-name").value,
      email,
      password: registerPassword.value,
    },
    registrationStatus,
  );
  if (!result) return;

  form.reset();
  showAccountForm(false);
  loginEmail.value = email;
  loginPassword.value = "";
  loginStatus.classList.remove("text-danger");
  loginStatus.textContent = result.message;
  loginPassword.focus();
});

document.getElementById("copyright-year").textContent =
  new Date().getFullYear();
