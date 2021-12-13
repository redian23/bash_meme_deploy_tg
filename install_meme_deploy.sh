#!/bin/bash 
color_start='\e[0;'
color_end='\e[m'

F_Red=31m
B_Red=41m
F_Green=32m
F_Blue=34m

echo -e ${color_start}${F_Blue}"Start install MEME Deploy Service"${color_end}

for warn in {1..10}
do
    echo -ne "\r"
    echo -ne ${color_start}${F_Red}"Fill out the file <sample-credits.conf>, if you haven't already!"${color_end}
    sleep 0.5s
    
    echo -ne "\r"
    echo -ne ${color_start}${B_Red}"Fill out the file <sample-credits.conf>, if you haven't already!"${color_end}
    sleep 0.5s
done

work_path=$(echo -e `pwd`)
config_folder="/etc/meme-deploy.d"
source $work_path/sample-credits.conf

sudo mkdir $config_folder
sudo cp $work_path/sample-credits.conf $config_folder/user=$USER-credits.conf
sudo cp $work_path/meme_deploy.sh /usr/bin/meme_deploy.sh 

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

echo -e ${color_start}${F_Green}"Done ..."${color_end}