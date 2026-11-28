from django.db.models import Q
from rest_framework import permissions, viewsets

from .models import Category, Item
from .serializers import CategorySerializer, ItemSerializer


class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.owner_id == request.user.id


class ItemViewSet(viewsets.ModelViewSet):
    serializer_class = ItemSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly]

    def get_queryset(self):
        items = Item.objects.select_related('category', 'owner').all()
        params = self.request.query_params

        search = params.get('search')
        if search:
            items = items.filter(
                Q(title__icontains=search) | Q(description__icontains=search)
            )

        category = params.get('category')
        if category:
            items = items.filter(category_id=category)

        location = params.get('location')
        if location:
            items = items.filter(location__icontains=location)

        kind = params.get('kind')
        if kind:
            items = items.filter(kind=kind)

        min_price = params.get('min_price')
        if min_price:
            items = items.filter(price__gte=min_price)

        max_price = params.get('max_price')
        if max_price:
            items = items.filter(price__lte=max_price)

        ordering = params.get('ordering')
        if ordering == 'price_asc':
            items = items.order_by('price')
        elif ordering == 'price_desc':
            items = items.order_by('-price')
        else:
            items = items.order_by('-created_at')

        return items

    def perform_create(self, serializer):
        u = self.request.user
        name = f"{u.last_name} {u.first_name}".strip() or u.username
        serializer.save(owner=u, owner_name=name)


class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]