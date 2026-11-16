const checkoutForm = document.getElementById('demo-checkout');

if (checkoutForm) {
    const checkoutButton = checkoutForm.querySelector('button[type="submit"]');
    checkoutForm.addEventListener('submit', () => {
        checkoutForm.elements.demo_confirmed.value = 'yes';
        checkoutButton.disabled = true;
    });
    checkoutButton.disabled = false;
}
