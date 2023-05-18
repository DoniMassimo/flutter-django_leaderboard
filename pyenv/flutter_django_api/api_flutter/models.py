from django.db import models
import datetime
# Create your models here.

class Person(models.Model):    
    name = models.CharField(max_length=200, unique=True)    
    password = models.CharField(max_length=60)
    #last_action = models.DateTimeField(datetime.datetime.now)

    def __str__(self) -> str:
        return str(self.name)

class Point(models.Model):
    point = models.IntegerField(default=0)
    person = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='point')
    group = models.ForeignKey('Group', on_delete=models.CASCADE, related_name='point')
    
    class Meta:
        unique_together = ('person', 'group')


    def __str__(self) -> str:
        return str(self.point)

class Group(models.Model):
    group_name = models.CharField(max_length=200, unique=True)
    group_admin = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='my_groups') 
    user_joined = models.ManyToManyField(Person, blank=True, related_name='joined_groups')
    
    def __str__(self) -> str:
        return str(self.group_name)

class JoinRequest(models.Model):
    person = models.ForeignKey(Person, on_delete=models.CASCADE, related_name='join_request')
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='join_request')
    

    class Meta:
        unique_together = ('person', 'group')

    def __str__(self) -> str:
        return str(str(self.person) + '-' + str(self.group))

