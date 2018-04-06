#!/usr/bin/env bash
exit -
defaultmode="off" #must be any of the given modes. Namely weather, picture or off
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from
readonly STATUS_SUCCESS=0                       # exit status for commands

# Script configuration
readonly CONSTANT="value"

# Script functions
function usage () {
    echo "
Usage: $(basename $0) [option] 
    -h          this usage help text
    weather     start weather display
    picture     start picture display
    off         stop all program and turn off monitor
    info        print status details
    correct     check current mode and fix if out of sync 
    getmode     simply report of current mode

Example:
    $(basename $0) weather 
    "

    exit ${1:-0}
}

function ask_if_empty () {
    local value="$1"
    local default="$2"
    local message="$3"
    local options="$4"  # pass "-s" for passwords
    if [[ -z "$value" ]]; then
        read $options -p "$message [$default] " value
    fi
    value=$(echo ${value:-$default})
    echo "$value"
}

function get_time () {
  tod=`date +%-H%M`
}

function get_status () {
  xrun=`pgrep -x lightdm`
  fbirun=`pgrep -x fbi`
#  chromerun=`pgrep -x chromium-browser`
#  currvt=`sudo fgconsole`
#  tvservice=`tvservice -s`
}

function sleep_mode () {
  tvservice -o
  sudo /etc/init.d/lightdm stop
  sudo pkill -x X
  sudo pkill -x xinit
  sudo pkill -x chromium-browser
  sudo pkill -x fbi
  sudo pkill -x startx
}

function start_mon () {
  tvservice -p #&& fbset -depth 8 && fbset -depth 16
}

function picture_mode () {
 start_mon
 #sudo fbi -T 1 --noverbose -a -u -t 10 `find /home/pi/Projects/pictureframe/media/pics -iname *.jpg`
 sudo fbi -T 1 --noverbose -a -u -t 10 `find /home/pi/Projects/pictureframe/media/pics -iname *.jpg`
 #sudo fbi -T 1 --noverbose -a -u -t 10 `find /home/pi/Projects/pictureframe/media/pics -iname *.jpg -exec echo ' "{}"' \; `
}

function weather_mode () {
  start_mon
  sudo  /etc/init.d/lightdm start
}


function quick_status (){ 
  get_status
  curmode=""
  if [ "$xrun" != "" ] && [ "$fbirun" == "" ] ; then
    curmode=weather
  elif [ "$xrun" == "" ] && [ "$fbirun" != "" ]; then
    curmode=picture
  else
    curmode=off
  fi
  echo $curmode
}

function check_status () {
  if [ "$defaultmode" != "off" ]; then 
    echo detault mode is not set to off.  Assuming and overide and exiting.
    exit 0
  fi 
 
  get_status
  get_time
  curmode=""
  if [ "$xrun" != "" ] && [ "$fbirun" == "" ] ; then
    curmode=weather
  elif [ "$xrun" == "" ] && [ "$fbirun" != "" ]; then
    curmode=picture
  else
    curmode=off
  fi
  echo It is $tod and I am $curmode
  if [ "$tod" -lt 700 ] ; then
     echo I should be off now
     if [ "$curmode" != "off" ];then 
        echo Out of sync.  I need to shut down 
        sleep_mode
     fi    
  elif [ "$tod" -gt "700" ] && [ "$tod" -lt "900" ]; then
     if [ "$curmode" != "weather" ];then 
        I need to weather 
        sleep_mode
        weather_mode
     fi    
  elif [ "$tod" -gt "900" ] && [ "$tod" -lt "1700" ]; then
     if [ "$curmode" != "off" ];then 
        echo I need to shut down 
        sleep_mode
     fi
  elif [ "$tod" -gt "1700" ] && [ "$tod" -lt "2100" ]; then
    echo I should be picture
     if [ "$curmode" != "picture" ];then 
        I need to picture 
        sleep_mode
        picture_mode
     fi    
  elif [ "$tod" -gt "2100" ]; then
     if [ "$curmode" != "off" ];then 
        I need to shut down 
        sleep_mode
     fi    
     
  else
   echo something broke 
  fi
}

# Exit and show help if the command line is empty
[[ ! "$*" ]] && usage 1

case "$1" in
    off)
       echo off 
       sleep_mode
        ;;
    weather)
       echo start weather
       start_mon
       weather_mode
        ;;
    picture)
       echo start picture 
       start_mon
       picture_mode
        ;;
    info)
       get_status 
       echo X is $xrun 
       echo fbi is $fbirun
       echo chromerun is $chromrun
       echo currvt is $currvt
       echo tvservice is $tvservice
        ;;
    correct)
      #check_status
        ;;
    getmode)
      quick_status
        ;;
    *)
        usage 1
        ;;
esac
