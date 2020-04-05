sudo apt-get update && sudo apt-get upgrade
sudo apt-get install build-essential nginx python-dev python-pip python-sqlite sqlite -y
sudo pip install virtualenv virtualenvwrapper
echo "export WORKON_HOME=~/Env" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc
sudo pip install uwsgi
cd /home/
mkdir django