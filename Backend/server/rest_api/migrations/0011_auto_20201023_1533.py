# Generated by Django 3.1.2 on 2020-10-23 15:33

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('rest_api', '0010_user_term'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='usersession',
            unique_together={('ty', 'remote_id')},
        ),
    ]
