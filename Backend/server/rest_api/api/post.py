from django.db.models import Count

from django_filters import rest_framework as filters
from rest_framework import mixins, permissions, serializers, status, viewsets
from rest_framework.response import Response

from .. import models
from .csrf import CsrfExemptSessionAuthentication
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
    liked = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = models.Post
        fields = '__all__'

    def get_liked(self, post):
        user = self.context['request'].user
        return bool(user.likes.filter(post=post))


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
            'user': ['exact'],
            'date_create': ['gt', 'lt'],
        }


class PostViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer
    filterset_class = PostFilter
    pagination_class = StandardResultsSetPagination


class PostMutSerializer(PostSerializer):
    user = serializers.HiddenField(
        default=serializers.CurrentUserDefault()
    )

    def create(self, validated_data):
        tags = validated_data.pop('tags')[0].split(',')
        images_data = self.context['request'].FILES

        post = models.Post.objects.create(**validated_data)
        post.tags.set(*tags)
        for image_data in images_data.values():
            models.PostImage.objects.create(post=post, image=image_data)
        return post


class PostMutViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)
    authentication_classes = (CsrfExemptSessionAuthentication,)

    queryset = models.Post.objects.all()
    serializer_class = PostMutSerializer

    def get_queryset(self):
        user = self.request.user
        return models.Post.objects.filter(user=user)


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

    enabled = serializers.BooleanField(required=False)

    class Meta:
        model = models.PostLiked
        fields = ('user', 'post', 'enabled')


class UserPostLikedViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Post.objects.all()
    serializer_class = PostSerializer
    filterset_class = PostFilter
    pagination_class = StandardResultsSetPagination

    def get_queryset(self):
        user = self.request.user
        return models.Post.objects.filter(likes__user=user)


class UserPostLikedMutViewSet(viewsets.GenericViewSet, mixins.CreateModelMixin):
    permission_classes = (permissions.IsAuthenticated,)
    authentication_classes = (CsrfExemptSessionAuthentication,)

    queryset = models.PostLiked.objects.all()
    serializer_class = PostLikedSerializer

    def get_queryset(self):
        user = self.request.user
        return models.PostLiked.objects.filter(user=user)

    def create(self, request, *args, **kwargs):
        if 'enabled' in request.data.keys():
            if request.data['enabled'] == True:
                del request.data['enabled']
                try:
                    return super().create(request, *args, **kwargs)
                finally:
                    return Response({}, status=status.HTTP_201_CREATED)
            if request.data['enabled'] == False:
                return self.delete(request, *args, **kwargs)
        return Response({}, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, *args, **kwargs):
        if 'post' not in request.data.keys():
            return Response({}, status=status.HTTP_400_BAD_REQUEST)
        user = request.user
        post = request.data['post']

        try:
            instance = models.PostLiked.objects.get(user=user, post=post)
            instance.delete()
        finally:
            return Response({}, status=status.HTTP_204_NO_CONTENT)


class PostReportSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(
        default=serializers.CurrentUserDefault()
    )

    class Meta:
        model = models.PostReport
        fields = ('user', 'post', 'desc')


class UserPostReportViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)
    authentication_classes = (CsrfExemptSessionAuthentication,)

    queryset = models.PostReport.objects.all()
    serializer_class = PostReportSerializer

    def get_queryset(self):
        user = self.request.user
        return models.PostReport.objects.filter(user=user)
