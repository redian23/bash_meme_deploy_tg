#!/bin/bash
work_path=$(echo -e `pwd`)

source /etc/meme-deploy/*
config_files=($(ls /etc/meme-deploy/*.conf | awk {'print $1'}))

log_file=/var/log/meme-deploy.log

check_meme_folder(){
    memes_list=($(ls $meme_folder | awk {'print $1'}))
    #echo "${memes_list[@]}" 

    #check meme_folder exist or not
    [ -d "${meme_folder}/posted/" ] || mkdir ${meme_folder}/posted/

    #check meme_folder empty or not
    [ "$(ls -A ${meme_folder}/posted/)" ] || send_emergency_alert
}

send_emergency_alert(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')
    source $1
    CHAT_ID=$admin_id

    for meme_num in ${memes_list[@]}
    do
        curl -s --data "text=💥MEME FOLDER IS EMPTY💥" --data "chat_id=$CHAT_ID" 'https://api.telegram.org/bot'${BotToken}'/sendMessage' > /dev/null \
        echo "${date} Meme folder is EMPTY ${channal_name}" | tee -a $log_file
        break
    done
}

send_to_tg(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')

    source $1
    for meme_num in ${memes_list[@]}
    do
        curl -s https://api.telegram.org/bot${BotToken}/sendphoto -F "chat_id=$CHAT_ID" -F "photo=@$meme_folder/$meme_num" > /dev/null && \
        echo "${date} Meme ${meme_num} Succsess send to ${channal_name}" | tee -a $log_file
        break
    done
}

move_to_posted(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')

    if [ $stream == "${config_files[-1]}" ];then
        mv $meme_folder/$meme_num $meme_folder/posted/ && \
        echo "${date} Meme ${meme_num} moved on 'posted' folder" | tee -a $log_file
    fi
}

run_timer(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')
    local wait_time=$(shuf -i 45-60 -n 1)

    echo "${date} Next Meme will be post in ${wait_time} minute" | tee -a $log_file
    sleep ${wait_time}m
}

multi_sending(){
    for stream in "${config_files[@]}"
    do
        send_to_tg $stream
    done
}

echo "Meme Deploy Run ^-^"
while :
do
    check_meme_folder
    multi_sending
    move_to_posted
    run_timer
done
