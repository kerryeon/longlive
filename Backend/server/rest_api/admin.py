from django.contrib import admin

from . import models

# Register your models here.
admin.site.register(models.HabitType)
admin.site.register(models.Habit)
admin.site.register(models.Post)
admin.site.register(models.PostImage)
admin.site.register(models.PostLiked)
admin.site.register(models.PostReport)
admin.site.register(models.Term)
admin.site.register(models.UserGenderType)
admin.site.register(models.User)
admin.site.register(models.UserSession)
admin.site.register(models.VideoOwner)
admin.site.register(models.Video)
