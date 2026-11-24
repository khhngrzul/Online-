
from rest_framework.routers import DefaultRouter
from .views import ItemViewSet, CategoryViewSet

router = DefaultRouter()

router.register('items', ItemViewSet)
router.register('categories', CategoryViewSet)

urlpatterns = router.urls
