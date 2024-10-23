from django.contrib import admin

# Register your models here.
#auth api
from .models import ProjectDetails, UserDetails
admin.site.register(ProjectDetails)
admin.site.register(UserDetails)