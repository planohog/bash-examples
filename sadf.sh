#!/bin/bash

# Script Input

# run "sadf |head" and comment out according with the output:


# for Debian, Ubuntu
# Output looks like this: debian  60      2014-06-12 22:01:01 UTC all     %%user  0.40
# enable this command:
#
# Debian Squeeze matches the RedHat output
#
# squeeze-host       599     1368396601      all     %user   0.03
#
LC_ALL=C sadf -t -s $(date -d "2 min ago" +%H:%M:%S) -- -bBdqrRSuwW -n DEV -n EDEV -n IP -n EIP -n ICMP -n EICMP -n TCP -n ETCP -n UDP | awk '{print $3 " host=\""$1 "\" interval=" $2 " device=\"" $4 "\" param=\"" $5 "\" value=\"" $6 "\""}'

# Debian Jessie output
#
# jessie-host 60      2014-06-12 22:01:01 UTC all     %%user  0.40
# 
# LC_ALL=C sadf -t -s $(date -d "2 min ago" +%H:%M:%S) -- -bBdqrRSuwW -n DEV -n EDEV -n IP -n EIP -n ICMP -n EICMP -n TCP -n ETCP -n UDP |awk '{print $3,$4 " host=\""$1 "\" interval=" $2 " device=\"" $5 "\" param=\"" $6 "\" value=\"" $7 "\""}' 

# RedHat, CentOS
# Output looks like this: centos       599     1368396601      all     %user   0.03
# enable this command:
#LC_ALL=C sadf -t -s $(date -d "2 min ago" +%H:%M:%S) -- -bBdqrRSuwW -n DEV -n EDEV -n IP -n EIP -n ICMP -n EICMP -n TCP -n ETCP -n UDP | awk '{print $3, "host=\""$1 "\" interval=" $2 " device=\"" $4 "\" param=\"" $5 "\" value=\"" $6 "\""}' 

# Old Sysstat version (7.x)
# enable this command:
#LC_ALL=C sadf -s $(date -d "2 min ago" +%H:%M:%S) -- -bBdqrRuwW -n DEV -n EDEV | awk '{print $3, "host=\""$1 "\" interval=" $2 " device=\"" $4 "\" param=\"" $5 "\" value=\"" $6 "\""}' 
#[ /opt/splunkforwarder/bin/scripts ]:

