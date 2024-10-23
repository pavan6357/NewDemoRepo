from django.db import connection,transaction
import psycopg2
from .models import *
import requests, json
import re
from django.conf import settings
from datetime import datetime
from django.core.exceptions import ObjectDoesNotExist
import pyotp
import base64
import math
import random
import smtplib



# Here we are defining a class by OMSManager
class OMSManager():

    @staticmethod
    @transaction.atomic
    def created_at(_username):
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.created_at(%s)",[_username])
            data = cursor.fetchall()
            return data


    @staticmethod
    @transaction.atomic
    def updated_at(_username):
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.updated_at(%s)",[_username])
            data = cursor.fetchall()
            return data

    @staticmethod
    @transaction.atomic
    def demos_list():
        with connection.cursor() as cursor:
            # public.demos_list is the postgresql funtion we are calling in demnmos_list function
            cursor.execute("SELECT public.demos_list()")
            cursor.execute('FETCH ALL IN "refcursor"')
            data = cursor.fetchall()
            length = len(data)
            listing = []

            i = 0
            for i in range(length):
                # j = 0

                login = {}
                login["dns"] = data[i][0]
                login["project_name"] = data[i][1]
                login["project_description"] = data[i][2]
                login["tech_stack"] = data[i][3]
                login["versions"] = data[i][4]
                login["ip_address"] = data[i][5]
                login["get_url"] = data[i][6]
                login["status"] = data[i][7]
                login["button"] = data[i][8]
                login["id"] = data[i][9]
                # print(login)
                # j= j + 1
                listing.append(login)
            #print(listing)
            return listing

    @staticmethod
    @transaction.atomic
    def login(_username,_password):
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.login(%s,%s)",[_username,_password])
            data = cursor.fetchall()
            return data

    @staticmethod
    @transaction.atomic
    def count_server():
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.count_server()")
                cursor.execute('FETCH ALL IN "refcursor"')
                data = cursor.fetchall()
                print(data)
                return data
        except Exception as e:
            return ("Error in Resetting password"+str(e))


    @staticmethod
    @transaction.atomic
    def stop(_projectname,_button):
        with connection.cursor() as cursor: 
            cursor.execute("SELECT public.stop(%s,%s)",[_projectname,_button])
            data = cursor.fetchone()[0]
            return data

    @staticmethod
    @transaction.atomic
    def start(_projectname,_button):
        with connection.cursor() as cursor: 
            cursor.execute("SELECT public.start(%s,%s)",[_projectname,_button])
            data = cursor.fetchone()[0]
            print(data)
            return data
            
    @staticmethod
    @transaction.atomic
    def insert_project_det( _dns, _projectname, _projectdescription, _techstack, _versions, _ipaddress, _giturl, _status, _button):
        with connection.cursor() as cursor:
            cursor.execute("SELECT public.insert_project_det(%s,%s,%s,%s,%s,%s,%s,%s,%s)",[_dns, _projectname, _projectdescription, _techstack, _versions, _ipaddress, _giturl, _status, _button])
            data = cursor.fetchall()
            return data
    
    @staticmethod
    @transaction.atomic
    def insert_users_details( _username, _email, _password, _is_active, _role):
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.insert_users_details(%s,%s,%s,%s,%s)",[_username, _email, _password, _is_active, _role])
                data = cursor.fetchall()
                return data
        except Exception as e:
            return("Error in creating users"+str(e))

    @staticmethod
    @transaction.atomic
    def forgot_password( _username, _password):
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.new_forgot_password(%s,%s)",[_username, _password])
                data = cursor.fetchall()
                return data 
        except Exception as e:
            return ("Error in Resetting password"+str(e))
    
    @staticmethod
    @transaction.atomic
    def get_user( _username):
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.get_user(%s)",[_username])
                cursor.execute('FETCH ALL IN "refcursor"')
                data = cursor.fetchall()
                print(data)
                return data
        except Exception as e:
            return ("Error in Resetting password"+str(e))


    @staticmethod
    @transaction.atomic
    def get_email( _username):
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.get_email(%s)",[_username])
                cursor.execute('FETCH ALL IN "refcursor"')
                data = cursor.fetchall()
                print(data)
                return data
        except Exception as e:
            return ("Unable to fetch email"+str(e))


    @staticmethod
    @transaction.atomic
    def update_code( _username, _code):
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.update_user(%s,%s)",[_username, _code])
                data = cursor.fetchall()
                return data
        except Exception as e:
            return ("Error in Resetting password"+str(e))


    @staticmethod
    @transaction.atomic
    def code_validation( _username, _code):
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.code_validation(%s,%s)",[_username, _code])
                data = cursor.fetchall()
                return data
        except Exception as e:
            return ("Error in Code Validation"+str(e))

    @staticmethod
    @transaction.atomic
    def login_validation( _username, _code):
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT public.login_validation(%s,%s)",[_username, _code])
                data = cursor.fetchall()
                return data
        except Exception as e:
            return ("Error in Code Validation"+str(e))
            
    @staticmethod
    @transaction.atomic
    def update(_id, data):
        response = []
        if data.get('_dns') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_dns(%s,%s)",
                    [_id, data.get('_dns')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating DNS"+str(e))
        else:
            response.append("Data not updated for dns")

        if data.get('_projectname') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_project_name(%s,%s)",
                    [_id, data.get('_projectname')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating projectname"+str(e))
        else:
            response.append("Data not updated for projectname")

        if data.get('_project_description') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_projectdesc(%s,%s)",
                    [_id, data.get('_project_description')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating project_description"+str(e))
        else:
            response.append("Data not updated for project_description")


        if data.get('_tech_stack') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_tech_stack(%s,%s)",
                    [_id, data.get('_tech_stack')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating tech_stack"+str(e))
        else:
            response.append("Data not updated for tech_stack")

        if data.get('_versions') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_versions(%s,%s)",
                    [_id, data.get('_versions')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating versions"+str(e))
        else:
            response.append("Data not updated for versions")

        if data.get('_ip_address') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_ip_address(%s,%s)",
                    [_id, data.get('_ip_address')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating ip_address"+str(e))
        else:
            response.append("Data not updated for ip_address")

        if data.get('_git_url') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_git_url(%s,%s)",
                    [_id, data.get('_git_url')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating git_url"+str(e))
        else:
            response.append("Data not updated for git_url")

        if data.get('_status') is not None :
            try: 
                with connection.cursor() as cursor:
                    cursor.execute("SELECT public.update_status(%s,%s)",
                    [_id, data.get('_status')])
                    result = cursor.fetchone()[0]
                    response.append(result)
            except Exception as e:
                response.append("Error in updating status"+str(e))
        else:
            response.append("Data not updated for status")


    # @staticmethod
    # @transaction.atomic
    # def buttonstats(_projectname,_button):
    #     with connection.cursor() as cursor: 
    #         cursor.execute("SELECT public.button_status(%s,%s)",[_projectname,_button])
    #         cursor.execute('FETCH ALL IN "refcursor"')
    #         data = cursor.fetchall()
    #         return data

#dns=?, project_name=?, project_description=?, tech_stack=?, versions=?, ip_address=?, git_url=?, status=?, button=?, id=?
#XXXXXXXXXXXXXXXXXXXXXXXXX old code xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    
    
    # @staticmethod
    # @transaction.atomic
    # # we are creating post_products function used to checking the project_name is there or not database based on _projectname and _status parameters
    # # If it is there it will return projectname and status if not it return none
    # def post_products(_projectname,_status):
    #     with connection.cursor() as cursor:
    #         # public.projectname is the postgresql funtion we are calling in post_products function
    #         cursor.execute("SELECT public.projectname(%s,%s)",[_projectname,_status])
    #         cursor.execute('FETCH ALL IN "refcursor"')
    #         resdata = cursor.fetchone()
    #         print(resdata)
    #         return resdata

    # # we are creating insert_data function for insert new data in database
    # def insert_data(_dns,_project_name,_project_description,_tech_stack,_versions,_ip_address,_git_url,_status,_button):
    #     with connection.cursor() as cursor:
    #         cursor.execute("SELECT public.insertdata(%s,%s,%s,%s,%s,%s,%s,%s,%s)",[_dns,_project_name,_project_description,_tech_stack,_versions,_ip_address,_git_url,_status,_button])
    #         cursor.execute('''SELECT * FROM "projectlisting"''', connection)
    #         form1 = cursor.fetchall()
    #         return form1
    # # we are creating two functions for update data in database  
    # def update_datastart(_projectname,_button):
    #     print(_projectname,_button)
    #     with connection.cursor() as cursor:
    #         cursor.execute("SELECT public.updatetablestart(%s,%s)",[_projectname,_button])
    #         connection.commit()
    #         resdata = cursor.fetchone()[0]
    #         return resdata
    # def update_datastop(_projectname,_button):
    #     with connection.cursor() as cursor:
    #         cursor.execute("SELECT public.updatetablestop(%s,%s)",[_projectname,_button])
    #         resdata = cursor.fetchall()
    #         return resdata
    # def table_check(_projectname):
    #     with connection.cursor() as cursor:
    #         cursor.execute('select project_name from "projectlisting" where project_name=%s',[_projectname])
    #         res_check=cursor.fetchall()
    #         return res_check






        #     return str(phone_num) + str(datetime.date(datetime.now())) + "Secret Key"

    # @staticmethod
    # @transaction.atomic
    # def getPhoneNumberRegistered(request,phone_num):
    #     try:
    #         Mobile = UserDetails.objects.get(Mobile=phone_num)
    #     except ObjectDoesNotExist:
    #         UserDetails.objects.create(Mobile=phone_num,)
    #         Mobile = UserDetails.objects.get(Mobile=phone_num)
    #     Mobile.counter += 1
    #     Mobile.save()
    #     key = base64.b32decode(returnOtp(phone_num).encode())
    #     OTP = pyotp.HTOP(key)
    #     print(OTP.at(Mobile.counter))
    #     return ({"OTP": OTP.at(Mobile.counter)})

    # @staticmethod
    # @transaction.atomic
    # def verifyOtp(request,phone_num):
    #     try:
    #         Mobile = UserDetails.objects.get(Mobile = phone_num)
    #     except ObjectDoesNotExist:
    #         return ("User does not exist")
        
    #     key = base64.b32encode(returnOtp(phone_num).encode())
    #     OTP = pyotp.HOTP(key)
    #     if OTP.verify(request.data["otp"], Mobile.counter):
    #         Mobile.isVerified = True
    #         MobileMobile.save()
    #         return ("you are authorized")
    #     return ("OTP is wrong")
  

  