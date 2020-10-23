from rest_framework import serializers, viewsets

from .. import models


class PostSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Post
        fields = '__all__'


class PostViewSet(viewsets.ModelViewSet):
    queryset = models.Post.objects.all()
    serializer_class = PostSerializer
