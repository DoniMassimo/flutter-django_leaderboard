from django.contrib import admin
from django.urls import path, include
from . import views
#prova
# cazzo
urlpatterns = [
    path('name', view=views.hello_world),
    path('login', view=views.login),
    path('register', view=views.register),
    path('create_group', view=views.create_group),
    path('send_join_req', view=views.send_join_request),
    path('accept_join_req', view=views.accept_join_request),
    path('view_join_req', view=views.view_join_request),
    path('group_data', view=views.get_group_data),
    path('update_point', view=views.update_point),
]