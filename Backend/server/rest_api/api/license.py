from rest_framework import permissions, serializers, viewsets

from .. import models


class LicenseSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.License
        fields = '__all__'


class LicenseViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.AllowAny,)

    queryset = models.License.objects.all()
    serializer_class = LicenseSerializer
