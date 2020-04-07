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

# uwsgi set up
sudo pip3 install uwsgi
sudo mkdir -p /etc/uwsgi/sites
cd /etc/uwsgi/sites && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/uwsgi/manager.ini
cd /etc/systemd/system/ && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/uwsgi/uwsgi.service
sudo systemctl start uwsgi.service
sudo rm /etc/nginx/sites-enabled/default
cd /etc/nginx/sites-available/ && sudo wget https://raw.githubusercontent.com/aleoreina/django-server-manager/master/uwsgi/manager.nginx
sudo ln -s /etc/nginx/sites-available/manager.nginx /etc/nginx/sites-enabled
sudo service nginx configtest && sudo service nginx restart


