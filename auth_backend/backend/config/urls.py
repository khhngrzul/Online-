from django.contrib import admin
from django.urls import include, path
from rest_framework.routers import DefaultRouter
from listings.views import CategoryViewSet, api_root
from django.conf import settings
from django.conf.urls.static import static

router = DefaultRouter()
router.register('categories', CategoryViewSet)

urlpatterns = [
    path('', api_root, name='api-root'),  
    path('admin/', admin.site.urls),
    
    path('api/auth/', include('listings.urls')),
    path('api/', include('items.urls')),
    path('api/', include('community.urls')),
    path('api/', include(router.urls)),
]
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)