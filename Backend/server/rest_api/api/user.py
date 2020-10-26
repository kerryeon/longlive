from rest_framework import generics, permissions, serializers, viewsets

from .. import models
from .csrf import CsrfExemptSessionAuthentication


class UserGenderTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.UserGenderType
        fields = '__all__'


class UserGenderTypeViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.AllowAny,)

    queryset = models.UserGenderType.objects.all()
    serializer_class = UserGenderTypeSerializer


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.User
        fields = ('id', 'age', 'gender', 'term', 'habits',)
        read_only_fields = ('id',)
        extra_kwargs = {}

    def create(self, validated_data):
        return models.User.objects.create_user(
            validated_data.pop('age'),
            validated_data.pop('gender').id,
            validated_data.pop('term').id,
        )


class UserView(generics.RetrieveAPIView):
    permission_classes = (permissions.IsAuthenticated,)

    serializer_class = UserSerializer
    lookup_field = 'pk'

    def get_object(self, *args, **kwargs):
        return self.request.user

    @classmethod
    def get_extra_actions(cls):
        return []


class UserMutView(generics.UpdateAPIView):
    permission_classes = (permissions.IsAuthenticated,)
    authentication_classes = (CsrfExemptSessionAuthentication,)

    serializer_class = UserSerializer
    lookup_field = 'pk'

    def get_object(self, *args, **kwargs):
        return self.request.user

    @classmethod
    def get_extra_actions(cls):
        return []
