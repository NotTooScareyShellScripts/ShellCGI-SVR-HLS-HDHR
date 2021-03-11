#!/bin/bash
#
#simple script that uses ffprobe
#to test hdhr tuner channel list previously downloaded 
#as $CHANNELS using curl/xmlstarlet


#depends on ffprobe
which ffprobe >/dev/null
FFPRETVAL=$?
if [ $FFPRETVAL -ne '0' ];then
	echo "Missing ffprobe or not in PATH."
	echo "exiting with error!"
	exit 1
fi


#replace HDHR_IP/HDHR_TUNER with your values
HDHR_IP="192.168.168.2"
HDHR_TUNER="tuner1"

#location of channels.txt file previously downloaded/parsed 
CHANNELS=/var/www/html/channels.txt

#where we store the err/good channels seperate
ERRCHANNELS=/var/www/html/err.channels.txt
GOODCHANNELS=/var/www/html/good.channels.txt

#clear

#check if main channel file found or exit
if [ -s $CHANNELS ];then
	printf "\n${#CHANNELS} CHANNELS:\n found in $CHANNELS\n\n"
	printf "$(<$CHANNELS)\n\n"
else
	printf "No Channels file($CHANNELS)found.\nExiting with error.\n"
	exit 1
fi


#check for channel lists and recreate new
if [ -e $GOODCHANNELS ];then
	echo "Removing old CHANNEL lists and recreating"
	rm -rfv $GOODCHANNELS
	touch $GOODCHANNELS
	printf "\n"
elif [ -e $ERRCHANNELS ];then
	echo "Removing old $ERRCHANNELS list"
	rm -rfv $ERRCHANNELS
	touch $ERRCHANNELS
	printf "\n\n"

elif [ ! -e $ERRCHANNELS||$GOODCHANNELS ];then
	echo "No existing Channel lists, creating new"
	touch $ERRCHANNELS
	touch $GOODCHANNELS

else	
	echo "Error finding/reading $CHANNELS"
	exit 1

fi


for testchannel in $(cat $CHANNELS);do 
	printf "Checking channel $testchannel for good return value.\n"
	ffprobe -v error "http://$HDHR_IP:5004/$HDHR_TUNER/v$testchannel"
	TCRETVAL1=$?
	if [ $TCRETVAL1 -eq '0' ];then
			printf "\t$testchannel evaluated as $TCRETVAL1\n\n"
			echo $testchannel >> $GOODCHANNELS 
	else
			printf "\t$testchannel evaluated as $TCRETVAL1\n\n\n"
			echo $testchannel >> $ERRCHANNELS
	fi
done



printf  "Your good channels:\n $(<$GOODCHANNELS)\n are stored at: $GOODCHANNELS\n\n"
printf  "Your ERRORED channels:\n $(<$ERRCHANNELS)\n are stored at: $ERRCHANNELS\n\n"



