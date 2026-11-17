
from rest_framework import viewsets
from django.db.models import Q

from .models import Item, Category
from .serializers import ItemSerializer, CategorySerializer


class ItemViewSet(viewsets.ModelViewSet):
    queryset = Item.objects.all().order_by('-created_at')
    serializer_class = ItemSerializer

    def get_queryset(self):
        items = Item.objects.all()

        # Зарны нэр болон тайлбараар хайх
        search = self.request.query_params.get('search')
        if search:
            items = items.filter(
                Q(title__icontains=search) |
                Q(description__icontains=search)
            )

        # Ангиллаар шүүх
        category = self.request.query_params.get('category')
        if category:
            items = items.filter(category_id=category)

        # Байршлаар шүүх
        location = self.request.query_params.get('location')
        if location:
            items = items.filter(location__icontains=location)


        # Үнийн доод хязгаар
        min_price = self.request.query_params.get('min_price')
        if min_price:
            items = items.filter(price__gte=min_price)

        # Үнийн дээд хязгаар
        max_price = self.request.query_params.get('max_price')
        if max_price:
            items = items.filter(price__lte=max_price)

        # Үнээр эрэмбэлэх
        ordering = self.request.query_params.get('ordering')

        if ordering == 'price_asc':
            items = items.order_by('price')
        elif ordering == 'price_desc':
            items = items.order_by('-price')
        else:
            items = items.order_by('-created_at')

        return items


class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
