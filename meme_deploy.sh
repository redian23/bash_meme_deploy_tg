#!/bin/bash
work_path=$(echo -e `pwd`)

source /etc/meme-deploy/*
config_files=($(ls /etc/meme-deploy/*.conf | awk {'print $1'}))

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

sent_to_tg(){
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

run_scheduler(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')
    local wait_time=$(shuf -i 45-60 -n 1)

    echo "${date} Next Meme will be post in ${wait_time} minute" | tee -a $log_file
    sleep ${wait_time}m
}

multi_senting(){
    for stream in "${config_files[@]}"
    do
        sent_to_tg $stream
    done
}

echo "Meme Deploy Run ^-^"
while :
do
    scan_meme_folder
    multi_senting
    move_to_posted
    run_scheduler
done
