from rest_framework import serializers
from dsl.models import ProjectDetails,UserDetails

class DemosSerializers(serializers.Serializer):
    
    dns = serializers.CharField(required=True,max_length=30)
    ip_address = serializers.CharField(required=True,max_length=30)
    project_name = serializers.CharField(required=True,max_length=30)
    project_description = serializers.CharField(required=True,max_length=30)
    tech_stack = serializers.CharField(required=True,max_length=30)
    versions = serializers.CharField(required=True,max_length=30)
    get_url = serializers.CharField(required=True,max_length=30)
    status = serializers.CharField(required=True,max_length=30)
    button = serializers.CharField(required=True,max_length=30)
    id = serializers.IntegerField(required=True)
    

class UserSerializers(serializers.Serializer):

    username = serializers.CharField(required=True,max_length=30)
    email = serializers.CharField(required=True,max_length=50)
    password = serializers.CharField(required=True,max_length=30)
    is_active = serializers.BooleanField(required=True)
    role = serializers.CharField(required=True)
    phone_num = serializers.IntegerField(required=True)
    old_password = serializers.CharField(required=True,max_length=30)
    forgot_password_code = serializers.CharField(required=True)
    created_at = serializers.DateTimeField(required=True)
    updated_at = serializers.DateTimeField(required=True)
    login_otp = serializers.IntegerField(required=True)



 

