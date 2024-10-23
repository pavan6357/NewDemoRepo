from django.urls import path
from dsl.views import demos_list,login,buttonstats,insert_project_det,insert_users_details,forgot_password,email_otp,forgot_password_code,code_validation,system_spec,login_validation
urlpatterns=[
    # path('signuptoServer/',serverSignup),
    # below url is login to dsl application for users
    #path('signintoServer/',serverSignin),
    # below urls is shows the projects list in server and make changes and start or stop servers
    #path('projectdetails/project/',project_updated_data),
    # path('projectdetails/projectdetails/',project_details),

    # path('insertdata/',insertdatas),
    path('demoslist/',demos_list),
    path('login/',login),
    path('button/',buttonstats),
    path('insertnewproject/',insert_project_det),
    path('insertuser/',insert_users_details),
    path('forgotpassword/',forgot_password),
    # path('phonenumber/',phone_num),
    path('emailotp/',email_otp),
    path('forgotpasswordcode/',forgot_password_code),
    path('codevalidation/',code_validation),
    path('systemspec/',system_spec),
    path('loginotpvalidation/',login_validation),




    # path('updatedetails/<_id>/',update),




    # path('status/',project_status)
]