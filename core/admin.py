from django.contrib import admin

# Register your models here.
from .models import CartItems, Carts, Customers, DiscountCodes, OrderItems, Orders, Products, WishlistItems

admin.site.register(CartItems)
admin.site.register(Carts)
admin.site.register(Customers)
admin.site.register(DiscountCodes)
admin.site.register(OrderItems)
admin.site.register(Orders)
admin.site.register(Products)
admin.site.register(WishlistItems)