from rest_framework import permissions, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Post, Suggestion
from .serializers import CommentSerializer, PostSerializer, SuggestionSerializer


class IsAuthorOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.author_id == request.user.id


class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.select_related("author").prefetch_related(
        "likes", "comments__author")
    serializer_class = PostSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsAuthorOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

    @action(detail=True, methods=["post"],
            permission_classes=[permissions.IsAuthenticated])
    def like(self, request, pk=None):
        post = self.get_object()
        if post.likes.filter(pk=request.user.pk).exists():
            post.likes.remove(request.user)
        else:
            post.likes.add(request.user)
        return Response(self.get_serializer(post).data)

    @action(detail=True, methods=["post"],
            permission_classes=[permissions.IsAuthenticated])
    def comment(self, request, pk=None):
        post = self.get_object()
        ser = CommentSerializer(data=request.data, context={"request": request})
        ser.is_valid(raise_exception=True)
        ser.save(post=post, author=request.user)
        return Response(self.get_serializer(post).data, status=201)


class SuggestionViewSet(viewsets.ModelViewSet):
    queryset = Suggestion.objects.select_related("author").prefetch_related("voters")
    serializer_class = SuggestionSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly, IsAuthorOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(author=self.request.user)

    @action(detail=True, methods=["post"],
            permission_classes=[permissions.IsAuthenticated])
    def vote(self, request, pk=None):
        s = self.get_object()
        if s.voters.filter(pk=request.user.pk).exists():
            s.voters.remove(request.user)
        else:
            s.voters.add(request.user)
        return Response(self.get_serializer(s).data)