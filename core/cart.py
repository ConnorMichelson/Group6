from decimal import Decimal, ROUND_HALF_UP
from uuid import uuid4

from django.contrib.sessions.models import Session
from django.contrib.staticfiles import finders
from django.db import transaction
from django.db.models import F
from django.http import JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.utils import timezone
from django.views.decorators.http import require_POST

from .customer_accounts import SESSION_KEY
from .models import Customers, DiscountCodes, OrderItems, Orders, Products


TAX_RATE = Decimal('0.0825')


def on_sale(product, now):
    return (product.sale_price is not None
            and (product.sale_start is None or product.sale_start <= now)
            and (product.sale_end is None or now < product.sale_end))


def save_cart(session, quantities):
    session['album_cart'] = quantities
    session['cart_count'] = sum(quantities.values())
    session['cart_version'] = uuid4().hex
    if not quantities:
        session.pop('cart_discount', None)


def cart_details(quantities, products, code=''):
    now = timezone.now()
    rows = []
    for product in products:
        count = quantities[str(product.pk)]
        sale = on_sale(product, now)
        price = product.sale_price if sale else product.price
        cover = f'core/{product.image_url}' if product.image_url else ''
        rows.append({'product': product, 'count': count, 'price': price, 'sale': sale,
                     'cover': cover if cover and finders.find(cover) else None,
                     'total': price * count,
                     'sale_savings': (product.price - price) * count,
                     'available': product.status == 'active' and count <= product.quantity})
    subtotal = sum((row['total'] for row in rows), Decimal('0.00'))
    discount = DiscountCodes.objects.filter(code__iexact=code, active=True).first() if code and subtotal else None
    discount_error = ''
    amount = Decimal('0.00')
    if code:
        if not discount or (discount.expires_at and discount.expires_at <= now):
            discount = None
            discount_error = 'That discount code is invalid, inactive, or expired.'
        elif subtotal < discount.min_order:
            discount_error = f'This code requires a subtotal of at least ${discount.min_order:.2f}.'
            discount = None
        else:
            amount = discount.value if discount.discount_type == 'flat' else subtotal * discount.value / 100
            amount = min(subtotal, amount.quantize(Decimal('0.01'), rounding=ROUND_HALF_UP))
    discounted_subtotal = subtotal - amount
    tax = (discounted_subtotal * TAX_RATE).quantize(Decimal('0.01'), rounding=ROUND_HALF_UP)
    return {'rows': rows, 'subtotal': subtotal, 'tax': tax, 'total': discounted_subtotal + tax,
            'sale_savings_total': sum((row['sale_savings'] for row in rows), Decimal('0.00')),
            'discount': discount, 'discount_amount': amount, 'discounted_subtotal': discounted_subtotal,
            'discount_error': discount_error, 'discount_input': code,
            'can_checkout': bool(rows) and len(rows) == len(quantities)
            and all(row['available'] for row in rows),
            'missing': set(quantities) - {str(row['product'].pk) for row in rows}}


def cart_page(request, code=None):
    quantities = request.session.get('album_cart', {})
    context = cart_details(quantities, Products.objects.filter(pk__in=quantities).order_by('name', 'pk'),
                           request.session.get('cart_discount', '') if code is None else code)
    if code is not None:
        if context['discount']:
            request.session['cart_discount'] = context['discount'].code
        else:
            request.session.pop('cart_discount', None)
        save_cart(request.session, quantities)
    context['cart_version'] = request.session.get('cart_version', '')
    return render(request, 'core/cart.html', context)


@require_POST
def apply_discount(request):
    return cart_page(request, request.POST.get('discount_code', '').strip()[:51])


@require_POST
def add(request, product_id):
    wants_json = request.headers.get('Accept') == 'application/json'
    product = get_object_or_404(Products, pk=product_id, status='active')
    quantities = request.session.get('album_cart', {}).copy()
    key = str(product_id)
    count = quantities.get(key, 0)
    if count >= product.quantity:
        if not wants_json:
            return redirect('shop')
        return JsonResponse({'message': 'No more copies are available.'}, status=409)
    quantities[key] = count + 1
    save_cart(request.session, quantities)
    if not wants_json:
        return redirect('shop')
    price = product.sale_price if on_sale(product, timezone.now()) else product.price
    return JsonResponse({'quantity': count + 1, 'count': request.session['cart_count'],
                         'subtotal': str(price * (count + 1)), 'at_limit': count + 1 >= product.quantity})


@require_POST
def change_quantity(request, product_id):
    quantities = request.session.get('album_cart', {}).copy()
    key = str(product_id)
    if key not in quantities:
        return redirect('cart')
    action = request.POST.get('action')
    if action == 'decrease':
        quantities[key] -= 1
        if quantities[key] == 0:
            del quantities[key]
    elif action == 'increase':
        product = get_object_or_404(Products, pk=product_id)
        if product.status != 'active' or quantities[key] >= product.quantity:
            return redirect('cart')
        quantities[key] += 1
    else:
        return redirect('cart')
    save_cart(request.session, quantities)
    return redirect('cart')


@require_POST
def remove(request, product_id):
    quantities = request.session.get('album_cart', {}).copy()
    quantities.pop(str(product_id), None)
    save_cart(request.session, quantities)
    return redirect('cart')


@require_POST
def checkout(request):
    customer_id = request.session.get(SESSION_KEY)
    if not customer_id:
        return redirect('/login/?next=cart')
    if request.POST.get('demo_confirmed') != 'yes':
        return redirect('cart')

    with transaction.atomic():
        # Re-read the persisted cart under lock so the same checkout cannot create two orders.
        saved = Session.objects.select_for_update().filter(session_key=request.session.session_key).first()
        current = saved.get_decoded() if saved else {}
        quantities = current.get('album_cart', {})
        if not quantities or current.get(SESSION_KEY) != customer_id or current.get('cart_version') != request.POST.get('version'):
            return redirect('cart')
        customer = get_object_or_404(Customers, pk=customer_id)
        products = list(Products.objects.select_for_update().filter(pk__in=quantities).order_by('pk'))
        details = cart_details(quantities, products, current.get('cart_discount', ''))
        if not details['can_checkout']:
            details.update(error='Stock changed. Remove unavailable albums before checking out.',
                           cart_version=current['cart_version'])
            return render(request, 'core/cart.html', details, status=409)
        if details['discount_error']:
            request.session.pop('cart_discount', None)
            save_cart(request.session, quantities)
            details['cart_version'] = request.session['cart_version']
            return render(request, 'core/cart.html', details, status=409)
        discount = details['discount']
        order = Orders.objects.create(customer=customer, subtotal=details['subtotal'],
                                      tax=details['tax'], tax_rate=TAX_RATE, total=details['total'],
                                      discount_code=discount, discount_code_0=discount.code if discount else None,
                                      discount_amount=details['discount_amount'])
        OrderItems.objects.bulk_create([
            OrderItems(order=order, product=row['product'], product_name=row['product'].name,
                       artist=row['product'].artist, quantity=row['count'],
                       price_at_purchase=row['price'], was_on_sale=row['sale'])
            for row in details['rows']
        ])
        for row in details['rows']:
            product = row['product']
            product.quantity -= row['count']
            product.save(update_fields=['quantity', 'updated_at'])
        save_cart(request.session, {})
        request.session.save()
    return redirect('order-success', order_id=order.pk)


def order_success(request, order_id):
    if not request.session.get(SESSION_KEY):
        return redirect('login')
    order = get_object_or_404(Orders, pk=order_id, customer_id=request.session[SESSION_KEY])
    items = order.orderitems_set.select_related('product').annotate(line_total=F('price_at_purchase') * F('quantity'))
    for item in items:
        cover = f'core/{item.product.image_url}' if item.product.image_url else ''
        item.cover = cover if cover and finders.find(cover) else None
        item.sale_savings = max(0, item.product.price - item.price_at_purchase) * item.quantity if item.was_on_sale else 0
    return render(request, 'core/order-success.html', {'order': order, 'order_items': items})
