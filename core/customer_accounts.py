import json
import re
import unicodedata

import bcrypt
from django.contrib.auth import login as admin_login, logout as admin_logout
from django.contrib.auth.hashers import BCryptSHA256PasswordHasher
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.db import IntegrityError
from django.http import JsonResponse
from django.shortcuts import redirect
from django.utils import timezone
from django.views.decorators.cache import never_cache
from django.views.decorators.http import require_POST, require_http_methods

from .models import Customers


SESSION_KEY = 'customer_id'
HASHER = BCryptSHA256PasswordHasher()
ADDRESS_FIELDS = {'addressLine': ('address_line', 255), 'city': ('city', 100),
                  'state': ('state', 2), 'zip': ('zip', 5)}


def payload(request):
    if request.content_type != 'application/json' or len(request.body) > 8192:
        return {}
    try:
        data = json.loads(request.body)
    except (ValueError, UnicodeError):
        return {}
    return data if isinstance(data, dict) else {}


def error(message, status=400):
    return JsonResponse({'message': message}, status=status)


def valid_name(name):
    return isinstance(name, str) and 0 < len(name) <= 100 and all(
        char in '_-' or unicodedata.category(char)[0] in 'LM' for char in name
    )


def valid_email(email):
    if not isinstance(email, str) or len(email) > 255 or '.' not in email.rpartition('@')[2]:
        return False
    try:
        validate_email(email)
    except ValidationError:
        return False
    return True


def valid_password(password):
    return (
        isinstance(password, str) and 6 <= len(password) <= 1024
        and any(unicodedata.category(char) == 'Lu' for char in password)
        and any(char in '0123456789' for char in password)
        and any(unicodedata.category(char)[0] in 'PS' for char in password)
    )


@require_POST
def register(request):
    data = payload(request)
    first, last, email, password = (data.get(key) for key in ('firstName', 'lastName', 'email', 'password'))
    if not valid_name(first) or not valid_name(last) or not valid_email(email) or not valid_password(password):
        return error('Check your name, email, and password.')

    now = timezone.now()
    try:
        Customers.objects.create(first_name=first, last_name=last, email=email,
                                 password_hash=HASHER.encode(password, HASHER.salt()),
                                 is_admin=0, created_at=now, updated_at=now)
    except IntegrityError as exc:
        if exc.args[0] != 1062:
            raise
        return error('An account already exists for that email. Please log in.', 409)
    return JsonResponse({'message': 'Account created. You can now log in.'}, status=201)


@require_POST
def login(request):
    data = payload(request)
    email, password = data.get('email'), data.get('password')
    if not valid_email(email) or not isinstance(password, str) or not 0 < len(password) <= 1024:
        return error('Email or password is incorrect.', 401)
    customer = Customers.objects.filter(email=email).first()
    if not customer:
        return error('Email or password is incorrect.', 401)

    stored = customer.password_hash
    try:
        if stored.startswith(('$2a$', '$2b$', '$2y$')):
            raw = password.encode('utf-8')
            matched = len(raw) <= 72 and bcrypt.checkpw(raw, stored.encode('ascii'))
        else:
            matched = stored.startswith('bcrypt_sha256$') and HASHER.verify(password, stored)
    except (ValueError, UnicodeError):
        matched = False
    if not matched:
        return error('Email or password is incorrect.', 401)

    #request.session.cycle_key()
    #Admin acct
    if customer.is_admin:
        user, _ = User.objects.get_or_create(username=customer.email)
        user.email = customer.email
        user.is_staff = True
        user.is_superuser = True
        user.set_unusable_password()
        user.save()
        admin_login(request, user, backend='django.contrib.auth.backends.ModelBackend')
    elif request.user.is_authenticated:
        admin_logout(request)
    else:
        request.session.cycle_key()
        request.session[SESSION_KEY] = customer.pk
        return JsonResponse({'message': 'Logged in.'})


@require_POST
def logout(request):
    request.session.pop(SESSION_KEY, None)
    if request.user.is_authenticated:   
        admin_logout(request)           
    request.session.cycle_key()
    return redirect('home')


@never_cache
@require_http_methods(['GET', 'PUT'])
def profile(request):
    customer = Customers.objects.filter(pk=request.session.get(SESSION_KEY)).first()
    if not customer:
        request.session.pop(SESSION_KEY, None)
        return error('Please log in to view your profile.', 401)
    if request.method == 'GET':
        return JsonResponse({
            'firstName': customer.first_name, 'lastName': customer.last_name, 'email': customer.email,
            **{key: getattr(customer, field) for key, (field, _) in ADDRESS_FIELDS.items()},
        })

    data = payload(request)
    first, last = data.get('firstName'), data.get('lastName')
    if not valid_name(first) or not valid_name(last):
        return error('Enter valid first and last names.')
    address = {}
    for key, (field, limit) in ADDRESS_FIELDS.items():
        value = data.get(key)
        if value is not None and not isinstance(value, str):
            return error('Enter a valid address.')
        value = (value or '').strip()
        if key == 'zip' and value and not re.fullmatch(r'[0-9]{5}', value):
            return error('ZIP code must be exactly five digits.')
        if len(value) > limit:
            return error('Check the lengths of the address fields.')
        address[field] = value or None
    if any(address.values()) and not all(address.values()):
        return error('Address line, city, state, and ZIP code cannot be null when an address is provided.')
    Customers.objects.filter(pk=customer.pk).update(
        first_name=first, last_name=last, updated_at=timezone.now(), **address
    )
    return JsonResponse({'message': 'Profile updated.'})
