#! /bin/bash
a=$(cat /proc/loadavg | cut -d ' '  -f1)
b=100
x="$(echo "$a*$b" | bc -l | cut -d '.'  -f1)"
echo $x > /etc/track_nginx_file
