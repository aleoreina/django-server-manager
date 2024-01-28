#!/bin/bash  -i

#Upgrade Linux
sudo apt-get update && sudo apt-get upgrade -y

#Adding user django with sudoers group
sudo adduser django --gecos "Django,127.0.0.1,0000,0000" --disabled-password

# Adding user "django" to group of sudoers 
usermod -aG sudo django

# To prevent login from django and limit user root only.
echo "AllowUsers ubuntu" >> /etc/ssh/sshd_config

# No password to sudo commands for user "django"
echo "django ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Taking a restart of SSH
sudo service ssh restart

# Entering to django
#su django

# Installation of dependences

# Begin - next-line updated || required by Ubuntu 22.04 works!
sudo apt-get install build-essential nginx python3-pip sqlite python3 git -y 
# End - next-line updated || required by Ubuntu 22.04 works!
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install gcc g++ make -y 
sudo apt-get install nodejs -y 
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y
# Special requirement for manager (django)
npm install is-github-url -g
sudo -H pip3 install --upgrade pip 
sudo -H pip3 install virtualenv virtualenvwrapper

# VirtualEnvWrapper setting up (for user django)
su django -c "echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc"
su django -c "echo 'export WORKON_HOME=/home/django/Env' >> ~/.bashrc"
su django -c "echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc"


# Getting up a clean project of django
cd /home/django
su django -c "git clone https://github.com/aleoreina/django-server-manager.git"
su django -c "mv ./django-server-manager ./manager"
cd /home/django/manager
source /home/django/.bashrc
mkvirtualenv manager
deactivate
source /home/django/Env/manager/bin/activate
pip install -r req.txt
su django -c "yarn"
./manage.py makemigrations
./manage.py migrate
./manage.py collectstatic
deactivate

# Returning permission for enviroment to user django
chown -R django /home/django/Env
chown -R django /home/django/manager

# Install ACL
sudo apt-get install acl -y

# Installing UWSGI
sudo pip3 install uwsgi

# Setting UP UWSGI
sudo mkdir -p /etc/uwsgi/sites

# Set up manager.ini to run project
cd /etc/uwsgi/sites && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/install/etc/manager.ini

# Set up uwsgi service 
cd /etc/systemd/system/ && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/install/etc/uwsgi.service

# Removing defaults of nginx
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

# Adding project (manager) to nginx
cd /etc/nginx/sites-available/ && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/install/etc/manager.nginx

# Symbol link to appear the file in sites-enabled
sudo ln -s /etc/nginx/sites-available/manager.nginx /etc/nginx/sites-enabled

# django_cache tmp added
sudo mkdir /tmp/django_cache/

# Fixing permission for projects in Django:
sudo setfacl -R -m user:www-data:rwx  /home/django/

# Fixing permission for projects in Django (Cache):
sudo setfacl -R -m user:www-data:rwx  /tmp/django_cache/

# Restarting testing server and restarting
sudo service nginx configtest && sudo service nginx restart

# To prevent, Killing all uwsgi services runned (if was runned)
#killall uwsgi

# Running service of uwsgi
sudo systemctl restart uwsgi
