from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Person, Group, Point, JoinRequest
from .serializers import PersonSerializer, GroupSerializer, PointSerializer, JoinRequestSerializer

import bcrypt
import datetime

# Create your views here.

@api_view(['GET'])
def hello_world(request):
    if request.method == 'GET':
        instances = Person.objects.all()
        serializer = PersonSerializer(instances, many=True)
        return Response(serializer.data)
    return Response({"message": "Hello, world!"})

@api_view(['POST'])
def login(request): 
    name = request.data['name']
    clear_pwd = request.data['pass']
    if Person.objects.filter(name=name, password=clear_pwd).exists(): 
        person = Person.objects.get(name, password=clear_pwd)
        person.last_action = datetime.datetime.now()
        person.save()               
        return Response({'correct':'user logged correctly'})
    else:
        return Response({'error':'credential does not match'})

@api_view(['POST'])
def register(request):
    name = request.data['name']
    pwd = request.data['pass']
    if not Person.objects.filter(name=name).exists():
        new_user = Person(name=name, password=pwd)
        new_user.save()
        return Response({'correct':'user registered correctly'})
    else:
        return Response({'error':'user already exist'})


@api_view(['POST'])
def create_group(request): # passed argument: name:name, pass:password, group_name:group_name
    group_name = request.data['group_name']
    name = request.data['name']
    pwd = request.data['pass']
    time_check = check_inactivity_time(name)
    if time_check == True:
        if Person.objects.filter(name=name, password=pwd).exists():
            if not Group.objects.filter(group_name=group_name).exists():
                group_admin = Person.objects.get(name=name)
                group = Group(group_name=group_name, group_admin=group_admin)
                group.save()
                return Response({'correct':'group create correctly'})
            else:
                return Response({'error':'group name arleady taken'})
        else:
            return Response({'error':'credential error'})
    else:
        return time_check


@api_view(['POST'])
def get_group_data(request): # passed argument: name:name, pass:password, group_name:group_name
    group_name = request.data['group_name']
    name = request.data['name']
    pwd = request.data['pass']
    check = check_user_and_group_credential(name, pwd, group_name) 
    time_check = check_inactivity_time(name)
    if time_check == True:
        if check == True:
            group = Group.objects.get(group_name=group_name)                
            group_data = group.user_joined.all()
            for i in group_data:
                print('\n\n', i.name)
            print('\n\n', len(group_data))
            ser = PersonSerializer(group_data, many=True)
            point = Point.objects.filter(group=group)
            point_ser = PointSerializer(point, many=True)
            print(point_ser.data)
            print(ser.data)
            return Response({'user':ser.data, 'point':point_ser.data})
        else:
            return check
    else:
        return time_check
        
@api_view(['POST'])
def update_point(request): # group_name, name, pass, updated data {'name':'new point'}
    group_name = request.data['group_name']
    name = request.data['name']
    pwd = request.data['pass']
    updated_data = request.data['data']
    check = check_user_and_group_credential(name, pwd, group_name) 
    time_check = check_inactivity_time(name)
    if time_check == True:
        if check == True:
            admin = Person.objects.get(name=name)
            group = Group.objects.get(group_name=group_name)
            if group.group_admin.pk == admin.pk:
                for key, value in updated_data.items():
                    check = check_user_and_group_credential(name=key, group_name=group_name)
                    if check == True:
                        person = Person.objects.get(name=key)                    
                        point = Point.objects.get(group=group, person=person)
                        point.point = int(value)
                        point.save()
                    else:
                        return check
                return Response({'correct':'data change correctly'})
            else:
                return Response({'error':'you must be admin to change point'})
        else:
            return check
    else:
        return time_check

@api_view(['POST'])
def send_join_request(request): # passed argument: name: name, pass:password, group_name:group_name
    group_name = request.data['group_name']
    name = request.data['name']
    pwd = request.data['pass']    
    check = check_user_and_group_credential(name, pwd, group_name) 
    time_check = check_inactivity_time(name)
    if time_check == True:
        if check == True:
            person = Person.objects.get(name=name)
            group = Group.objects.get(group_name=group_name)
            if not JoinRequest.objects.filter(person=person, group=group).exists():
                join_request = JoinRequest(person=person, group=group)
                join_request.save()
                return Response({'correct':'you have send correctly teh join request'})
            else:
                return Response({'error':'you have arleady send join request'})
        else:
            return check
    else:
        return time_check

@api_view(['POST'])
def accept_join_request(request): # passed argument: name, pass:password, group_name:group_name, person
    group_name = request.data['group_name']
    admin_name = request.data['name']
    pwd = request.data['pass']
    person_name = request.data['person']    
    check_admin = check_user_and_group_credential(admin_name, pwd, group_name)
    check_person = check_user_and_group_credential(name=person_name, group_name=group_name) 
    if check_admin != True:
        return check_admin
    elif check_person != True:
        return check_person
    
    group = Group.objects.get(group_name=group_name)
    person = Person.objects.get(name=person_name)
    # time_check = check_inactivity_time(admin_name)
    # if time_check == True:
    #     if check_admin == True and check_person == True:
    #         group = Group.objects.get(group_name=group_name)
    #         person = Person.objects.get(name=person_name)            
    #         join_request_result = join_to_group(group_name, person_name, pwd)
    #         if join_request_result[1] == True:
    #             JoinRequest.objects.filter(person=person, group=group).delete()
    #             return({'correct':'person added to group'})
    #         else:
    #             return join_request_result[0]        
    #     else:
    #         if check_admin != True:
    #             return check_admin
    #         if check_person != True:
    #             return check_person

@api_view(['POST'])
def view_join_request(request): # adminName, pass, group
    group_name = request.data['group_name']
    name = request.data['name']
    pwd = request.data['pass'] 
    check = check_user_and_group_credential(name, pwd, group_name) 
    if check == True:
        group = Group.objects.get(group_name=group_name)            
        join_request = JoinRequest.objects.filter(group=group)
        print(join_request)
        join_ser = JoinRequestSerializer(join_request, many=True)
        return Response({'data':join_ser.data})
    else:
        return check

def join_to_group(group_name, name, pwd):
    group = Group.objects.get(group_name=group_name)
    user = Person.objects.get(name=name)
    # time_check = check_inactivity_time(name)
    # if time_check == True:
    #     if Person.objects.filter(name=name, password=pwd).exists():
    #         if Group.objects.filter(group_name=group_name).exists():
    #             group = Group.objects.get(group_name=group_name)
    #             user = Person.objects.get(name=name)
    #             if JoinRequest.objects.filter(person=user, group=group).exists():
    #                 if group.group_admin.pk == user.pk:
    #                     return Response({'error':'group admin cant join group'}), False
    #                 if user in group.user_joined.all():
    #                     return Response({'error':'you are arleady in this group'}), False    
    #                 group.user_joined.add(user)
    #                 point = Point(person=user, group=group)
    #                 point.save()
    #                 user.save()
    #                 group.save()
    #                 return Response({'correct':'group joined correctly'}), True
    #             else: 
    #                 return Response({'error':'you need a join request send from admin'})
    #         else:
    #             return Response({'error':'group does not exist'}), False
    #     else:
    #         return Response({'error':'credential error'}), False
    # else:
    #     return time_check




def check_user_and_group_credential(name=None, pwd=None, group_name=None):
    if pwd == None:
        if Person.objects.filter(name=name).exists():
            if Group.objects.filter(group_name=group_name).exists():
                return True            
            else:
                return Response({'error':'group does not exist'})
        else:
            return Response({'error':'name does not exist in this group'})
    else:
        if Person.objects.filter(name=name, password=pwd).exists():
            if Group.objects.filter(group_name=group_name).exists():
                return True            
            else:
                return Response({'error':'group does not exist'})
        else:
            return Response({'error':'credential error'})
        
def check_inactivity_time(name):
    return True
    if Person.objects.filter(name=name).exists():
        person = Person.objects.get(name=name)    
        last_action = person.last_action
        now_time = datetime.datetime.now

        if now_time - datetime.timedelta(minutes=10) > last_action:
            return Response({'warning':'need login'})
        else:
            person.last_action = datetime.datetime.now
            person.save()
            return True
    else:
        return Response({'warning':'need login'})