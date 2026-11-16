from django.contrib.staticfiles import finders
from django.db.models import Q
from django.shortcuts import redirect, render
from django.utils import timezone
from django.views.decorators.cache import never_cache

from .models import Orders, Products
from .customer_accounts import SESSION_KEY
from .cart import on_sale

# Create your views here.

def home_view(request):
    return render(request, 'core/index.html')

def shop_view(request):
    now = timezone.now()
    query = request.GET.get('q', '').strip()
    sort = request.GET.get('sort', 'artist')
    products = Products.objects.filter(status='active').order_by('artist', 'name', 'product_id')
    if query:
        products = products.filter(Q(name__icontains=query) | Q(artist__icontains=query) | Q(genre__icontains=query))
    if sort == 'in-stock':
        products = products.filter(quantity__gt=0)
    products = list(products)
    for product in products:
        initial = product.artist.strip()[:1].lower()
        product.artist_filter = initial if initial and initial in 'abcdefghijklmnopqrstuvwxyz' else 'number'
        product.on_sale = on_sale(product, now)
        product.cart_quantity = request.session.get('album_cart', {}).get(str(product.pk), 0)
        cover = f'core/{product.image_url}' if product.image_url else ''
        product.cover = cover if cover and finders.find(cover) else None
    if sort in ('price', 'price-desc'):
        products.sort(key=lambda product: product.sale_price if product.on_sale else product.price,
                      reverse=sort == 'price-desc')
    elif sort == 'sale':
        products = [product for product in products if product.on_sale]
    elif sort == 'genre':
        products.sort(key=lambda product: (not product.genre, (product.genre or '').casefold()))
    elif sort == 'name':
        products.sort(key=lambda product: product.name.casefold())
    elif sort != 'in-stock':
        sort = 'artist'
    return render(request, 'core/shop.html', {'products': products, 'query': query, 'sort': sort})

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

def profile_view(request):
    if not request.session.get('customer_id'):
        return redirect('login')
    return render(request, 'core/profile.html')


@never_cache
def order_history_view(request):
    customer_id = request.session.get(SESSION_KEY)
    if not customer_id:
        return redirect('login')
    orders = (Orders.objects.filter(customer_id=customer_id)
              .prefetch_related('orderitems_set').order_by('-order_date', '-pk'))
    return render(request, 'core/order-history.html', {'orders': orders})
