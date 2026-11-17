from django.urls import path
from django.views.generic import RedirectView
from . import cart, customer_accounts, views

urlpatterns = [
    path('', views.home_view, name='home'),
    path('shop/', views.shop_view, name='shop'),
    path('store/', RedirectView.as_view(pattern_name='shop'), name='store'),
    path('contact/', views.contact_view, name='contact'),
    path('elements/', views.elements_view, name='elements'),
    path('login/', views.login_view, name='login'),
    path('profile/', views.profile_view, name='profile'),
    path('profile/orders/', views.order_history_view, name='order-history'),
    path('cart/', cart.cart_page, name='cart'),
    path('cart/discount/', cart.apply_discount, name='cart-discount'),
    path('cart/add/<int:product_id>/', cart.add, name='cart-add'),
    path('cart/remove/<int:product_id>/', cart.remove, name='cart-remove'),
    path('cart/checkout/', cart.checkout, name='cart-checkout'),
    path('orders/<int:order_id>/success/', cart.order_success, name='order-success'),
    path('api/register', customer_accounts.register, name='customer-register'),
    path('api/login', customer_accounts.login, name='customer-login'),
    path('api/logout', customer_accounts.logout, name='customer-logout'),
    path('api/profile', customer_accounts.profile, name='customer-profile'),
]
