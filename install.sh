#Installing Dependences
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install build-essential nginx python-dev python-pip python-sqlite sqlite -y
sudo pip install virtualenv virtualenvwrapper
echo "export WORKON_HOME=~/Env" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc
sudo pip install uwsgi
# Creating project files
cd /home/ && mkdir django
cd /home/django && mkdir manager
cd /home/django/manager && mkvirtualenv manager
pip install Django
# Create a demo project to see if all are OK
django-admin.py startproject manager
cd /home/django/manager/manager && ./manage.py migrate
echo 'STATIC_ROOT = os.path.join(BASE_DIR, "static/")' >> manager/settings.py
./manage.py collectstatic
# curl https://ipinfo.io/ip
sed -i "s/ALLOWED_HOSTS \[\]/ALLOWED_HOSTS = \['*'\]/g" manager/settings.py
./manage.py runserver 0.0.0.0:8080