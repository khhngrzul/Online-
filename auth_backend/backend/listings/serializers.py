
from django.contrib.auth import get_user_model
from django.db.models import Q, Value
from django.db.models.functions import Concat, Lower
from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import Category, StudentProfile

User = get_user_model()


class LoginSerializer(TokenObtainPairSerializer):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields[self.username_field].label = "Нэр эсвэл имэйл хаяг"
        self.fields["password"].label = "Нууц үг"

    def validate(self, attrs):
        identifier = attrs[self.username_field].strip()
        password = attrs["password"]
        normalized_identifier = identifier.casefold()

        users = User.objects.filter(is_active=True).annotate(
            full_name=Lower(Concat("first_name", Value(" "), "last_name")),
            reverse_full_name=Lower(Concat("last_name", Value(" "), "first_name")),
        ).filter(
            Q(email__iexact=identifier)
            | Q(first_name__iexact=identifier)
            | Q(last_name__iexact=identifier)
            | Q(full_name=normalized_identifier)
            | Q(reverse_full_name=normalized_identifier)
        ).distinct()

        matches = [user for user in users if user.check_password(password)]
        if len(matches) != 1:
            raise AuthenticationFailed("Нэр, имэйл эсвэл нууц үг буруу байна.")

        user = matches[0]
        refresh = self.get_token(user)
        return {"refresh": str(refresh), "access": str(refresh.access_token)}


class RegisterSerializer(serializers.ModelSerializer):
    last_name = serializers.CharField(label="Овог", max_length=150)
    first_name = serializers.CharField(label="Нэр", max_length=150)
    student_code = serializers.CharField(
        label="Оюутны код", max_length=30, write_only=True
    )
    phone_number = serializers.CharField(
        label="Утасны дугаар", max_length=20, write_only=True
    )
    password = serializers.CharField(
        label="Нууц үг",
        write_only=True,
        min_length=8,
        style={"input_type": "password"},
    )

    email = serializers.EmailField(label="Имэйл хаяг")

    class Meta:
        model = User
        fields = [
            "id", "last_name", "first_name", "student_code", "phone_number",
            "email", "password",
        ]

    def validate_email(self, value):
        value = value.strip().lower()
        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError(
                "Энэ имэйл хаяг бүртгэлтэй байна."
            )
        return value

    def validate_student_code(self, value):
        value = value.strip()
        if StudentProfile.objects.filter(student_code__iexact=value).exists():
            raise serializers.ValidationError("Энэ оюутны код бүртгэлтэй байна.")
        return value

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data["student_code"] = instance.student_profile.student_code
        data["phone_number"] = instance.student_profile.phone_number
        return data

    def create(self, validated_data):
        password = validated_data.pop("password")
        student_code = validated_data.pop("student_code")
        phone_number = validated_data.pop("phone_number")
       
        validated_data["username"] = student_code
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        StudentProfile.objects.create(
            user=user, student_code=student_code, phone_number=phone_number
        )
        return user


class UserSerializer(serializers.ModelSerializer):
    last_name = serializers.CharField(label="Овог", read_only=True)
    first_name = serializers.CharField(label="Нэр", read_only=True)
    student_code = serializers.CharField(source="student_profile.student_code", label="Оюутны код", read_only=True)
    phone_number = serializers.CharField(source="student_profile.phone_number", label="Утасны дугаар", read_only=True)
    email = serializers.EmailField(label="Имэйл хаяг", read_only=True)

    class Meta:
        model = User
        fields = ["id", "last_name", "first_name", "student_code", "phone_number", "email", "date_joined"]
        read_only_fields = fields


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name", "slug", "parent", "is_active", "created_at"]
        read_only_fields = ["id", "created_at"]
