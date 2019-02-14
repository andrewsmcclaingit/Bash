#!/bin/bash
#------------------------------------------------------------------
#  Script               :  logfilecheck.sh
#  Author               :  Andrew McClain
#  Date                 :  Feb/14/2019
#  Description          :  This script checks if the log size is
#                          healthy.
#  Modified             :
#------------------------------------------------------------------

#Debug mode on
set -x

#Import
. /home/mbztlpk/env

#Date
date=$(date "+%Y%m%d%H%M%S")

#Directories
logDir=/home/mbztlpk/logs
logFile=${logDir}/filesizecheck_${date}.log

#Log file name/location
#Getting size of log file
filename=testfile.txt
filesize=$(stat -c%s "$filename")

#recreate log file
echo "$date - File Size Health Check has started" > $logFile

function log_msg
{
    echo "$date - $1" >> $logFile
}

log_msg "Size of $filename = $filesize bytes."

#If log file size is greater than 0
if [ $filesize -gt 0 ]; then
   log_msg "Log size is normal."
   echo "Log Size Normal" | mailx -s "All Clear" -r $HOSTNAME@blank.com $OPS_EMAIL_LIST
   exit 0
else
   log_msg "Log size is not normal, please investigate."
   echo "Log Size Not Normal" | mailx -s "Remediation Required" -r $HOSTNAME@blank.com $OPS_EMAIL_LIST
   exit 1
fi

#Debug mode off
set +x
