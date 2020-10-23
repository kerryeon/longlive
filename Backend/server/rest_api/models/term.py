from django.db import models


class Term(models.Model):
    """약관"""
    desc = models.TextField()

    date_create = models.DateTimeField(auto_now_add=True)
    date_modify = models.DateTimeField(auto_now=True)

    def __str__(self) -> str:
        return str(self.id)
