
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
    owner_code = serializers.CharField(source="owner.username", read_only=True)

    class Meta:
        model = Item
        fields = "__all__"
        read_only_fields = ["owner", "owner_name", "created_at"]

    def get_owner_name(self, obj):
        if not obj.owner:
            return ""
        return f"{obj.owner.last_name} {obj.owner.first_name}".strip()

    # class Meta:
    #     model = Item
    #     fields = '__all__'
    #     extra_kwargs = {
    #         'title': {'label': 'Зарын гарчиг'},
    #         'description': {'label': 'Дэлгэрэнгүй тайлбар'},
    #         'price': {'label': 'Үнэ'},
    #         'location': {'label': 'Байршил'},
    #         'phone': {'label': 'Утасны дугаар'},
    #         'image': {'label': 'Зарын зураг'},
    #         'category': {'label': 'Ангилал'}
    #     }
