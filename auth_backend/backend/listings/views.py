from rest_framework import generics
from rest_framework.decorators import api_view
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.viewsets import ModelViewSet
from rest_framework_simplejwt.views import TokenObtainPairView

from .models import Category
from .serializers import CategorySerializer, LoginSerializer, RegisterSerializer, UserSerializer


@api_view(['GET'])
def api_root(request):
    """Серверийн үндсэн хуудас болон боломжит endpoint-уудыг харуулах"""
    return Response({
        "мэдээлэл": "Системийн API хэвийн ажиллаж байна.",
        "холбоосууд": {
            "бүртгүүлэх": "/api/auth/register/",
            "нэвтрэх": "/api/auth/login/",
            "токен_шинэчлэх": "/api/auth/token/refresh/",
            "миний_мэдээлэл": "/api/auth/me/",
            "ангиллууд": "/api/categories/",
            "удирдлага": "/admin/"
        }
    })


class CategoryViewSet(ModelViewSet):
    """Ангиллыг харах, үүсгэх, засах, устгах."""
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


class RegisterView(generics.CreateAPIView):
    """Шинэ хэрэглэгч бүртгэх."""
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]


class LoginView(TokenObtainPairView):
    """Нэвтэрч баталгаажуулах токен авах."""
    permission_classes = [AllowAny]
    serializer_class = LoginSerializer


class MeView(APIView):
    """Нэвтэрсэн хэрэглэгчийн мэдээллийг харуулах API"""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserSerializer(request.user)
        return Response(serializer.data)
