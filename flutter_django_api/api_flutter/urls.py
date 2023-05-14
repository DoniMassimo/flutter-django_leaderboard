from django.contrib import admin
from django.urls import path, include
from . import views

urlpatterns = [
    path('name', view=views.hello_world),
    path('login', view=views.login),
    path('register', view=views.register),
    path('create_group', view=views.create_group),
    path('join_group', view=views.join_to_group),
    path('group_data', view=views.get_group_data),
    path('update_point', view=views.update_point),
]