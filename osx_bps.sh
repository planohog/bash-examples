#!/usr/bin/env bash

 # Defs
 iface_name="en0"
 iface_Mbps=1000
 ritnow=$(date "+%m-%d-%Y_%H:%M")
 host_name=$(hostname)
 cachedatadir="/Applications/SplunkForwarder/var/log/splunk"
 # Get boot time, clean up output to something useful
 boottime=`sysctl kern.boottime | sed 's/,//g' | awk '{print $5}'`
 up_time=$(system_profiler SPSoftwareDataType -detailLevel mini | grep Time | awk -F":" '{print $2}')
 # Determine interface activity
 in_bytes=`netstat -I $iface_name -b | tail -1 | awk '{print $7}'`
 out_bytes=`netstat -I $iface_name -b | tail -1 | awk '{print $10}'`
 in_bits=$(($in_bytes * 8))
 out_bits=$(($out_bytes * 8))
 in_mbits=$(($in_bytes / 1000))
 out_mbits=$(($out_bytes / 1000))

 # Get the current time
 currenttime=`date +%s`

 # Determine total uptime
 upt=$(($currenttime - $boottime))
 upd=$( echo "scale=2; ${upt} / 1440 " | bc )
 # Gather bandwith stats in bps
 in_band_bps=$(($in_bits / $upt))
 out_band_bps=$(($out_bits / $upt))
 in_band_mbps=$(echo "scale=5; $in_band_bps / 1000000" | bc)
 out_band_mbps=$(echo "scale=5; $out_band_bps / 1000000" | bc)

 iface_in_util=$(echo "scale=5; $in_band_mbps / $iface_Mbps" | bc)
 iface_out_util=$(echo "scale=5; $out_band_mbps / $iface_Mbps" | bc)
# echo "${host_name} IN=${in_band_bps} OUT=${out_band_bps}"
 echo "Host ${host_name} Time ${ritnow} UpTime ${up_time} INBPS ${in_band_bps} OUTBPS ${out_band_bps}" >> "${cachedatadir}/networking.log"
 echo "Host ${host_name} Time ${ritnow} UpTime ${up_time} INBPS ${in_band_bps} OUTBPS ${out_band_bps}"
# printf "$iface_name averge inbound bits/s: $in_band_bps\n"
# printf "$iface_name averge outbound bits/s: $out_band_bps\n"
# printf "$iface_name averge inbound mbits/s: $in_band_mbps\n"
# printf "$iface_name averge outbound mbits/s: $out_band_mbps\n"
# printf "$iface_name average inbound utilization: $iface_in_util\n"
# printf "$iface_name average outbound utilization: $iface_out_util\n"
