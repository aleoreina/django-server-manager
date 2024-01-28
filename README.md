# django-server-manager 
###### (Current Development)

Download, Execute, Put your ip server and you get a Server Manager Admin panel in your Dedicated Server or VPS to deploy / uplodad your projects django by Domains

###  Requirements:
Ubuntu 22.04+

### Execute this before:
This is new in Ubuntu 22.04. The trouble in this case is with the needrestart command, which is part of the apt-get upgrade process in Ubuntu now. By default this is set to "interactive" mode which causes the interruption of scripts. 
Original Autor coming from Stackoverflow:  https://stackoverflow.com/a/73397970
So, execute this: 
```bash
sudo sed -i 's/#\$nrconf{restart} = '\''i'\'';/$nrconf{restart} = '\''l'\'';/g' /etc/needrestart/needrestart.conf
```

### Install
```bash
sudo -- sh -c 'cd /tmp/ && wget -c https://raw.githubusercontent.com/aleoreina/django-server-manager/master/install-djmserver.sh &&  chmod +X ./install-djmserver.sh && chmod 777 ./install-djmserver.sh && ./install-djmserver.sh'

```
