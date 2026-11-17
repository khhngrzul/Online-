
from rest_framework import serializers
from .models import Item, Category


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'
        extra_kwargs = {
            'name': {'label': 'Ангиллын нэр'}
        }


class ItemSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(
        source='category.name',
        read_only=True,
        label='Ангилал'
    )

    class Meta:
        model = Item
        fields = '__all__'
        extra_kwargs = {
            'title': {'label': 'Зарын гарчиг'},
            'description': {'label': 'Дэлгэрэнгүй тайлбар'},
            'price': {'label': 'Үнэ'},
            'location': {'label': 'Байршил'},
            'phone': {'label': 'Утасны дугаар'},
            'image': {'label': 'Зарын зураг'},
            'category': {'label': 'Ангилал'}
        }
