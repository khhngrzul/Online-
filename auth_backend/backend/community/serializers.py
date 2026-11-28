from rest_framework import serializers

from .models import Comment, Post, Suggestion


def full_name(u):
    return f"{u.last_name} {u.first_name}".strip() or u.username


class CommentSerializer(serializers.ModelSerializer):
    author_name = serializers.SerializerMethodField()
    author_code = serializers.CharField(source="author.username", read_only=True)

    class Meta:
        model = Comment
        fields = ["id", "text", "author_name", "author_code", "created_at"]
        read_only_fields = ["created_at"]

    def get_author_name(self, obj):
        return full_name(obj.author)


class PostSerializer(serializers.ModelSerializer):
    author_name = serializers.SerializerMethodField()
    author_code = serializers.CharField(source="author.username", read_only=True)
    like_count = serializers.IntegerField(source="likes.count", read_only=True)
    like_codes = serializers.SerializerMethodField()
    liked = serializers.SerializerMethodField()
    comments = CommentSerializer(many=True, read_only=True)

    class Meta:
        model = Post
        fields = ["id", "text", "image", "author_name", "author_code",
                  "like_count", "like_codes", "liked", "comments", "created_at"]
        read_only_fields = ["created_at"]

    def get_like_codes(self, obj):
        return [u.username for u in obj.likes.all()]

    def get_author_name(self, obj):
        return full_name(obj.author)

    def get_liked(self, obj):
        u = self.context["request"].user
        return bool(u.is_authenticated and obj.likes.filter(pk=u.pk).exists())


class SuggestionSerializer(serializers.ModelSerializer):
    author_name = serializers.SerializerMethodField()
    votes = serializers.IntegerField(source="voters.count", read_only=True)
    liked = serializers.SerializerMethodField()

    class Meta:
        model = Suggestion
        fields = ["id", "text", "author_name", "votes", "liked", "created_at"]
        read_only_fields = ["created_at"]

    def get_author_name(self, obj):
        return full_name(obj.author) if obj.author else "Оюутан"

    def get_liked(self, obj):
        u = self.context["request"].user
        return bool(u.is_authenticated and obj.voters.filter(pk=u.pk).exists())

    def get_like_codes(self, obj):
        return [u.username for u in obj.likes.all()]