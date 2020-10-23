from rest_framework import permissions, serializers, viewsets

from .. import models


class TermSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Term
        fields = '__all__'


class TermViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.AllowAny,)

    queryset = models.Term.objects.all()
    serializer_class = TermSerializer

    def get_queryset(self):
        # 최근 약관만 사용합니다.
        return [models.Term.objects.latest('id')]
