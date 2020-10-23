from rest_framework import permissions, serializers, viewsets

from .. import models


class PostImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.PostImage
        fields = ('image',)


class PostSerializer(serializers.ModelSerializer):
    images = PostImageSerializer(many=True, read_only=True)
    likes = serializers.IntegerField(source='likes.count', read_only=True)

    class Meta:
        model = models.Post
        fields = ('title', 'desc', 'user', 'ty', 'images', 'likes')


class PostViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer
