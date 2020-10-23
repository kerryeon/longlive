from django.urls import path

from . import api, views


urlpatterns = [
    *api.urlpatterns,
    path('', views.home),
]
