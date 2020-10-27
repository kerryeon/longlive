from django.db import models


class License(models.Model):
    """오픈소스 라이센스"""
    name = models.CharField(max_length=63, primary_key=True)
    git = models.URLField(max_length=255)

    date_origin = models.DateTimeField(auto_now_add=True)
    date_modify = models.DateTimeField(auto_now=True)

    def __str__(self) -> str:
        return self.name
