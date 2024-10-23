# Create your models here.
from django.db import models

from django.db import models
from uuid import UUID

class ProjectDetails(models.Model):
    def __init__(self):
        self.dns = None
        self.ip_address = None
        self.project_name = None
        self.project_description = None
        self.tech_stack = None
        self.versions = None
        self.get_url = None
        self.status = None
        self.button = None
        self.id = None
        
        class Meta:
            managed = False
            db_table = 'Project_List'


# Here ProjectDetails is the model for our projects store server details 
# class ProjectDetail(models.Model):
#     Id = models.IntegerField(primary_key=True)
#     dns = models.CharField(max_length=30)
#     ip_address = models.CharField(max_length=30)
#     project_name = models.CharField(max_length=30)
#     project_description = models.CharField(max_length=300)
#     tech_stack = models.CharField(max_length=30)
#     versions = models.CharField(max_length=30)
#     get_url = models.CharField(max_length=30)
#     status = models.CharField(max_length=30)
#     button = models.CharField(max_length=30)

#     class Meta:
#         managed = False
#         db_table = 'ProjectListing'
#         # Above code will create the ProjectListing table in database

class UserDetails(models.Model):
    def __init__(self):
        self.username = None
        self.email = None
        self.password = None
        self.is_active = None
        self.role = None
        self.phone_num = None
        self.old_password = None
        self.forgot_password_code = None
        self.created_at = None
        self.updated_at = None
        self.login_otp = None




    class Meta:
            managed = False
            db_table = 'Userdetails'



# Here UserDetails is the model  for to store user details 
# class UserDetail(models.Model):
#     # id  = models.AutoField(primary_key = True)
#     username = models.CharField(max_length=30)
#     email = models.EmailField(max_length=50, unique=True)
#     password = models.CharField(max_length=30)

#     # def __str__(self):
#     #     return self.username,self.password

#     class Meta:
#         managed = False
#         db_table = 'Register_Users'
#         # Above code will create the Register_Users table in database







