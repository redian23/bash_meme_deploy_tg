#!/bin/bash
work_path=$(echo -e `pwd`)

source /etc/meme-deploy/*
config_files=($(ls /etc/meme-deploy/*.conf | awk {'print $1'}))
log_file=/var/log/meme-deploy.log

check_meme_folder(){
    source $1
    meme_list=($(ls $meme_folder | grep -v 'posted'))
    #echo "${meme_list[@]}"

    #check meme_folder empty or not
    [ "$(ls -A ${meme_folder}/*.jpg)" ] || send_emergency_alert $1 && \

    #check meme_folder exist or not
    [ -d "${meme_folder}/posted/" ] || mkdir ${meme_folder}/posted/
}

send_emergency_alert(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')
    source $1
    CHAT_ID=$admin_id

    curl -s --data "text=💥FOLDER <${meme_folder}> IS EMPTY for ${channal_name}💥" \
            --data "chat_id=${CHAT_ID}" 'https://api.telegram.org/bot'${BotToken}'/sendMessage' > /dev/null && \
    echo "${date} Folder is EMPTY for ${channal_name}" | tee -a $log_file
}

send_to_tg(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')
    source $1

    for meme_num in ${meme_list[@]}
    do
        if [[ $(echo ${meme_num} | grep -c '.jpg') == "1" || $(echo ${meme_num} | grep -c '.png') == "1" || $(echo ${meme_num} | grep -c '.jpeg') == "1" ]];
        then
            #-F caption="$(date)"
            curl -s https://api.telegram.org/bot${BotToken}/sendphoto -F "chat_id=${CHAT_ID}" -F "photo=@${meme_folder}/${meme_num}" > /dev/null && \
            echo "${date} Meme ${meme_num} Succsess send to ${channal_name}" | tee -a $log_file

        elif [[ $(echo ${meme_num} | grep -c '.mp4') == "1" || $(echo ${meme_num} | grep -c '.mov') == "1" ]];
        then
            curl -s -F video=@"$meme_folder/${meme_num}" https://api.telegram.org/bot${BotToken}/sendVideo?chat_id=${CHAT_ID}  && \
            echo "${date} Video ${meme_num} Succsess send to ${channal_name}" | tee -a $log_file
        else
            curl -s -F document=@"$meme_folder/${meme_num}" https://api.telegram.org/bot${BotToken}/sendDocument?chat_id=${CHAT_ID} && \
            echo "${date} Document ${meme_num} Succsess send to ${channal_name}" | tee -a $log_file
        fi
        break
    done
}

move_to_posted(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')
    source $1

    mv $meme_folder/${meme_num} $meme_folder/posted/ && \
    echo "${date} File ${meme_num} moved on 'posted' folder" | tee -a $log_file
}

run_timer(){
    local date=$(date '+%d/%m/%Y-%H:%M:%S')
    local wait_time=$(shuf -i 45-60 -n 1)

    echo "${date} Next Meme will be post in ${wait_time} minutes" | tee -a $log_file
    sleep ${wait_time}m
}

multi_sending(){
    for stream in "${config_files[@]}"
    do
        check_meme_folder $stream
        send_to_tg $stream
        move_to_posted $stream
    done
}

echo "Meme Deploy Run ^-^"
while :
do
    multi_sending
    run_timer
done
