#!/bin/bash



export PATH=/usr/bin:/bin:/usr/sbin:/sbin
USERNAME="mortaluser"
#FULLNAME="Mortal User"
if [[ -d "/Users/${USERNAME}" ]];
 then
 mv "/Users/${USERNAME}" "/Users/${USERNAME}.DELETED"
 rm -f "/Users/${USERNAME}"
fi
sysadminctl -deleteUser "${USERNAME}"
#sysadminctl -addUser "${USERNAME}" -fullName "${FULLNAME}" -password "${PASSWORD}" -hint "${PASSWORDHINT}"




#!/bin/bash
##################################################
MLEN=50
DUPUSER=0
REWTUSER=0
USRNAME=""
NLAST=""
NFULL=""
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
function ckusername () {
  NU=$1
  if [[ -z ${NU} ]] ;   then printf ${PF1} "UserName = Null Exiting.. " "[FAIL]" ;exit ; fi
  USRNAME=$(echo "${NU}" | tr "[:upper:]" "[:lower:]" )
  DUPUSER=$(dscl . -list /Users | grep -c ${USRNAME})
  if [[ ${DUPUSER} -gt 0 ]]; then
     echo "${C50}"
     printf ${PF1} "Duplicate Username [${USRNAME}] exiting..." "[FAIL]" 
     echo "${C50}";exit 1;
  fi 
}
##################################################
function chkrewt () {
  if [[ -z ${1} ]]; then echo "HELP [$0 -u UserName -l LastName -r [ yes|no ] admin  or [$0] "; exit ; fi
  yn=$( echo $1 |tr "[:upper:]" "[:lower:]"  )
  case $yn in 
	yes ) REWTUSER=1
		;;
	no )  REWTUSER=0
		;;
	* ) 
              echo "${C50}"
	      printf ${PF1} "Invalid response should be [yes|no]" "[FAIL]"
	      echo  "HELP [$0 -u UserName -l LastName -r [ yes|no ] admin  or [$0] " 
              echo "${C50}"
	      exit
		;;
  esac
}
##################################################
function deprovisonuser () 
{
  echo "${C50}"
  printf ${PF1} "Running sysadminctl -deleteUser [${USRNAME}]"  "[OK]"
  
     $(sysadminctl -deleteUser "${USRNAME}" )
     echo "sysadminctl -addUser ${USRNAME} -fullName ${NFULL}  ${RITNOW}" >> "${LOGDIR}/provision.log"
     echo "${C50}"
     if [[ ! -d /Users/${USRNAME} ]]; then
       printf ${PF1} "Deleted user and user files for [${USRNAME}]"  "[PASS]"
     fi
       
     echo "${C50}"
  fi
}
##################################################
################## MAIN ##########################
##################################################
clear
echo "${C50}"
txtcenter "#"  "SPoC OSX UserAdd Script"
while getopts :u:l:r:h: FLAG; do
       case ${FLAG} in
         u) #  new user-name 
               NUSE="${OPTARG}"
	       ckusername ${NUSE}
         ;;
         l) #  new last-name
               NLAST="${OPTARG}"
         ;;
         r) #  rewt = [yes|no] 
               REWT="${OPTARG}"
	       chkrewt ${REWT}
         ;;
         h) # somekind of help ;;
               HELPME="${OPTARG}"
               echo "HELP [$0 -u UserName -l LastName -r admin [ yes|no ]   or [$0] "
               exit 1 
	 ;;
         \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1 
	 ;;
         :)
            echo "HELP [$0 -u UserName -l LastName -r admin [ yes|no ]   or [$0] "
            exit 1 
	 ;;
       esac
done
if [ ${HELPME} ]; then exit; fi
if [ -z ${NLAST} ]; then echo "HELP [$0 -u UserName -l LastName -r admin [ yes|no ]   or [$0] "; exit ; fi
##################################################
deprovisionuser
