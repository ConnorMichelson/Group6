from django.contrib.staticfiles import finders
from django.db.models import Count, Q
from django.shortcuts import redirect, render
from django.utils import timezone
from django.views.decorators.cache import never_cache

from .models import Orders, Products
from .customer_accounts import SESSION_KEY
from .cart import on_sale

# Create your views here.

def catalog_cover(product):
    cover = f'core/{product.image_url}' if product.image_url else ''
    return cover if cover and finders.find(cover) else None


def home_view(request):
    albums = []
    now = timezone.now()
    for product in Products.objects.filter(status='active').order_by('product_id'):
        product.cover = catalog_cover(product)
        if product.cover:
            product.on_sale = on_sale(product, now)
            albums.append(product)
        if len(albums) == 26:
            break
    hero_images = ('core/img/bg-img/bg-1.jpg', 'core/img/bg-img/bg-2.jpg')
    return render(request, 'core/index.html', {
        'home_albums': albums[:8],
        'buy_now_albums': albums[8:20],
        'hot_albums': albums[20:26],
        'hero_images': hero_images,
    })

def shop_view(request):
    now = timezone.now()
    query = request.GET.get('q', '').strip()
    sort = request.GET.get('sort', 'artist')
    genres = request.GET.getlist('genre')
    artists = request.GET.getlist('artist')
    in_stock = request.GET.get('availability') == 'in-stock' or sort == 'in-stock'
    sale_only = request.GET.get('sale') == 'yes' or sort == 'sale'
    catalog = Products.objects.filter(status='active')
    genre_options = catalog.exclude(genre__isnull=True).exclude(genre='').values_list('genre', flat=True).order_by('genre').distinct()
    artist_options = catalog.values('artist').annotate(count=Count('pk')).order_by('artist')
    products = catalog.order_by('artist', 'name', 'product_id')
    if query:
        products = products.filter(Q(name__icontains=query) | Q(artist__icontains=query) | Q(genre__icontains=query))
    if genres:
        products = products.filter(genre__in=genres)
    if artists:
        products = products.filter(artist__in=artists)
    if in_stock:
        products = products.filter(quantity__gt=0)
    products = list(products)
    visible_products = []
    for product in products:
        product.on_sale = on_sale(product, now)
        if sale_only and not product.on_sale:
            continue
        product.cart_quantity = request.session.get('album_cart', {}).get(str(product.pk), 0)
        product.cover = catalog_cover(product)
        visible_products.append(product)
    products = visible_products
    if sort in ('price', 'price-desc'):
        products.sort(key=lambda product: product.sale_price if product.on_sale else product.price,
                      reverse=sort == 'price-desc')
    elif sort in ('stock-asc', 'stock-desc'):
        products.sort(key=lambda product: product.quantity, reverse=sort == 'stock-desc')
    elif sort == 'genre':
        products.sort(key=lambda product: (not product.genre, (product.genre or '').casefold()))
    elif sort == 'name':
        products.sort(key=lambda product: product.name.casefold())
    else:
        sort = 'artist'
    return render(request, 'core/shop.html', {
        'products': products, 'query': query, 'sort': sort,
        'genre_options': genre_options, 'artist_options': artist_options,
        'genres': genres, 'artists': artists, 'in_stock': in_stock, 'sale_only': sale_only,
    })

def contact_view(request):
    return render(request, 'core/contact.html')

def elements_view(request):
    return render(request, 'core/elements.html')

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
    sort = request.GET.get('sort', 'newest')
    ordering = {'newest': ('-order_date', '-pk'), 'oldest': ('order_date', 'pk'),
                'price-asc': ('total', '-order_date', '-pk'), 'price-desc': ('-total', '-order_date', '-pk')}
    if sort not in ordering:
        sort = 'newest'
    orders = (Orders.objects.filter(customer_id=customer_id)
              .prefetch_related('orderitems_set__product').order_by(*ordering[sort]))
    for order in orders:
        order.history_items = list(order.orderitems_set.all())
        for item in order.history_items:
            item.cover = catalog_cover(item.product)
            item.line_total = item.price_at_purchase * item.quantity
            item.sale_savings = max(0, item.product.price - item.price_at_purchase) * item.quantity if item.was_on_sale else 0
    return render(request, 'core/order-history.html', {'orders': orders, 'history_sort': sort})
