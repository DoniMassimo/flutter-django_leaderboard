# Generated by Django 4.1.6 on 2023-05-13 10:05

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api_flutter', '0008_remove_user_group_joined_group_user_joined'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='User',
            new_name='Person',
        ),
    ]
