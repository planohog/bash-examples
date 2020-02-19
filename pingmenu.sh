#!/bin/bash
checklist='www.google.com www.yahoo.com www.apple.com'
while sleep 2; do
  clear
  tput cup 0 0
  for i in $checklist
    do
       ping -c 1 $i > /dev/null ;
       if [ $? -eq 0 ] ; then
          printf "%15s %6s    \n" \
          "$i" "[OK]"
       else
          "$i" "[FAIL]"
       fi
    done
done


