#!/bin/bash
#/usr/bin/lxterminal &
/usr/bin/chromium-browser -chrome-frame --window-size=960,1200 --window-position=1,1 --app="http://news.google.com" --app-shell-host-windows-bounds &
/usr/bin/chromium-browser --temp-profile --window-size=960,1200 --window-position=961,1 --app="http://www.wunderground.com/cgi-bin/findweather/getForecast?query=pws:KWASEATT419" --app-shell-host-windows-bound 
