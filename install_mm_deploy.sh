#!/bin/bash 

config_folder="/etc/meme-deploy"
source ~/sample-credits.conf

user=$USER
mkdir $config_folder
cp ~/sample-credits.conf $config_folder/$user-credits.conf
cp ~/meme_deploy.sh /usr/bin/meme_deploy.sh 


sudo echo '[Unit]
Description=Meme deploy script ot Telegramm public_chanal

[Service]
ExecStart=/usr/bin/meme_deploy.sh 

[Install]
WantedBy=multi-user.target 
' > /lib/systemd/system/meme_deploy.service 

sudo systemctl enable meme_deploy.service  
sudo systemctl start meme_deploy.service 
sudo systemctl status meme_deploy.service 
