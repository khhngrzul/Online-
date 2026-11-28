from rest_framework.routers import SimpleRouter

from .views import PostViewSet, SuggestionViewSet

router = SimpleRouter()
router.register("posts", PostViewSet, basename="post")
router.register("suggestions", SuggestionViewSet, basename="suggestion")

urlpatterns = router.urls