#!/bin/bash
#################################################
# Automated testing of puppetserver puppet7 full system.
# function ChkPuppetVer()
# function ChkPuppet7Return()
PUPVER="7."      # verify server version 7.*
PUPRETURN1="0"   # verify puppet agent -t rtn = 0
PUPRETURN2="2"   # verify puppet agent -t rtn = 2
HEADERTXT="Puppet-7 Auto Verification Test"
#################################################
ME=$0                                   ## script name
LOG_FILE="/tmp/$(basename "${ME}").log" ## logfile
rm -f "${LOG_FILE}"
PF1="%-50s%-10s\n"                      # printf format 1
#################################################
function ChkPuppetVer() {
  TASK="Check-Puppet-Ver-Test"
  if $( puppetserver --version | grep "ion: ${PUPVER}" >/dev/null ); then
     printf "${PF1}" "${TASK}" "[PASS]" | tee -a "${LOG_FILE}"
  else
     printf "${PF1}" "${TASK}" "[FAIL]" | tee -a "${LOG_FILE}"
  fi
}
#################################################
function ChkPuppetReturn() {
  TASK="Check-Puppet-Agent-Return"
  PUPRTN=$( puppet agent -t > /dev/null 2>&1 ; echo "$?" )
  if [[ "${PUPRTN}" == "${PUPRETURN1}"  || "${PUPRTN}" == "${PUPRETURN2}" ]]; then
     printf "${PF1}" "${TASK}" "[PASS]" | tee -a "${LOG_FILE}"
  else
     printf "${PF1}" "${TASK}" "[FAIL]" | tee -a "${LOG_FILE}"
  fi
}
#################################################
# functions below this line are pretty printing
# details and not often changed.
#################################################
function Timenow () {
  TNOW=$(date "+%b-%d-%Y %H:%M")
}
#################################################
function Footer() {
  # ex: Footer "-" "your text is here"
  CH=$1
  DESC=$2
  txtcenter "${CH}" "${DESC}" | tee -a "${LOG_FILE}"
}
#################################################
function Header() {
  # ex: Header "-" "your text is here"
  CH=$1
  DESC=$2
  echo "" | tee -a "${LOG_FILE}"
  txtcenter "${CH}" "${DESC}" | tee -a "${LOG_FILE}"
}
#################################################
function txtcenter () {
  # this will center text on screen example:  txtcenter  "nasa was here"
  # this will center text  will filler of -  example:  txtcenter "-" "nasa was here"
  # slen is total characters accros screen you want to use
  count=1
  slen=54                           # total printing page width in characters.
  sstr=$2                           # actual string to print.
  sfill=$1                          # fill charater for remaining printed area
  c_width=$(( (slen - ( ${#sstr} + 2) ) / 2 ))
  while [ "${count}" -le "${c_width}" ]
  do
      echo -n "${sfill}"
      (( count++ ))
  done
  echo -n " ${sstr} "
  ccnt=$(( count + ( ${#sstr} + 2)))
  while [ "${ccnt}" -le "${slen}" ]
  do
    echo -n "${sfill}"
    (( ccnt++ ))
  done
  echo ""
}
##################################################
# Function to output to console and log file simultaneously.
# No new line by default, add newline character when calling function
function log() {
  DESC=$1
  printf "${PF1}" "${DESC}" | tee -a "${LOG_FILE}"
}
##################################################
################## MAIN ##########################
Timenow
Header "-" "${HEADERTXT}"
ChkPuppetVer
ChkPuppetReturn
Footer "-" "${ME} Completed ${TNOW}"

#
