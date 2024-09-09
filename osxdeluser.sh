#!/bin/bash
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
##################################################
MLEN=50
DUSER=""
DELFLAG=0
RITNOW=$(date "+%b-%d-%Y %H:%M")
LOGDIR="/var/root"
PF1="%-45s%-10s\n" # printf format 1
C50="##################################################"
#################################################
function txtcenter () {
  # this will center text on screen example:  txtcenter "#" "I was here"
  count=1
  slen=${MLEN}
  sstr=$2
  sfill=$1
  c_width=$(( (${slen} - ( ${#sstr} + 2) ) / 2 ))
  while [ ${count} -le ${c_width} ]
  do
      echo -n ${sfill}
      (( count++ ))
  done
  echo -n " ${sstr} "
  ccnt=$(( ${count} + ( ${#sstr} + 2)))
  while [ ${ccnt} -le ${slen} ]
  do
    echo -n "${sfill}"
    (( ccnt++ ))
  done
  echo ""
}
##################################################
function backupuser () {
 DELNAME=$1
 if [[ -d "/Users/${DELNAME}" ]]; then
    echo "${C50}"
    sudo rsync -av "/Users/${DELNAME}" "/var/root/${DELNAME}.DELETED"
    if [[ -d "/var/root/${DELNAME}.DELETED" ]]; then
      printf ${PF1} "${DELNAME} Backed up. /var/root/ " "[OK]"
      printf ${PF1} "${DElNAME} Backed up. /var/root/ " "[OK]" >> "${LOGDIR}/provision.log"
    fi
 else
    printf ${PF1} "${DELNAME} Backed up. /var/root/ " "[FAIL]"
    printf ${PF1} "${DELNAME} Backed up. /var/root/ " "[FAIL]" >>  "${LOGDIR}/provision.log"
 fi
  echo "${C50}"
}
##################################################
function chkdel () {
  if [[ -z ${1} ]]; then echo "HELP [$0 -u UserName -d delete or [$0] "; exit ; fi
  urm=$( echo $1 |tr "[:upper:]" "[:lower:]"  )
  case $urm in
	delete ) DELFLAG=1
        ;;
	del )    DELFLAG=1
        ;;
	* )
              echo "${C50}"
	      printf ${PF1} "Invalid response should be [delete|del]" "[FAIL]"
	      echo  "HELP [$0 -u UserName -d delete  or [$0] "
              echo "${C50}"
	      exit 1;
	;;
  esac
}
##################################################
function deprovisionuser ()
{
  if [[ ${DELFLAG} -gt 0 ]]; then
    backupuser ${DUSER}
    echo "${C50}"
    printf ${PF1} "Running sysadminctl -deleteUser [${DUSER}]"  "[OK]"
    $(sysadminctl -deleteUser "${DUSER}" )
    echo "sysadminctl -deleteUser ${DUSER}  ${RITNOW}" >> "${LOGDIR}/provision.log"
    echo "${C50}"
    if [[ ! -d /Users/${DUSER} && -d /var/root/${DUSER}.DELETED  ]]; then
      printf ${PF1} "Deleted user and user files for [${DUSER}]"  "[PASS]"
      printf ${PF1} "Deleted user and user files for [${DUSER}]"  "[PASS]" >> "${LOGDIR}/provision.log"
    else
      printf ${PF1} "Deleted user and user files for [${DUSER}]"  "[FAIL]"
      printf ${PF1} "Deleted user and user files for [${DUSER}]" "[FAIL]" >> "${LOGDIR}/provision.log"
      exit 1;
    fi
    echo "${C50}"
  else
    printf ${PF1} "Running sysadminctl -deleteUser [${DUSER}]"  "[FAIL]"
    printf ${PF1} "Deleted user and user files for [${DUSER}]" "[FAIL]" >> "${LOGDIR}/provision.log"
    exit 1;
  fi
 }
##################################################
################## MAIN ##########################
##################################################
clear
echo "${C50}"
txtcenter "#"  "SPoC OSX Delete User Script"
while getopts :u:d:h: FLAG; do
       case ${FLAG} in
         u) #  del user-name
               DUSER="${OPTARG}"
         ;;
         d) #  delete
               DCOM="${OPTARG}"
	       chkdel ${DCOM}
         ;;

         h) # somekind of help ;;
               HELPME="${OPTARG}"
               echo "HELP [$0 -u UserName -d delete  or [$0] "
               exit 1
	 ;;
         \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
	 ;;
         :)
            echo "HELP [$0 -u UserName -d delete   or [$0] "
            exit 1
	 ;;
       esac
done
if [ ${HELPME} ]; then exit; fi
if [ -z ${DUSER} ]; then echo "HELP [$0 -u UserName -d delete  or [$0] "; exit ; fi
##################################################
deprovisionuser
