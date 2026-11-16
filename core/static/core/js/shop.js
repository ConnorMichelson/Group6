const shopCurrency = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });
let pendingCartUpdate = Promise.resolve();

document.querySelectorAll('.shop-cart-form').forEach((form) => {
    const button = form.querySelector('button');
    const preview = form.querySelector('.shop-cart-preview');

    form.addEventListener('submit', (event) => {
        event.preventDefault();
        if (button.disabled) return;
        button.disabled = true;
        pendingCartUpdate = pendingCartUpdate.then(async () => {
            try {
                const response = await fetch(form.action, {
                    method: 'POST',
                    headers: { Accept: 'application/json' },
                    body: new FormData(form),
                });
                const data = await response.json();
                if (!response.ok) {
                    preview.textContent = data.message;
                    button.disabled = response.status === 409;
                    return;
                }
                document.querySelectorAll('[data-cart-count]').forEach((badge) => {
                    badge.textContent = data.count;
                });
                button.querySelector('.shop-add-plus').hidden = false;
                preview.textContent = data.quantity + ' in cart · ' + shopCurrency.format(data.subtotal);
                button.disabled = data.at_limit;
            } catch {
                preview.textContent = 'Could not add this album. Try again.';
                button.disabled = false;
            }
        });
    });
});
