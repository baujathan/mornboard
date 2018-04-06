#!/bin/bash
mediapath=/home/pi/Projects/pictureframe/media/pics


find $mediapath -iname *.CR2 | while read line 
do 
  mode=`/home/pi/Projects/weathercaldisplay/controler.sh getmode`  
  if [ "$mode" == "off" ]; then
   convert -quality 70 "$line" "$line.jpg"
   mv "$line" "$line.converted"
  else 
    echo whoops I shouldn\'t be on.. buh bye
    exit 0
  fi
done 
  


