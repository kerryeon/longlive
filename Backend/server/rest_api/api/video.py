from django_filters import rest_framework as filters
from rest_framework import permissions, serializers, viewsets

from .. import models
from .tag import *


class VideoOwnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.VideoOwner
        fields = '__all__'


class VideoFilter(filters.FilterSet):
    tags = TagFilter(field_name='tags__name')

    class Meta:
        model = models.Video
        fields = {
            'title': ['contains'],
            'ty': ['exact'],
            'date_create': ['gt', 'lt'],
        }


class VideoSerializer(serializers.ModelSerializer):
    owner = VideoOwnerSerializer()

    tags = TagSerializerField()

    class Meta:
        model = models.Video
        fields = '__all__'


class VideoViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Video.objects.all()
    serializer_class = VideoSerializer
    filterset_class = VideoFilter
