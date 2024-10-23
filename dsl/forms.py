# Here we can create the Forms for our projects
from django import forms


# Below Log_in_to_server is the Form using for login purpose in html
class Log_in_to_server(forms.Form):
    username = forms.CharField(max_length=30,required=True)
    password = forms.CharField(widget=forms.PasswordInput,required=True)
    class Meta:
        fields = ('username', 'password' )

    def save(self, commit = True):
        User = super(Signinn,self).save(commit = False)
        User.username = self.cleaned_data["username"]
        User.password = self.cleaned_data["password"]
        if commit:
            User.save()
        return User


# Below Register_to_server is the Form using for register purpose in html    
class Register_to_server(forms.Form):
    username = forms.CharField(max_length = 30)
    email = forms.EmailField(max_length = 50)
    password = forms.CharField(widget=forms.PasswordInput)

    class Meta:
        fields = ('username','email','password')