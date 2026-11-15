from django.urls import path
from . import views

urlpatterns = [
    path('', views.home_view, name='home'),
    path('store/', views.store_view, name='store'),
    path('blog/', views.blog_view, name='blog'),
    path('contact/', views.contact_view, name='contact'),
    path('elements/', views.elements_view, name='elements'),
    path('event/', views.event_view, name='event'),
    path('login/', views.login_view, name='login'),
    path('signin/', views.signin_view, name='signin'),
    path('signup/', views.signup_view, name='signup'),
    path('profile/', views.profile_view, name='profile'),
]