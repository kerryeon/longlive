from rest_framework import permissions, serializers, viewsets

from .. import models


class PostImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.PostImage
        fields = ('image',)


class PostSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(
        default=serializers.CurrentUserDefault()
    )

    images = PostImageSerializer(many=True, read_only=True)
    likes = serializers.IntegerField(source='likes.count', read_only=True)

    class Meta:
        model = models.Post
        fields = '__all__'


class PostViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer


class UserPostViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer

    def get_queryset(self):
        user = self.request.user
        return models.Post.objects.filter(user=user)


class PostLikedSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(
        default=serializers.CurrentUserDefault()
    )

    class Meta:
        model = models.PostLiked
        fields = ('user', 'post')


class UserPostLikedViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer

    def get_queryset(self):
        user = self.request.user
        return models.Post.objects.filter(likes__user=user)


class UserPostLikedMutViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.PostLiked.objects.all()
    serializer_class = PostLikedSerializer

    def get_queryset(self):
        user = self.request.user
        return models.PostLiked.objects.filter(user=user)
