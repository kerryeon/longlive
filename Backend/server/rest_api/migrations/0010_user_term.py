# Generated by Django 3.1.2 on 2020-10-23 14:06

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('rest_api', '0009_term'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='term',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='rest_api.term'),
            preserve_default=False,
        ),
    ]
