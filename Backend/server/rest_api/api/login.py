from rest_api.models import user
from django.conf import settings
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.backends import BaseBackend

from rest_framework import authentication, generics, permissions, response, serializers, views

from .. import models
from .user import UserSerializer


class LoginBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None):
        # TODO: to be implemented
        if username is None:
            return None
        username = int(username)

        if username == 1:
            try:
                return models.User.objects.get(id=username)
            except models.User.DoesNotExist:
                return None
        return None

    def get_user(self, username):
        try:
            return models.User.objects.get(pk=username)
        except models.User.DoesNotExist:
            return None


class LoginSerializer(serializers.Serializer):
    # TODO: to be implemented
    id = serializers.IntegerField()

    def validate(self, attrs):
        user = authenticate(
            username=attrs['id'],
        )  # { "id": 1 }

        if not user:
            raise serializers.ValidationError('Incorrect user information.')
        if not user.is_active:
            raise serializers.ValidationError('User is disabled.')

        return {'user': user}


class CsrfExemptSessionAuthentication(authentication.SessionAuthentication):
    def enforce_csrf(self, request):
        return


class LoginView(views.APIView):
    permission_classes = (permissions.AllowAny,)

    authentication_classes = (CsrfExemptSessionAuthentication,)

    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        login(request, user)
        return response.Response(UserSerializer(user).data)

    @classmethod
    def get_extra_actions(cls):
        return []


class LogoutView(views.APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        logout(request)
        return response.Response()

    @classmethod
    def get_extra_actions(cls):
        return []


class RegisterView(generics.CreateAPIView):
    permission_classes = (permissions.AllowAny,)

    serializer_class = UserSerializer

    def perform_create(self, serializer):
        user = serializer.save()
        user.backend = settings.AUTHENTICATION_BACKENDS[0]
        login(self.request, user)

    @classmethod
    def get_extra_actions(cls):
        return []
