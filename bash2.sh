#!/bin/bash
SHELL=/bin/bash PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/ostrovok/scripts
URL_SERVER='netts01' # URL without http prefix to load chromium URLs from
WATCHDOG_ENABLED=true # track if watchdog is enabled
sleep 20 # give nettop time to init stuff

ping -c 1 -w 1 $URL_SERVER > /dev/null 2>&1
until [ $? = 0 ] # check if we have internet connection
do
  echo No internet connection. Retrying in 5 seconds!
  sleep 5
  ping -c 1 -w 1 $URL_SERVER > /dev/null 2>&1
done

HTTPSTATUS=`wget --server-response -qO- http://$URL_SERVER 2>&1 | grep "HTTP/" | tail -1 | awk '{print $2}'`
until [ $HTTPSTATUS = '200' ] # only start chromium if HTTP status code is 200
do
  	echo Looks like this nettop is not authorized on netts01, retrying in 5 seconds...
	sleep 5
	HTTPSTATUS=`wget --server-response -qO- http://$URL_SERVER 2>&1 | grep "HTTP/" | tail -1 | awk '{print $2}'`
done

INCOGNITO=$(wget -qO- http://$URL_SERVER/\?nonincognito=true) # get incognito flag for chromium

URLLIST=`wget -qO- http://$URL_SERVER`
if [ '$URLLIST' != "" ]
then
    chromium-browser $URLLIST $INCOGNITO --start-fullscreen --disable-infobars --noerrdialogs --start-maximized --disable-breakpad > /dev/null 2>&1 &
else
    echo Failed to get URL list. Something is wrong, we are not launching Chromium...
    exit
fi

RESTARTDATE=$(wget -qO- http://$URL_SERVER/\?restarttime=true)
sleep 20

echo This nettop will restart at $RESTARTDATE

SCHEDULED_RESTART=false
while [ true ]
do
    if [ $SCHEDULED_RESTART = false ]
    then
        CURDATE=`date '+%H:%M:%S'`
        #echo "$CURDATE $RESTARTDATE"
        if [ $CURDATE = $RESTARTDATE ]
        then
            SCHEDULED_RESTART=true
            echo "Rebooting system in 30 seconds..."
            killall -2 chromium-browser
            sleep 30
            reboot
        fi
    fi
done