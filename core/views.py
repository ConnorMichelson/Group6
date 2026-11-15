from django.shortcuts import render

# Create your views here.

def home_view(request):
    return render(request, 'core/index.html')

def store_view(request):
    return render(request, 'core/albums-store.html')

def blog_view(request):
    return render(request, 'core/blog.html')

def contact_view(request):
    return render(request, 'core/contact.html')

def elements_view(request):
    return render(request, 'core/elements.html')

def event_view(request):
    return render(request, 'core/event.html')

def login_view(request):
    return render(request, 'core/login.html')

def signin_view(request):
    return render(request, 'core/signIn.html')

def signup_view(request):
    return render(request, 'core/signup.html')

def profile_view(request):
    return render(request, 'core/profile.html')
