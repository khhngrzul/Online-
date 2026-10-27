from django.urls import path
from .views import posts_api

urlpatterns = [
    path('', posts_api, name='posts_api'),
]
