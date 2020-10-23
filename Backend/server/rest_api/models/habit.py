from django.db import models

from colorfield.fields import ColorField

from .user import User


class HabitType(models.Model):
    """습관 종류"""
    name = models.CharField(max_length=63)
    color = ColorField()

    def __str__(self) -> str:
        return self.name


class Habit(models.Model):
    """습관"""
    name = models.CharField(max_length=255)
    ty = models.ForeignKey(HabitType, on_delete=models.CASCADE)

    def __str__(self) -> str:
        return f'[{self.ty}] {self.name}'


class UserHabit(models.Model):
    """사용자 습관"""
    user = models.ForeignKey(User, on_delete=models.CASCADE,
                             related_name='habits')
    ty = models.ForeignKey(Habit, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('user', 'ty',)

    def __str__(self) -> str:
        return f'[{self.user.id}] {self.ty}'
