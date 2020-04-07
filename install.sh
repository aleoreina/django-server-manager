#Upgrade Linux
sudo apt-get update && sudo apt-get upgrade

#Adding user django with sudoers group
sudo adduser django --gecos "Django,127.0.0.1,0000,0000" --disabled-password
usermod –aG sudo django

# To prevent login from django and limit user root only.
echo "AllowUsers root" >> /etc/ssh/sshd_config
/etc/init.d/sshd restart

# No password to sudo commands
echo "django ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Entering to django
su django

# Installation of dependences
sudo apt-get install build-essential nginx python-dev python-pip python-sqlite sqlite python3 python3-pip -y
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv virtualenvwrapper

# VirtualEnvWrapper setting up (for user django)
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "export WORKON_HOME=~/Env" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc

# Getting up a clean project of django
cd /home/django
mkvirtualenv manager
pip install django
django-admin.py startproject manager
cd /home/django/manager/ && ./manage.py migrate
echo 'STATIC_ROOT = os.path.join(BASE_DIR, "static/")' >> manager/settings.py
./manage.py collectstatic
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \['*'\]/g" manager/settings.py
# To test it >>     ./manage.py runserver 0.0.0.0:8080

# Installing UWSGI
sudo pip3 install uwsgi

# Setting UP UWSGI
sudo mkdir -p /etc/uwsgi/sites

# Set up manager.ini to run project
cd /etc/uwsgi/sites && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/install/etc/manager.ini

# Set up uwsgi service 
cd /etc/systemd/system/ && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/install/etc/uwsgi.service

# To prevent, Killing all uwsgi services runned (if was runned)
killall uwsgi

# Running service of uwsgi
sudo systemctl start uwsgi.service

# Removing defaults of nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

# Adding project (manager) to nginx
cd /etc/nginx/sites-available/ && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/install/etc/manager.nginx

# Symbol link to appear the file in sites-enabled
sudo ln -s /etc/nginx/sites-available/manager.nginx /etc/nginx/sites-enabled

# Restarting testing server and restarting
sudo service nginx configtest && sudo service nginx restart


