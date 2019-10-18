#!/bin/bash
##################################################
##################################################
# Git repository , move branch to merged_branch and
# clean up
# Oct 18 2019
##################################################
[ -z $1 ] && echo " Need first arg as your branch name .." && exit
MYBRANCH=$1
CURRENT_RELEASE="queso"
CURRENT_BRANCH=""
##################################################
function set_key () {
        ISKEY=$( ps -p $SSH_AGENT_PID | grep -c "agent" )
        echo "ISKEY=[$ISKEY]"
        if [ ${ISKEY} -lt 1 ] ; then
           eval `ssh-agent -s`
           ssh-add ~/.ssh/id_rsa
        fi
}
##################################################
function checkout_release () {
 TMP=$(git checkout release-${CURRENT_RELEASE})
}
##################################################
function getcurrent_branch () {
 CURRENT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
 echo "Current Branch ${CURRENT_BRANCH}"
}
##################################################
function move_branch () {
  echo "MYBRANCH=[$MYBRANCH]"
  [ ${MYBRANCH} == "master" ] && echo "Can not use master as branch name " && exit
  [ ${MYBRANCH} == "release-${CURRENT_RELEASE}" ] && echo "Can not use release-${CURRENT_RELEASE} as branch name " && exit
  ISMERGED=$( git branch | grep -c "merged_${MYBRANCH}" )
  ISBRANCH=$( git branch | grep -c "${MYBRANCH}" )
  [ ${ISMERGED}  -gt 0 ] && echo "Branch Already in Merged status  merged_${MYBRANCH}" && exit
  [ ${ISBRANCH}  -lt 1 ] && echo "Branch not detected ${MYBRANCH} Did you pull ??" && exit
  echo "Moving ${MYBRANCH} to merged_${MYBRANCH} ..."
  TMPMV=$( git push origin ${MYBRANCH}:merged_${MYBRANCH} )
  echo "Clearing ${MYBRANCH} ..."
  TMPRM=$( git push origin :${MYBRANCH} )
}
##################################################
 set_key
 checkout_release
 getcurrent_branch
 move_branch
##################################################
