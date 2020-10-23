import requests

from django.conf import settings
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.backends import BaseBackend
from django.core.exceptions import SuspiciousOperation

from rest_framework import authentication, generics, permissions, response, serializers, views

from .. import models
from .user import UserSerializer


class AbstractLogin:
    @classmethod
    def login(cls, access_token):
        return None


class KakaoTalkLogin(AbstractLogin):
    @classmethod
    def login(cls, access_token):
        response = requests.get(
            'https://kapi.kakao.com/v1/user/access_token_info',
            headers={
                'Authorization': f'Bearer {access_token}'
            }
        )
        if response.status_code != 200:
            return None
        return response.json()['id']


LOGIN_METHODS = {
    models.UserLoginType.KAKAOTALK: KakaoTalkLogin,
}


def _remote_login(ty, token):
    if ty not in LOGIN_METHODS.keys():
        return None
    return LOGIN_METHODS[ty].login(token)


class LoginBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None, ty=None, token=None):
        if username is not None or password is not None:
            return self.sudo_authenticate(request, username, password)
        if ty is None or token is None:
            return None

        remote_id = _remote_login(ty, token)
        if remote_id is None:
            return None

        try:
            session = models.UserSession.objects.get(
                ty=ty, remote_id=remote_id)
            if session is None:
                return None
        except models.UserSession.DoesNotExist:
            return None

        return session.user

    def sudo_authenticate(self, request, username=None, password=None):
        if username is None:
            return None
        username = int(username)

        try:
            user = models.User.objects.get(id=username)
            if not user:
                return None

            if not user.check_password(password):
                return None
            if not user.is_superuser:
                return None
            return user
        except models.User.DoesNotExist:
            return None

    def get_user(self, username):
        try:
            return models.User.objects.get(pk=username)
        except models.User.DoesNotExist:
            return None


"""
{
    "ty": 1,
    "token": "YKHN5_CaxGQOoDYNSEJ4GvMM_S_swsjIikny4Qo9cpcAAAF1VgvcQg"
}
"""


class LoginSessionSerializer(serializers.ModelSerializer):
    token = serializers.CharField(max_length=255)

    class Meta:
        model = models.UserSession
        fields = ('ty', 'token')


class LoginSerializer(LoginSessionSerializer):
    def validate(self, attrs):
        user = authenticate(ty=attrs['ty'], token=attrs['token'])

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


class UserRegisterSerializer(serializers.Serializer):
    user = UserSerializer()
    session = LoginSessionSerializer()
    habits = serializers.ListField(child=serializers.IntegerField())


class RegisterView(generics.CreateAPIView):
    permission_classes = (permissions.AllowAny,)

    serializer_class = UserRegisterSerializer

    def post(self, request):
        logout(request)
        return super().post(request)

    # {"session":{"ty":1,"token":"YKHN5_CaxGQOoDYNSEJ4GvMM_S_swsjIikny4Qo9cpcAAAF1VgvcQg"},"user":{"age":26,"gender":2,"term":1},"habits":[2,11]}
    def perform_create(self, serializer):
        session = LoginSessionSerializer(data=serializer.data['session'])
        session.is_valid(raise_exception=True)

        ty = session.data['ty']
        token = session.data['token']
        remote_id = _remote_login(ty, token)

        if models.UserSession.objects.filter(ty=ty, remote_id=remote_id).count() > 0:
            raise SuspiciousOperation('Already registered.')

        user = UserSerializer(data=serializer.data['user'])
        user.is_valid(raise_exception=True)
        user.save()
        user.backend = settings.AUTHENTICATION_BACKENDS[0]

        user = models.User.objects.get(id=user.data['id'])
        session = models.UserSession(
            user=user,
            ty=ty,
            remote_id=remote_id,
        )
        session.save()

        for habit in serializer.data['habits']:
            try:
                habit = models.Habit.objects.get(id=habit)
                user_habit = models.UserHabit(user=user, ty=habit)
                user_habit.save()
            except models.Habit.DoesNotExist:
                pass

        login(self.request, user)

    @classmethod
    def get_extra_actions(cls):
        return []
