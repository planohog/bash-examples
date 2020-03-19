root@attbackup1:/root/bin# cat checkallserversforthis.sh
#!/bin/bash
#################################################
####### HRsmart Check All for this service  #####
#################################################
DBH="192.168.2.135"      ## database host  nms.hrsmart.com
DBU="server_record"      ## db username
DBP="server_record"      ## db passwd
DB="server_record"       ## db name
INPASSWD=0               ## is it in etc passwd  0 or 1
MLEN=50                  ## 50 char limit on output
UFAIL=0                  ##
SERVERLIST=""            ## hold list of servers from database
TICKETFLAG="NONE"        ## status for command line input
USERFLAG="NONE"          ## status for command line input
##JOBSCRIPT="/root/bin/findmongodb.sh"  ## script to send to each server and run
#JOBSCRIPT="/root/bin/findsysstat.sh"
#JOBSCRIPT="/root/bin/finddhcp.sh"
[ -z $1 ] && echo " fail need 1st arg to be script in /root/bin/ " && exit
tmprewt=$(cat /root/bin/.nothingofcon | tr -d "\n")
JOBSCRIPT=$1
#echo "JOBSCRIPT=[$JOBSCRIPT]"
##JOBSCRIPT="/root/bin/rewt.sh"
#JOBSCRIPT="/root/bin/findgeographic.sh"
#JOBSCRIPT="XX /root/bin/psaux.sh"
#echo "JOBSCRIPT=$JOBSCRIPT"
################ Function Description ############
##################################################
## fillserverlist: fills SERVERLIST with us servernames from db
## writechar: pretty print used writechar "50" "#"
## txtcenter: pretty print, txtcenter  "#" "${TNOW} ${TICKET}"
##
##
##
##
################# FUNCTIONS #####################
##################################################
function fillserverlist () {
#SERVERLIST=`mysql -h ${DBH} -u ${DBU} -p${DBP} ${DB} -N -e "select server_hostname from server where server_locale LIKE '%' and active =
##SERVERLIST=`mysql -h ${DBH} -u ${DBU} -p${DBP} ${DB} -N -e "select server_hostname from server where server_locale ='us' and active = '1' ORDER BY server_hostname"  | grep -v attbackup1  | grep -v apple |  grep -v hubbard | grep -v nutria`
SERVERLIST=`mysql -h ${DBH} -u ${DBU} -p${DBP} ${DB} -N -e "SELECT hostname FROM servers join regions using (region_id) WHERE active='1' and region='us' " `

}
##################################################
function writechar () {
[ -z $1 ] &&  [ -z $2 ] && echo " 1st arg count 2arg chacter   exit " && exit
count=1
while [ $count -le $1 ]
do
  echo -n $2
  (( count++ ))
done
echo "" ; }
##################################################
##################################################
function txtcenter () {
# tcent 50 "this is a huge test 0123456789"
# tcent "#" "this is a huge test 0123456789"
count=1
slen=$MLEN
sstr=$2
sfill=$1
c_width=$(( ($slen - ( ${#sstr} + 2) ) / 2 ))
while [ $count -le $c_width ]
do
  echo -n $sfill
  (( count++ ))
done
echo -n " $sstr "
ccnt=$(( $count + ( ${#sstr} + 2)))
while [ $ccnt -le $slen ]
do
  echo -n "#"
  (( ccnt++ ))
done
echo ""
}
##################################################
#
fillserverlist
for i in ${SERVERLIST}
do
   #  echo  -n "$i "
     ssh root@${i} 'bash -s' < ${JOBSCRIPT} ${tmprewt}
done

