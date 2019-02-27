#!/bin/bash
#------------------------------------------------------------------
#  Script               :  hcsevlogs_to_business.sh
#  Author               :  Andrew McClain
#  Date                 :  Feb/07/2019
#  Description          :  This script zips the hc logs, lists if
#                          SEVS 1's and 2's are present and emails it
#                          all to the business
#  Modified             :
#------------------------------------------------------------------

#Debug mode on
set -x

#
. /home/mbztlpk/env

#Country/Region
#Date
country="Mexico Mercia"
date="`date +%B\ %Y`"

#Health Check log paths
filename1="hc1.txt"
filename2="hc2.txt"
filename3="hc3.txt"
filename4="hc4.txt"

#Count the number of SEV 1's and 2's in the four Health Checks
howmany1=`cat $filename1 $filename2 $filename3 $filename4 | grep -ci "rerun fitdlm"`
howmany2=`cat $filename1 $filename2 $filename3 $filename4 | grep -ci "the introduction date is incorrect\|discontinuation"`

#Determining output for email body
if [ $howmany1 -gt 0 ] && [ $howmany2 -gt 0 ]
then
 howmanya="Present"
 howmanyb="Present"
elif [ $howmany1 -eq 0 ] && [ $howmany2 -gt 0 ]
then
 howmanya="None"
 howmanyb="Present"
elif [ $howmany1 -gt 0 ] && [ $howmany2 -eq 0 ]
then
 howmanya="Present"
 howmanyb="None"
else
 howmanya="None"
 howmanyb="None"
fi

#Zip the four Health Check logs
zip -r9 hclogs.zip $filename1 $filename2 $filename3 $filename4

#Mail tool - Attach zip file, prepare subject/body and send
mailx -a hclogs.zip -s "$country $date Month-End Health Check" -r $HOSTNAME@gm.com $OPS_EMAIL_LIST <<< $( echo -e "$country $date Month end Health Check\r\rSeverity 1 Errors: $howmanya\rSeverity 2 Errors: $howmanyb\r\rSee logs attached.")

#Debug mode off
set +x
