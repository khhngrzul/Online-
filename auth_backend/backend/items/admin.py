from django.contrib import admin

from .models import Category, Item


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    search_fields = ('name',)


@admin.register(Item)
class ItemAdmin(admin.ModelAdmin):
    list_display = ('title', 'kind', 'category', 'owner_name', 'price', 'created_at')
    list_filter = ('kind', 'category')
    search_fields = ('title', 'description', 'owner_name')
