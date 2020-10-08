#!/bin/bash
REMOVE_AFTER=$1 #Запоминаем входной параметр в отдельную переменную
backup_dir=/var/lib/backups/
if [ ! -d $backup_dir ] #Проверяем, папку на существование. Если не существует, то создаем
    then
    mkdir -p $backup_dir
    fi
while [ true ]  #Запускаем бесконечный цикл, чтобы скрипт не завершался
do
    backup_date=$(date "+%Y-%m-%d") #Получаем дату бэкапа и сохраняем ее в переменную, чтобы использовать в именовании бэкапа
    if [[ date "+%H" - eq 2 && ! -f $backup_dir/etc-backup-$backup_date.tar.gz ]]
    then
        find $backup_dir -mtime +$REMOVE_AFTER -exec rm -f {}\     #Проверяем бэкапы старше $REMOVE_AFTER дней и удаляем
        echo "Creating new backup"
        tar cvfz $backup_dir/etc-backup-$backup_date.tar.gz /etc && echo "New backup Created" || echo "There was some error when creating backup"
    else
        echo "There is no time to creating Backup or backup was already created"
        sleep 1000 #Sleep 1000 - ожидание в 1000 секунд, перед повторением цикла.
    fi
done