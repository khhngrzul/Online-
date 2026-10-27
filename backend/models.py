
from django.db import models


class Post(models.Model):
    POST_TYPES = [
        ('Мэдээлэл', 'Мэдээлэл'),
        ('Зар', 'Зар'),
    ]

    title = models.CharField(max_length=120)
    post_type = models.CharField(max_length=20, choices=POST_TYPES)
    category = models.CharField(max_length=100)
    audience = models.CharField(max_length=50, default='Бүх оюутанд')
    content = models.TextField()
    image = models.ImageField(upload_to='posts/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
