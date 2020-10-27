from django.db.models import Count

from django_filters import rest_framework as filters
from rest_framework import permissions, serializers, viewsets

from .. import models
from .page import StandardResultsSetPagination
from .tag import *


class PostImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.PostImage
        fields = ('image',)


class PostSerializer(serializers.ModelSerializer):
    tags = TagSerializerField()

    images = PostImageSerializer(many=True, read_only=True)
    likes = serializers.IntegerField(source='likes.count', read_only=True)

    class Meta:
        model = models.Post
        fields = '__all__'

    def create(self, validated_data):
        tags = validated_data.pop('tags')
        images_data = self.context['request'].FILES

        post = models.Post.objects.create(**validated_data)
        post.tags.set(*tags)
        for image_data in images_data.getlist('image'):
            models.PostImage.objects.create(post=post, image=image_data)
        return post


class PostOrderingFilter(filters.OrderingFilter):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def filter(self, qs, value):
        qs = qs.annotate(count=Count('likes'))
        return super().filter(qs, value)


class PostFilter(filters.FilterSet):
    tags = TagFilter(field_name='tags__name')

    order = PostOrderingFilter(
        fields=(
            ('count', 'likes'),
            ('date_create', 'date'),
        ),
    )

    class Meta:
        model = models.Post
        fields = {
            'title': ['contains'],
            'ty': ['exact'],
            'date_create': ['gt', 'lt'],
        }


class PostViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer
    filterset_class = PostFilter
    pagination_class = StandardResultsSetPagination


class UserPostViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer
    filterset_class = PostFilter
    pagination_class = StandardResultsSetPagination

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
    filterset_class = PostFilter
    pagination_class = StandardResultsSetPagination

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
