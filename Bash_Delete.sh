#!/bin/bash

#declaring date
#declaring log location
#declaring log file name and .ext
#declaring location of files to delete, includes subfolders
#declaring how old the files have to be (+90 = older than 90 days of current date)
#-mtime for last modified | -atime for last accessed
currentDate=`date "+%b-%d-%Y %H:%M:%S"`
logLocation="/home/zammad/Documents/logs/"
logFile="outputlog.log"
fileLocation="/home/zammad/Documents/Junk/"
daysOld="-mtime +90"

#'-f' checks if file exists
#if log file exists print date and continue script
#if log file does not exist, create it with 'touch'
#'echo -e' allowed the new line \n format
cd $logLocation   
if [ -f $logFile ]  
then   
	echo -e "\n$currentDate " >> $logFile
	echo "----------------------------" >> $logFile
else        
	touch $logFile   
	echo "$currentDate" >> $logFile
	echo "----------------------------" >> $logFile
fi

#find files and store in filesToLog variable
#$fileLocation location of files to delete, declared above
#'-type f' means files only not folders
#$daysOld declares how old the files have to be, declared above
filesToLog=$(find $fileLocation -type f $daysOld)

#'-z' check and see if the variable is empty. checks length of string
#if $filesToLog is empty, write to log and exit script
#if $filesToLog is not empty, write filenames/paths to log and continue script
#get a count with '| wc -l' of how many files found
#while IFS.. (Internal Field Separator) defining filename boundary and whitespaces
if [ -z "$filesToLog" ]
then
	echo "No Files were old enough to delete" >> $logFile
	exit 0
else
	totalFiles=$(echo "$filesToLog" | wc -l)
	echo "Number of files found: ${totalFiles}" >> $logFile
	echo "$filesToLog" >> $logFile
	find $fileLocation -type f $daysOld -print0 | while IFS= read -r -d '' file;
	do
	rm "$file"
	done
fi

#finding files again
filesDeletedCheck=$(find /home/zammad/Documents/Junk/ -type f $daysOld)

#output whether the files still exist or have been deleted
if [ -z "$filesDeletedCheck" ]
then
	echo "All Files Deleted Successfully" >> $logFile
	exit 0
else
	echo "Not all files deleted, see below.." >> $logFile
	echo "$filesDeletedCheck" >> $logFile
	exit 1
fi
