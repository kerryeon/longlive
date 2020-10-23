from django.db import models

from .habit import Habit


class VideoOwner(models.Model):
    """추천영상 크리에이터"""
    id = models.CharField(max_length=255, primary_key=True)
    name = models.CharField(max_length=255)


class Video(models.Model):
    """추천영상"""
    title = models.CharField(max_length=255)
    desc = models.TextField()
    owner = models.ForeignKey(VideoOwner, on_delete=models.CASCADE)
    ty = models.ForeignKey(Habit, on_delete=models.CASCADE)

    video_id = models.CharField(max_length=63)
    ad = models.BooleanField(default=False)

    date_create = models.DateTimeField(auto_now_add=True)
    date_modify = models.DateTimeField(auto_now=True)
