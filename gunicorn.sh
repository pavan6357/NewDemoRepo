
#!/bin/bash
if [[ "$0" = "$BASH_SOURCE" ]]; then
    echo "Needs to be run using source: . activate_venv.sh"

else
    VENVPATH=".venv/bin/activate"
    if [[ $# -eq 1 ]]; then 
        if [ -d $1 ]; then
            VENVPATH="$1/bin/activate"
        else
            echo "Virtual environment $1 not found"
            return
        fi

    elif [ -d "venv" ]; then 
        VENVPATH=".venv/bin/activate"

    elif [ -d "env" ]; then 
        VENVPATH=".env/bin/activate"
    fi

    echo "Activating virtual environment $VENVPATH"
    source "$VENVPATH"
fi

#python3 manage.py makemigrations

#python3 manage.py migrate

#python3 manage.py collectstatic --noinput

sudo cp -rf /etc/systemd/system/gunicorn.service /home/administrator/demos-local

echo "copied service file."

sudo cp -rf /etc/systemd/system/gunicorn.socket /home/administrator/demos-local

sudo systemctl daemon-reload

echo "copied socket file."

sudo systemctl start gunicorn.socket

sudo systemctl enable gunicorn.socket

# sudo systemctl status gunicorn.socket

sudo systemctl daemon-reload

sudo systemctl restart gunicorn.service

echo "Gunicorn has started."

sudo systemctl enable gunicorn.service

echo "Gunicorn has been enabled."

sudo systemctl status gunicorn.service

# sudo systemctl restart gunicorn