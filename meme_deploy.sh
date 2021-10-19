#!/bin/bash
work_path=$(echo -e `pwd`)
date=$(date '+%d/%m/%Y-%H:%M:%S');

source /etc/meme-deploy/*
config_files=($(ls /etc/meme-deploy/ | awk {'print $1'}))

log_file=/var/log/meme-deploy.log

scan_meme_folder(){
    memes_list=($(ls $meme_folder | awk {'print $1'}))
    #echo "${memes_list[@]}"

    if [ -d "${meme_folder}/posted/" ];
    then
        echo "Direcrory '/posted' exist!"
    else
        mkdir ${meme_folder}/posted/
    fi
}

deploy(){
    source $1
    for meme_num in ${memes_list[@]}
    do
        curl https://api.telegram.org/bot${BotToken}/sendphoto -F "chat_id=$CHAT_ID" -F "photo=@$meme_folder/$meme_num";
        echo "${date} Meme ${meme_num} Succsess send to TG Channal" | tee -a $log_file

        mv $meme_folder/$meme_num $meme_folder/posted/ & \
        echo "${date} Meme ${meme_num} moved on 'posted' folder" | tee -a $log_file

        local wait_time=$(shuf -i 45-60 -n 1)
        echo "${date} Next Meme ${meme_num} will be post in ${wait_time} minute" | tee -a $log_file
        sleep ${wait_time}m
    done
}

multi_deploy(){
    steams_list=${config_files[@]}
    for stream in $steams_list
    do
       echo $srteam | xargs -P 4 -n 1 deploy 
    done
}

echo "Meme Deploy Run ^-^"
scan_meme_folder
multi_deploy

#help
#https://unix.stackexchange.com/questions/47695/how-to-write-startup-script-for-systemd  
