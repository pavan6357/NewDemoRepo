# we are import some modules what we required from requirements.txt
from django.contrib.auth import authenticate
from django.shortcuts import render, redirect
import psycopg2
from dsl.forms import *
import csv
from dsl.models import *
from rest_framework.decorators import api_view
from dsl.managers import OMSManager
from django.db import connection,transaction
import psycopg2
from rest_framework.response import Response
from dsl.serializers import DemosSerializers , UserSerializers
from django.conf import settings
import numpy as np
import json, requests
import os
from dotenv import load_dotenv
import math
import string
import random
import smtplib
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
import platform,socket,re,uuid,json,psutil,logging
from rest_framework import status





# Here we are creating serverList API for showing the data in database 

OMSManager = OMSManager()
username =os.getenv('username')
password =os.getenv('password')
Authorizationtype =os.getenv('Authorizationtype')
Authorization =os.getenv('Authorization')
email =os.getenv('email')
emailpassword =os.getenv('emailpassword')
SENDGRID_API_KEY=os.getenv('SENDGRID_API_KEY')
URL =os.getenv('url')


@api_view(['POST'])
def login(request):
    if request.method=='POST':
        data=request.data
        result = OMSManager.login(data['username'],data['password'])
        if result[0][0]=="successfully validated":
            login = {}
            login["status"] = result[0][0]
            url = URL

            payload = json.dumps({
                "username": username,
                "password": password
            })
            headers = {
            'Content-Type': 'application/json',
            'Authorization': Authorizationtype+Authorization
            }

            response = requests.request("POST", url, headers=headers, data=payload)

            token = response.json()
            login["token"] = token["token"]
            return Response(login)
        else:
            login = {}
            login["status"] = result[0][0]
            return Response(login)
    else:
        return Response({"error":"Method Not Allowed"},status=status.HTTP_405_METHOD_NOT_ALLOWED)


@api_view(['POST'])
def email_otp(request):
    if request.method=='POST':
        digits="0123456789"
        OTP = ""
        for i in range(6):
            OTP+=digits[math.floor(random.random()*10)]
        otp = OTP + " is your OTP for email Verification"
        msg = otp

        data = request.data
        name = OMSManager.get_user(data['_username'])
        temp2 = OMSManager.get_email(data['_username'])
        temp = name[0][0]
        print(temp)
        print(temp2[0][0])

        cursor = connection.cursor()
        cursor.execute("Update public.userdetails set login_otp = %s where username = %s",[str(OTP),str(temp)])
        connection.commit()

        message = Mail(
        from_email=email,
        to_emails=temp2[0][0],
        subject='OTP for email verification.',
        html_content=msg)
        try:
            print(SENDGRID_API_KEY)
            sg = SendGridAPIClient(SENDGRID_API_KEY)
            data = sg.send(message)
            # print(data.status_code)
            # print(data.body)
            # print(data.headers)
            
            return Response({"status":"Mail sent successfully."})
            # return make_response(jsonify(data), 200)

        except Exception as e:
            # return make_response(jsonify(e), 200)
            return Response({"error":"Error in sending mail {}".format(e)})
    else:
        return Response({"error":"Method Not Allowed"})


@api_view(['POST'])
def forgot_password_code(request,size=6, chars=string.ascii_uppercase + string.digits):
    if request.method=='POST':
        data = request.data
        name = OMSManager.get_user(data['_username'])
        temp2 = OMSManager.get_email(data['_username'])
        temp = name[0][0]
        print(temp)
        print(temp2[0][0])
        strcode = (''.join(random.choice(chars) for _ in range(size)))
        print(strcode)
        cursor = connection.cursor()
        cursor.execute("Update public.userdetails set forgot_password_code = %s where username = %s",[str(strcode),str(temp)])
        connection.commit()
        msg = strcode + " is your code for Password verification."
        message = Mail(
        from_email=email,
        to_emails=temp2[0][0],
        subject='Code for password verification.',
        html_content=msg)
        try:
            sg = SendGridAPIClient(SENDGRID_API_KEY)
            data = sg.send(message)
            updated = OMSManager.updated_at(temp)
            
            return Response({"status":"Mail sent successfully."})

        except Exception as e:
            return Response({"error":"Error in sending mail {}".format(e)})
    else:
        return Response({"error":"Method Not Allowed"})

@api_view(['POST'])
def code_validation(request):
    if request.method=='POST':
        data = request.data
        result = OMSManager.code_validation(data['_username'], data['_code'])
        if result[0][0] == "Code Validated Successfully":
            return Response({"Status":"{}".format(result[0][0])})
        else:
            return Response({"Status":"{}".format(result[0][0])})
    else:
        return Response({"error":"Method Not Allowed"})

@api_view(['POST'])
def login_validation(request):
    if request.method=='POST':
        data = request.data
        result = OMSManager.login_validation(data['_username'], data['_code'])
        if result[0][0] == "OTP Validated Successfully":
            return Response({"Status":"{}".format(result[0][0])})
        else:
            return Response({"Status":"{}".format(result[0][0])})
    else:
        return Response({"error":"Method Not Allowed"})

@api_view(['PUT'])
def forgot_password(request):
    if request.method=='PUT':
        data = request.data
        result = OMSManager.forgot_password(data['_username'], data['_password'])
        if result[0][0] == "Successfully Updated Password":
            return Response({"Status":"{}".format(result[0][0])})
        else:
            return Response({"Status":"{}".format(result[0][0])})
    else:
        return Response({"error":"Method Not Allowed"})

   

@api_view(['GET'])
def demos_list(request):
    if request.method=='GET':
        data=request.data
        result = OMSManager.demos_list()
        #result1 = np.array(result)
        return Response(result)
    else:
        return Response({"error":"Method Not Allowed"},status=status.HTTP_405_METHOD_NOT_ALLOWED)


@api_view(['PUT'])
def buttonstats(request):
    if request.method=='PUT':
        data=request.data

        if data['_button'] == "stop":
            res = OMSManager.stop(data['_projectname'],data['_button'])
        else:
            res = OMSManager.start(data['_projectname'],data['_button'])
        return Response("{} {}".format(data['_projectname'],res))
    else:
        return Response({"error":"Method Not Allowed"},status=status.HTTP_405_METHOD_NOT_ALLOWED)



@api_view(['POST'])
def insert_project_det(request):
    if request.method=='POST':
        data=request.data
        result = OMSManager.insert_project_det(data['_dns'], data['_projectname'], data['_projectdescription'], data['_techstack'], data['_versions'], data['_ipaddress'], data['_giturl'], data['_status'], data['_button'])
        if result[0][0] == "Successfully Created":
            print(result)
            # return Response('202: User created succesfully {}'.format(result))
            return Response({"Status":"project added : {}".format(result)})
        else:
            return Response({"error":"Project could not be added "})
    else:
        return Response({"error":"Method Not Allowed"})


@api_view(['GET'])
def system_spec(request):
    if request.method=='GET':
        l1, l2, l3 = psutil.getloadavg()
        CPU_use = (l3/os.cpu_count()) * 100

        RAM = int(psutil.virtual_memory()[2])
        print(CPU_use)
        print(RAM)      

        return Response({"Ram usage is":"{}" " CPU usage is""{}".format(RAM,CPU_use)})
    else:
        return Response({"error":"Method Not Allowed"})


@api_view(['POST'])
def insert_users_details(request):
    if request.method=='POST':
        data = request.data
        result = OMSManager.insert_users_details(data['_username'], data['_email'], data['_password'], data['_is_active'], data['_role'])
        if result[0][0] == "Successfully Created User":
            print(result[0][0])
            return Response({"Status":"{}".format(result[0][0])})
        else:
            return Response ({"Error":"User Already exist"})
    else:
        return Response({"error":"Method Not Allowed"})



@api_view(['PUT'])
def buttonstats(request):
    if request.method=='PUT':
        l1, l2, l3 = psutil.getloadavg()
        CPU_use = (l3/os.cpu_count()) * 100
        RAM = int(psutil.virtual_memory()[2])
        # print(CPU_use)
        # print(RAM)     
        if RAM < 80:
            data=request.data
            print(RAM)
            if data['_button'] == "stop":
                res = OMSManager.stop(data['_projectname'],data['_button'])
            else:
                res = OMSManager.start(data['_projectname'],data['_button'])
            return Response({"{} {}".format(data['_projectname'],res)})
        else:
            print(RAM)
            print(CPU_use)
            return Response({"Error":"Stop other running Applications and Try agian.."},status=status.HTTP_403_FORBIDDEN)

    else:
        return Response({"error":"Method Not Allowed"},status=status.HTTP_405_METHOD_NOT_ALLOWED)

# @api_view(['PUT']) def update(request, _id): if request.method == 'PUT': update_data = OMSManager.update(request.data) if update_data == "Successfully Updated": return Response({"message":"Data updated successfully for {}".format(update_data),"_id": "{}".format(_id)}, status=status.HTTP_200_OK, headers={"Access-Control-Allow-Origin":"*"}) else: return Response({"message":"Data Given is Incorrect","_id": "{}".format(_id)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR, headers={"Access-Control-Allow-Origin":"*"}) else: return Response({"error":"Method Not Allowed"},status=status.HTTP_405_METHOD_NOT_ALLOWED)
# @api_view(['POST'])
# def startstop(request):data[
    # connection = psycopg2.connect(database="demoServer", user='dbusrname', password='dbpass', host='127.0.0.1',
    #                               port='5432')
    # cursor = connection.cursor()
    # # Below query will create the table in database
    # query = """ CREATE TABLE IF NOT EXISTS ProjectListing(dns text,project_name text,project_description text,tech_stack text,versions text,ip_address text,git_url text,status text,button text)"""
    # cursor.execute(query)
    # connection.commit()
    # # From here we are reading the data in CSV file
    # with open('/home/bhuvanesh/demos_pro/demos/ListProject.csv') as file:
    #     csvreader = csv.reader(file)
    #     rows = []
    #     for row in csvreader:
    #         rows.append(row)
    # cursor.execute('''SELECT * FROM "projectlisting"''', connection)
    # res = cursor.fetchall()
    # project_names=[]
    # if len(res) > 0:
    #     for i in range(len(res)):
    #         project_names.append(res[i][1])
    #     for i in range(1, len(rows) - 1):
    #         if rows[i + 1][1] in project_names:
    #             break
    #         # Below queries will help to insert the data in table from CSV file
    #         query = "INSERT INTO ProjectListing (dns,project_name,project_description,tech_stack,versions,ip_address,git_url,status,button) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s)"
    #         cursor.execute(query, [str(rows[i + 1][0]), str(rows[i + 1][1]), str(rows[i + 1][2]), str(rows[i + 1][3]),
    #                                str(rows[i + 1][4]), str(rows[i + 1][5]), str(rows[i + 1][6]), str(rows[i + 1][7]),
    #                                str(rows[i + 1][8])])
    #         connection.commit()
    # else:
    #     query = "INSERT INTO ProjectListing (dns,project_name,project_description,tech_stack,versions,ip_address,git_url,status,button) VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s)"
    #     cursor.execute(query, [str(rows[1][0]), str(rows[1][1]), str(rows[1][2]), str(rows[1][3]), str(rows[1][4]),
    #                            str(rows[1][5]), str(rows[1][6]), str(rows[1][7]), str(rows[1][8])])
    #     connection.commit()
    # # Here we read the data in table and send to UI
    # cursor.execute('''SELECT * FROM "projectlisting"''', connection)
    # form = cursor.fetchall()
    # cursor.close()
    # connection.close()
    # # We are takinbg the demoprojectsListing.html file for frontend
    # return Response(form)#(request, 'demoprojectsListing.html', {'form': form})

# Here we are creating the API for login to server
# @api_view(['GET','POST'])
# def serverSignin(request):
#     form = Log_in_to_server()
#     if request.method == 'POST':
#         usernamee = request.POST.get('username')
#         passwordd = request.POST.get('password')
#         # we are athenticating the username and password
#         user = authenticate(username=usernamee, password=passwordd)
#         connection = psycopg2.connect(database="demoServer", user='dbusrname', password='dbpass',
#                                       host='127.0.0.1',
#                                       port='5432')
#         cursor = connection.cursor()
#         # Here we are taking the details of already register users for checking the entered details for login is True or False  
#         cursor.execute('SELECT * from Register_Users', connection)
#         res = cursor.fetchall()

#         for i in range(len(res)):
#             if usernamee == res[i][0] and passwordd == res[i][2]:
#                 if not request.user.is_authenticated:
#                     cursor.close()
#                     connection.close()
#                     return Response("user {} successfully logged in".format(request.POST.get('username')))#(request,"LogintoServer.html",{"form": form})

#         else:
#             cursor.close()
#             connection.close()
#             return redirect('/dsl/signintoServer/')
#             # If the details is False then it will redirect to ('/signintoServer/') PATH
#     # Here we are taking the LogintoServer.html for frontend
#     return Response("user {} NOT successfully logged in".format(request.POST.get('username')))#(request,"LogintoServer.html",{"form": form})

# Here we are creating the API for signup for the server
# @api_view(['GET','POST'])
# def serverSignup(request):
#     form = Register_to_server()
#     connection = psycopg2.connect(database="demoServer", user='dbusrname', password='dbpass',
#                                   host='127.0.0.1',
#                                   port='5432')
#     cursor = connection.cursor()
#     # We are creating Register_Users table for store User entered data
#     cursor.execute("CREATE TABLE IF NOT EXISTS Register_Users (username text,email text not null unique,password text)")
#     connection.commit()
#     if request.method == 'POST':
#         form = Register_to_server(request.POST)
#         if form.is_valid():
#             username = form.cleaned_data.get('username')
#             email = form.cleaned_data.get('email')
#             raw_password = form.cleaned_data.get('password')
#             cursor.execute('SELECT * from Register_Users')
#             res = cursor.fetchall()
#             if len(res) == 0:
#                 # here we are insert user details in Register_Users table when the table is empty
#                 cursor.execute("INSERT INTO Register_Users(username,email,password) VALUES(%s,%s,%s)",
#                                [str(username), str(email), str(raw_password)])
#                 connection.commit()
#                 cursor.close()
#                 connection.close()
#                 # After Insert data this will redirect to ('/signintoServer/') PATH
#                 return redirect('/dsl/signintoServer/')

#             else:
#                 for i in range(len(res)):

#                     if email in res[i][1]:
#                         cursor.close()
#                         connection.close()
#                         # If user entered email is alredy in table  then  it will not insert the data and redirect to ('/signintoServer/') PATH
#                         return redirect('/dsl/signintoServer/')

#                     else:
#                         # If user entered email is not in table then data will add in table
#                         cursor.execute("INSERT INTO Register_Users(username,email,password) VALUES(%s,%s,%s)",
#                                        [str(username), str(email), str(raw_password)])
#                         connection.commit()
#                         cursor.close()
#                         connection.close()
#                         # After adding data it will redirect  to ('/signintoServer/') PATH
#                         return redirect('/dsl/signintoServer/')
        
#     cursor.close()
#     connection.close()
#     # Here we are taking 'SignuptoServer.html' for frontend
#     return render(request, 'SignuptoServer.html', {'form': form})

# Here we are creating the API for project details
# @api_view(['GET','PUT'])
# def project_details(request):
#     ref = "project is already in that position change parameters"
#     # here for this req variable we have to take the project name fromm where we click the button in frontend
#     u = request.query_params.get('projectname')
#     s = request.query_params.get('status')
#     # Here i am calling the post_products function in OMSManager class for getting projectname 
#     res = OMSManager.post_products(u, s)
#     print(res)
#     print(res)


#     try:
#         resdict = {}
#         resdict['project_name'] = res[0]
#         if u == resdict['project_name']:
#             if u == "":
#                 if res[1] == 'start':
#                     # here if we pass empty projectname and button is 'start' the project is started sahyadri Ecommerce
#                     s = 'stop'
#                     # here update_datastart in OMSManager will trigger when above conditions is True and update data using projectname
#                     res = OMSManager.update_datastop(u, s)
#                     ref = 'sahyadri Ecommerce project server is running now'

#                 elif res[1] == 'stop':
#                     # here if we pass empty projectname and button is 'stop' the project is stoped with mentioned sahyadri Ecommerce
                    
#                     s = 'start'
#                     # here update_datastart in OMSManager will trigger when above conditions is True and update data using projectname                 
#                     res = OMSManager.update_datastart(u, s)
#                     ref = "sahyadri Ecommerce project server is already running,now the server is stoped"
#             else:
#                 if res[1] == 'start':
#                     # here if we pass  projectname and button is 'start' the project is started with mentioned projectname
#                     s = 'stop'
#                     # here update_datastart in OMSManager will trigger when above conditions is True and update data using projectname
#                     res = OMSManager.update_datastop(u, s)
#                     ref = res[0] + " " + 'project server is running now'


#                 elif res[1] == 'stop':
#                     # here if we pass  projectname and button is 'stop' the project is stoped with mentioned projectname
#                     print(ref)
#                     s = 'start'
#                     # here update_datastart in OMSManager will trigger when above conditions is True and update data using projectname
#                     res = OMSManager.update_datastart(u, s)
#                     ref = res[0] + " " + "project server is already running,now the server is stoped" ""

            
#     except Exception as e:
#         # If exception is raise in Try then it will return
#         ref = "this is already in this status change status parameter"
#     # Here we are taking 'projectStatus.html' for frontend
#     return Response(ref)#(request, 'projectStatus.html', {'form': ref})


# # Here we are creating the API for Insert data in table
# @api_view(['POST'])
# def insertdatas(request):
#     u = request.query_params.get('projectname')
#     # Here we are creating table_check in OMSManager for checking table using projectname and return projectname 
#     res = OMSManager.table_check(u)
#     if res:
#         # If res is not empty then this condition will work
#         form='this row is already in database go and check in database'
#         return render(request, 'projectStatus.html', {'form': form})

#     else:
#         # If res is empty then this else condition will work
#         # here insert_data function in OMSManager will trigger and pass these parameters and return table
#         form = OMSManager.insert_data(request.query_params.get('dns'), request.query_params.get('projectname'),
#                                     request.query_params.get('description'), request.query_params.get('techstack'),
#                                     request.query_params.get('versions'), request.query_params.get('ip'),
#                                     request.query_params.get('git'), request.query_params.get('status'),
#                                     request.query_params.get('button'))

#         # Here we are taking 'demoprojectsListing.html' for frontend
#         return Response(form)#(request, 'demoprojectsListing.html', {'form': form})
    
    




        
