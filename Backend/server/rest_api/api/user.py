from rest_framework import generics, permissions, serializers

from .. import models


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.User
        fields = ('id', 'age', 'gender')
        read_only_fields = ('id',)
        extra_kwargs = {}

    def create(self, validated_data):
        return models.User.objects.create_user(
            validated_data.pop('age'),
            validated_data.pop('gender').id,
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
