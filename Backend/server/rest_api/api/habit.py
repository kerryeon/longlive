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
