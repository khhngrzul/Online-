from django.contrib import admin
from django.urls import include, path
from rest_framework.routers import DefaultRouter
from listings.views import CategoryViewSet, api_root

router = DefaultRouter()
router.register('categories', CategoryViewSet)

urlpatterns = [
    path('', api_root, name='api-root'),  
    path('admin/', admin.site.urls),
    
    path('api/auth/', include('listings.urls')),
    path('api/', include(router.urls)),
]
