from django.contrib import admin
from .models import Person, Group, Point, JoinRequest

admin.site.register(Person)
admin.site.register(Group)
admin.site.register(Point)
admin.site.register(JoinRequest)