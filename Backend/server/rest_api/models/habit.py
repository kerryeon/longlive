from django.db import models

from colorfield.fields import ColorField


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
