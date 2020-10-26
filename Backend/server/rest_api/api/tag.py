from taggit.forms import TagField

from django_filters import rest_framework as filters
from rest_framework import serializers


class TagSerializerField(serializers.ListField):
    child = serializers.CharField()

    def to_representation(self, data):
        return data.values_list('name', flat=True)


class TagFilter(filters.CharFilter):
    field_class = TagField

    def __init__(self, *args, **kwargs):
        kwargs.setdefault('lookup_expr', 'in')
        super().__init__(*args, **kwargs)

    def filter(self, qs, value):
        for tag in value:
            qs = super().filter(qs, [tag])
        return qs
