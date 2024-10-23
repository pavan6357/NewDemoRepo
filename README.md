#Demos Project

To start the project use the below cli 
```
django-admin startproject "demos"
cd demos
python manage.py startapp "dsl"
```
to create a virutal environment use the below cli
```
python -m venv .venv
.venv/Scripts/activate
```

to install the requirements use the below cli
```
pip3 install -r requirements.txt
```

for DB setup use migrations cli as below
```
python manage.py makemigrations
python manage.py migrate
```

Finally you are ready to run the server, Lets Go!
```
python manage.py runserver


```