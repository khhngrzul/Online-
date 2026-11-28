from rest_framework.routers import SimpleRouter
from .views import ItemViewSet, CategoryViewSet

router = SimpleRouter()
router.register('items', ItemViewSet, basename='item')
router.register('item-categories', CategoryViewSet, basename='item-category')

urlpatterns = router.urls