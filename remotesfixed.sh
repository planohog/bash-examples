#!/bin/bash
##############################################################



## ARGS 1=servername
[ -z $1 ] && echo "missing  arg1 exit " && exit
#[ -z $2 ] && echo "missing  arg2 exit " && exit
ARG1=$1
MLEN=60
#ARG2=
##### RUN COMMAND ON REMOVE SERVER ######
#ssh sscadmin@${ARG1}  MHRSID=${HRSID} 'bash -s' <<'ENDSSH'
#ssh sscadmin@${ARG1} 'bash -s' <<'ENDSSH'
ssh tmoore@${ARG1} 'bash -s' <<'ENDSSH'
  # all functions delared between ENDSSH
  sudo -E bash   ## -E keeps environment
  HST=""
  IFSORIG=$IFS
  MLEN=50
C50="##################################################"
  PFMT1="%-30s%-10s%-10s%-10s\n" ## printf format 1
  PFMT2="%-45s%-10s\n"           ## printf format 2
  echo ${C50}
#################################################
function txtcenter () {
  # this will center text on screen example:  textcenter 'terry was here'
  count=1
  slen=${MLEN}
  sstr=$2
  sfill=$1
  c_width=$(( (${slen} - ( ${#sstr} + 2) ) / 2 ))
  while [ ${count} -le ${c_width} ]
  do
      echo -n "${sfill}"
      (( count++ ))
  done
  echo -n " ${sstr} "
  ccnt=$(( ${count} + ( ${#sstr} + 2)))
  while [ ${ccnt} -le ${slen} ]
  do
    echo -n ${sfill}
    (( ccnt++ ))
  done
  echo ""
}
##################################################
   function pushd () {
     command pushd "$@" > /dev/null
   }
   function popd () {
     command popd "$@" > /dev/null
   }
  #################################################
  function sethost () {
    HST=`hostname`
  }
 ##################################################
 function force_rotate () {
   $( logrotate -f /etc/logrotate.conf )
   pushd /var/log
  if [[ $( pwd | grep -c log ) -gt 0  ]] ; then
    $(find . -type f -name "*.gz" -exec rm {} \; )
  fi
   popd
   printf ${PFMT2} "/var/log/ Cleaned" "[OK]"
}
 ##################################################
  function atop_clean () {
    pushd /var/log/atop
    $(find . -name "atop_*" -exec rm  {} \; )
    printf ${PFMT2} "/var/log/atop Cleaned" "[OK]"
    popd
}
#################################################
  function  spoc_admin_clean () {
    pushd /home/app/spoc_admin_utils/AutoSync/LogArchive
    if [[ $( pwd | grep -c LogArchive) -gt 0 ]]; then
      $(find . -name "*.gz"  -name "*.log" -exec  rm  {} \; )
    fi
    printf ${PFMT2} "/home/app/spoc_admin_utils Cleaned" "[OK]"
}
#################################################
  function  showdirsize () {
  txtcenter "#" "DiskSpace $HST"
   for y in root admin/pluto tmp var/log home; do
#   echo "y=[$y]"
   du -sh "/${y}"
   done
}


 ##################################################
  sethost
  txtcenter "#" "${HST}"
  printf ${PFMT2} "Connecting to ${HST}"  "[OK]"
  force_rotate
  atop_clean
#  spoc_admin_clean
  showdirsize
  #echo ${C50}
  txtcenter "#" "Test Complete ${HST}"
ENDSSH
