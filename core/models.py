# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class CartItems(models.Model):
    cart_item_id = models.AutoField(primary_key=True)
    cart = models.ForeignKey('Carts', models.DO_NOTHING)
    product = models.ForeignKey('Products', models.DO_NOTHING)
    quantity = models.IntegerField()
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'cart_items'
        unique_together = (('cart', 'product'),)
        verbose_name_plural = 'CartItems'

class Carts(models.Model):
    cart_id = models.AutoField(primary_key=True)
    customer = models.OneToOneField('Customers', models.DO_NOTHING)
    discount_code = models.ForeignKey('DiscountCodes', models.DO_NOTHING, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'carts'
        verbose_name_plural = 'Carts'


class Customers(models.Model):
    customer_id = models.AutoField(primary_key=True)
    email = models.CharField(unique=True, max_length=255)
    password_hash = models.CharField(max_length=255)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    address_line = models.CharField(max_length=255, blank=True, null=True)
    city = models.CharField(max_length=100, blank=True, null=True)
    state = models.CharField(max_length=2, blank=True, null=True)
    zip = models.CharField(max_length=10, blank=True, null=True)
    is_admin = models.BooleanField(default=False)    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'customers'
        verbose_name_plural = 'Customers'

    def __str__(self):          
        return self.email


class DiscountCodes(models.Model):
    code_id = models.AutoField(primary_key=True)
    code = models.CharField(unique=True, max_length=50)
    description = models.CharField(max_length=255, blank=True, null=True)
    discount_type = models.CharField(max_length=7, choices=[('percent', 'Percent'), ('flat', 'Flat')])
    value = models.DecimalField(max_digits=10, decimal_places=2)
    min_order = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    expires_at = models.DateTimeField(blank=True, null=True)
    active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'discount_codes'
        verbose_name_plural = 'DiscountCodes'


class OrderItems(models.Model):
    order_item_id = models.AutoField(primary_key=True)
    order = models.ForeignKey('Orders', models.DO_NOTHING)
    product = models.ForeignKey('Products', models.DO_NOTHING)
    product_name = models.CharField(max_length=255)
    artist = models.CharField(max_length=255)
    quantity = models.IntegerField()
    price_at_purchase = models.DecimalField(max_digits=10, decimal_places=2)
    was_on_sale = models.BooleanField(default=False)

    class Meta:
        managed = False
        db_table = 'order_items'
        verbose_name_plural = 'OrderItems'


class Orders(models.Model):
    order_id = models.AutoField(primary_key=True)
    customer = models.ForeignKey(Customers, models.DO_NOTHING)
    order_date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=10, choices=[('placed', 'Placed'), ('processing', 'Processing'), ('shipped', 'Shipped'), ('completed', 'Completed'), ('cancelled', 'Cancelled')], default='placed')
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)
    discount_code = models.ForeignKey(DiscountCodes, models.DO_NOTHING, blank=True, null=True)
    discount_code_0 = models.CharField(db_column='discount_code', max_length=50, blank=True, null=True)  # Field renamed because of name conflict.
    discount_amount = models.DecimalField(max_digits=10, decimal_places=2)
    tax_rate = models.DecimalField(max_digits=5, decimal_places=4)
    tax = models.DecimalField(max_digits=10, decimal_places=2)
    total = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'orders'
        verbose_name_plural = 'Orders'

    def __str__(self):       
        return f'Order #{self.order_id}'  


class Products(models.Model):
    product_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    artist = models.CharField(max_length=255)
    genre = models.CharField(max_length=50, blank=True, null=True)
    format = models.CharField(max_length=5, choices=[('Vinyl', 'Vinyl'), ('CD', 'CD')], default='Vinyl')
    release_year = models.PositiveSmallIntegerField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    image_url = models.CharField(max_length=500, blank=True, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.IntegerField(default=0)
    sale_price = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    sale_start = models.DateTimeField(blank=True, null=True)
    sale_end = models.DateTimeField(blank=True, null=True)
    status = models.CharField(max_length=12, choices=[('active', 'Active'), ('coming_soon', 'Coming soon'), ('discontinued', 'Discontinued')], default='active')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    class Meta:
        managed = False
        db_table = 'products'
        verbose_name_plural = 'Products'

    def __str__(self): 
        return f'{self.name} - {self.artist}'  


class WishlistItems(models.Model):
    #pk = models.CompositePrimaryKey('customer_id', 'product_id') 
    wishlist_item_id = models.AutoField(primary_key=True)
    customer = models.ForeignKey(Customers, models.DO_NOTHING)
    product = models.ForeignKey(Products, models.DO_NOTHING)
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'wishlist_items'
        unique_together = (('customer', 'product'),)
        verbose_name_plural = 'WishlistItems'
