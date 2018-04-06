#!/bin/bash
mediapath=/home/pi/Projects/pictureframe/media/pics


find $mediapath -iname *.jpg | while read line 
do 
  mode=`/home/pi/Projects/weathercaldisplay/controler.sh getmode`  
  if [ "$mode" == "off" ]; then
  mogrify -auto-orient "$line"
  else 
    echo whoops I shouldn\'t be on.. buh bye
    exit 0
  fi
done 
  

