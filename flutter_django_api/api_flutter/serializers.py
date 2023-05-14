from rest_framework import serializers
from .models import Person, Group, Point, JoinRequest



class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = ['group_name', 'group_admin', 'user_joined']


class PointSerializer(serializers.ModelSerializer):    
    class Meta:
        model = Point
        fields = ['point', 'person']

class PersonSerializer(serializers.ModelSerializer):        
    class Meta:
        model = Person
        fields = ['name', 'id']

class JoinRequestSerializer(serializers.ModelSerializer):
    person = PersonSerializer(many=True)
    class Meta:
        model = JoinRequest
        fields = ['person']