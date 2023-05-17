from django.contrib import admin
from .models import Person, Group, Point

admin.site.register(Person)
admin.site.register(Group)
admin.site.register(Point)