const shopCurrency = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' });

document.querySelectorAll('.shop-add:not(:disabled)').forEach((button) => {
    const preview = button.nextElementSibling;
    const available = Number(button.dataset.stock);
    const unitCents = Math.round(Number(button.dataset.price) * 100);
    let quantity = 0;

    button.addEventListener('click', () => {
        if (quantity >= available) return;

        quantity += 1;
        button.querySelector('.shop-add-plus').hidden = false;
        button.setAttribute('aria-label', 'Add to cart: add another copy of ' + button.dataset.album);
        button.disabled = quantity >= available;
        preview.textContent = quantity + ' selected · ' + shopCurrency.format(quantity * unitCents / 100);
    });
});
