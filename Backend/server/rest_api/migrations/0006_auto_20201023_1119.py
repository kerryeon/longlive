# Generated by Django 3.1.2 on 2020-10-23 11:19

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('rest_api', '0005_auto_20201023_1110'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='postliked',
            unique_together={('user', 'post')},
        ),
    ]
