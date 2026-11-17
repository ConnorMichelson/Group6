from django import forms
from .customer_accounts import HASHER
from django.contrib import admin

# Register your models here.
from .models import CartItems, Carts, Customers, DiscountCodes, OrderItems, Orders, Products, WishlistItems

admin.site.register(CartItems)
admin.site.register(Carts)
#admin.site.register(Customers)
#admin.site.register(DiscountCodes)
admin.site.register(OrderItems)
#admin.site.register(Orders)
#admin.site.register(Products)
admin.site.register(WishlistItems)



# ---------- Orders: current orders + order history (sort by date, customer, total) ----------

class OrderItemsInline(admin.TabularInline):
    model = OrderItems
    extra = 0
    can_delete = False
    fields = ('product_name', 'artist', 'quantity', 'price_at_purchase', 'was_on_sale')
    readonly_fields = fields


@admin.register(Orders)
class OrdersAdmin(admin.ModelAdmin):
    list_display = ('order_id', 'order_date', 'customer_email', 'status', 'total')
    list_filter = ('status', 'order_date')
    list_editable = ('status',)
    search_fields = ('customer__email', 'customer__first_name', 'customer__last_name')
    ordering = ('-order_date',)
    date_hierarchy = 'order_date'
    readonly_fields = ('customer', 'order_date', 'subtotal', 'discount_code', 'discount_code_0',
                       'discount_amount', 'tax_rate', 'tax', 'total')
    inlines = [OrderItemsInline]

    @admin.display(description='Customer', ordering='customer__email')
    def customer_email(self, order):
        return order.customer.email


# ---------- Products: inventory + sale items ----------

@admin.register(Products)
class ProductsAdmin(admin.ModelAdmin):
    list_display = ('name', 'artist', 'format', 'price', 'sale_price', 'quantity', 'status')
    list_editable = ('price', 'sale_price', 'quantity', 'status')
    list_filter = ('status', 'format', 'genre')
    search_fields = ('name', 'artist', 'genre')
    ordering = ('artist', 'name')


# ---------- Discount codes ----------

@admin.register(DiscountCodes)
class DiscountCodesAdmin(admin.ModelAdmin):
    list_display = ('code', 'discount_type', 'value', 'min_order', 'expires_at', 'active')
    list_editable = ('active',)
    list_filter = ('active', 'discount_type')
    search_fields = ('code',)


# ---------- Customers: edit users + set a new password ----------

class CustomerForm(forms.ModelForm):
    new_password = forms.CharField(
        required=False, widget=forms.PasswordInput(render_value=False),
        help_text='Leave blank to keep the current password.')

    class Meta:
        model = Customers
        exclude = ('password_hash',)

    def clean(self):
        cleaned = super().clean()
        if not self.instance.pk and not cleaned.get('new_password'):
            self.add_error('new_password', 'A password is required for a new customer.')
        return cleaned

    def save(self, commit=True):
        customer = super().save(commit=False)
        password = self.cleaned_data.get('new_password')
        if password:
            customer.password_hash = HASHER.encode(password, HASHER.salt())
        if commit:
            customer.save()
        return customer


@admin.register(Customers)
class CustomersAdmin(admin.ModelAdmin):
    form = CustomerForm
    list_display = ('email', 'first_name', 'last_name', 'is_admin', 'created_at')
    list_filter = ('is_admin',)
    search_fields = ('email', 'first_name', 'last_name')