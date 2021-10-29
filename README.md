# Universal automatic sending to Telegram service 
## Service to autosent meme's to telegram channals and chats.

## Install 
1. `Fill out the sample-credits.conf form!`
2. Run `install_meme_deploy.sh` script
3. (Optional) remove git clone folder

## To add more credint's (config files)
1. cd /etc/meme-deploy/
2. Copy first configure file 
3. Edit copied configure file & Save

`ALL configure files must have type a ".conf"`

# Отправка файлов

## Существует три способа отправки файлов (фотографии, наклейки, аудио, медиа и т. Д.).):
- Если файл уже хранится где-то на серверах Telegram, вам не нужно его перезагружать: у каждого объекта файла есть file_id поле, просто передайте это file_id в качестве параметра вместо загрузки. Есть без ограничений для файлов, отправленных таким образом.
- Предоставьте Telegram HTTP-URL для файла, который будет отправлен. Telegram загрузит и отправит файл. Максимальный размер 5 МБ для фотографий и максимум 20 МБ для других типов контента.
- Размещайте файл с помощью multipart / form-data обычным способом загрузки файлов через браузер. Максимальный размер 10 МБ для фотографий, 50 МБ для других файлов.