#!/bin/bash

# Script to output df information to pass to Splunk
#
# Copy this script to $SPLUNK_HOME/bin/scripts and then 
# add the following to inputs.conf to enable.
# 
# [script://$SPLUNK_HOME/bin/scripts/splunk-df.sh]
# disabled = 0
# interval = 60
# index = [YOUR_INDEX_HERE]
#
# Ensure the script is executable and that it is owned by the
# splunk user
#
# chmod 770 splunk-df.sh
# chown splunk:splunk splunk-df.sh
#
#
# This script was tested on Debian Jessie.  YMMV
#

LC_ALL=C df | egrep -v "Filesystem|tmpfs|udev" | awk -v date="$(date +%Y-%m-%d\ %H:%M:%S)" -v hostname="$(hostname)" '{print date " host=\""hostname "\" device=\""$1 "\" mountpoint=\""$6 "\" size_KB=\""$2 "\" used_KB=\""$3 "\" available_KB=\""$4 "\" used_percent=\""$5 "\""}'

