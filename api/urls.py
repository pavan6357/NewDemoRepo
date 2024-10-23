from django.urls import path, include

from . import views

urlpatterns = [
    path('',views.ProjectDetailsList.as_view()),
    path('<int:pk>/',views.ProjectDetailsList.as_view()),
    path('rest-auth/', include('rest_auth.urls')),
    path('dsl/', include('dsl.urls')),


]