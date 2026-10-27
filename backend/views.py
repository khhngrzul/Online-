
from rest_framework.decorators import api_view, parser_classes
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework.response import Response
from rest_framework import status
from .models import Post


@api_view(['GET', 'POST'])
@parser_classes([MultiPartParser, FormParser, JSONParser])
def posts_api(request):
    if request.method == 'GET':
        posts = Post.objects.all().order_by('-created_at')
        data = [
            {
                'id': post.id,
                'title': post.title,
                'post_type': post.post_type,
                'category': post.category,
                'audience': post.audience,
                'content': post.content,
                'image': request.build_absolute_uri(post.image.url)
                if post.image else None,
                'created_at': post.created_at,
            }
            for post in posts
        ]
        return Response(data)

    title = request.data.get('title', '').strip()
    category = request.data.get('category', '').strip()
    content = request.data.get('content', '').strip()

    if not title or not category or not content:
        return Response(
            {'error': 'Гарчиг, ангилал, агуулга заавал бөглөнө үү.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    post = Post.objects.create(
        title=title,
        post_type=request.data.get('post_type', 'Зар'),
        category=category,
        audience=request.data.get('audience', 'Бүх оюутанд'),
        content=content,
        image=request.FILES.get('image'),
    )

    return Response(
        {'message': 'Зар амжилттай бүртгэгдлээ', 'id': post.id},
        status=status.HTTP_201_CREATED
    )
