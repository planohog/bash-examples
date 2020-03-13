#!/bin/bash
#
checklist='ad01 ad02 aso-t2ar cm02 dhcp01 dhcp02 dmc dns01 dtngw-pl ecostress file-pl fit hv1 hv2 hv3 hv4 hv5 if01 log01 ls1 ntp01 opsserver ssc-pluto sscnas1 sqs01'
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)
TIMEOUT=2
##################################################
function NtpTest() {
  NTPSEC=$(ntpdate -qu -p 1 ntp01 | grep sec | rev | awk '{print $2}' | rev)
  printf "%15s %6s    \n"\
          "NTP01 SEC" "[${NTPSEC}]"
  NTPSYN=$(timedatectl | grep synchronized | awk '{print $3}' | sed 's/ //g')
  printf "%15s %6s    \n"\
          "NTP01 SYN" "[${NTPSYN}]"
}
##################################################

while sleep 2; do
  clear
  tput cup 0 0
  for i in $checklist
    do
      $(ping -c 1 -w ${TIMEOUT} ${i} > /dev/null) ;
       if [ $? -eq 0 ] ; then
          printf "%15s %6s    \n" \
          "$i" "${GREEN}[OK]${NC}"
       else
          printf "%15s %6s    \n" \
          "$i" "$i${RED}[FAIL]${NC}"
       fi
    done
    NtpTest
done

