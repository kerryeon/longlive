from rest_framework import serializers, viewsets

from .. import models


class HabitTypeSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.HabitType
        fields = '__all__'


class HabitTypeViewSet(viewsets.ModelViewSet):
    queryset = models.HabitType.objects.all()
    serializer_class = HabitTypeSerializer


class HabitSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Habit
        fields = '__all__'


class HabitViewSet(viewsets.ModelViewSet):
    queryset = models.Habit.objects.all()
    serializer_class = HabitSerializer


class UserHabitSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.UserHabit
        fields = '__all__'


class UserHabitViewSet(viewsets.ModelViewSet):
    queryset = models.UserHabit.objects.all()
    serializer_class = UserHabitSerializer