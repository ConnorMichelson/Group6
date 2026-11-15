from django.urls import path
from django.views.generic import RedirectView
from . import customer_accounts, views

urlpatterns = [
    path('', views.home_view, name='home'),
    path('shop/', views.shop_view, name='shop'),
    path('store/', RedirectView.as_view(pattern_name='shop'), name='store'),
    path('blog/', views.blog_view, name='blog'),
    path('contact/', views.contact_view, name='contact'),
    path('elements/', views.elements_view, name='elements'),
    path('event/', views.event_view, name='event'),
    path('login/', views.login_view, name='login'),
    path('profile/', views.profile_view, name='profile'),
    path('api/register', customer_accounts.register, name='customer-register'),
    path('api/login', customer_accounts.login, name='customer-login'),
    path('api/logout', customer_accounts.logout, name='customer-logout'),
    path('api/profile', customer_accounts.profile, name='customer-profile'),
]
