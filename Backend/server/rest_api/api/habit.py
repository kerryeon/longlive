from rest_framework import permissions, serializers, viewsets

from .. import models


class HabitTypeSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.HabitType
        fields = '__all__'


class HabitTypeViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.AllowAny,)

    queryset = models.HabitType.objects.all()
    serializer_class = HabitTypeSerializer


class HabitSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Habit
        fields = '__all__'


class HabitViewSet(viewsets.ReadOnlyModelViewSet):
    permission_classes = (permissions.AllowAny,)

    queryset = models.Habit.objects.all()
    serializer_class = HabitSerializer


class UserHabitSerializer(serializers.ModelSerializer):
    user = serializers.HiddenField(
        default=serializers.CurrentUserDefault()
    )

    class Meta:
        model = models.UserHabit
        fields = ('user', 'ty',)


class UserHabitViewSet(viewsets.ModelViewSet):
    permission_classes = (permissions.IsAuthenticated,)

    queryset = models.UserHabit.objects.all()
    serializer_class = UserHabitSerializer

    def get_queryset(self):
        user = self.request.user
        return models.UserHabit.objects.filter(user=user)
