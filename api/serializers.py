from rest_framework import serializers
from dsl import models

class ProjectDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'dns',
            'project_name',
            'project_description',
            'ip_address',
            'tech_stack',
            'versions',
            'get_url', 
            'status',
            'button',
            'id',
        )
        model = models.ProjectDetails
class UserDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        fields = (
            'username',
            'email',
            'password',
            'is_active',
            'role',
            'phone_num',
            'old_password',
            'forgot_password_code',
            'created_at',
            'updated_at',
            'login_otp',

        )
        model = models.UserDetails