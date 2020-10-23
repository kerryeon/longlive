from rest_framework import permissions, serializers, viewsets

from .. import models


class VideoOwnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.VideoOwner
        fields = '__all__'


class VideoSerializer(serializers.ModelSerializer):
    owner = VideoOwnerSerializer()

    class Meta:
        model = models.Video
        fields = ('title', 'desc', 'owner', 'ty', 'video_id', 'ad',)


class VideoViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.Video.objects.all()
    serializer_class = VideoSerializer
