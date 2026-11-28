
from django.db import models

from django.conf import settings

class Category(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class Item(models.Model):
    class Kind(models.TextChoices):
        SELL = 'sell', 'Зарна'
        SWAP = 'swap', 'Солилцоно'
        FREE = 'free', 'Үнэгүй'

    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    location = models.CharField(max_length=200, blank=True)
    phone = models.CharField(max_length=20, blank=True)
    kind = models.CharField(max_length=10, choices=Kind.choices, default=Kind.SELL)
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="items",
        null=True,      # хуучин зарууд owner-гүй байж болно
        blank=True,
    )
    owner_name = models.CharField(max_length=150, blank=True, default='Оюутан')
    image = models.ImageField(upload_to='items/', blank=True, null=True)
    image_url = models.URLField(blank=True)
    category = models.ForeignKey(
        Category,
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
