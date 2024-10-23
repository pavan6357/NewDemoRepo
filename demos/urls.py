from django.contrib import admin
from django.urls import path
from dsl import views
from django.conf.urls import include
from rest_framework_jwt.views import obtain_jwt_token, refresh_jwt_token

urlpatterns = [
    #jwt paths
    path('auth/login/', obtain_jwt_token),
    path('auth/',include('rest_auth.urls')),
    path('auth/signup/',include('rest_auth.registration.urls')),
    path('auth/refresh-token/', refresh_jwt_token),
    # below url is admin url
    path('admin/', admin.site.urls),
    # below url is register url for users
    path('api/v1/', include('api.urls')),
]
