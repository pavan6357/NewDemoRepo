from django.shortcuts import render
from rest_framework import generics
from dsl import models
from . import serializers

class ProjectDetailsList(generics.ListCreateAPIView):
    queryset = models.ProjectDetails.objects.all()
    serializer_class = serializers.ProjectDetailsSerializer

class ProjectDetailsDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.ProjectDetails.objects.all()
    serializer_class = serializers.ProjectDetailsSerializer

class UserDetailsList(generics.ListCreateAPIView):
    queryset = models.UserDetails.objects.all()
    serializer_class = serializers.UserDetailsSerializer

class UserDetailsDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = models.UserDetails.objects.all()
    serializer_class = serializers.UserDetailsSerializer