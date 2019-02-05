#!/bin/bash                                                                                                                                                                                       
                                                                                                                                                                                                  
filename1="hc1.txt"                                                                                                                                                                               
filename2="hc2.txt"                                                                                                                                                                               
string="test"                                                                                                                                                                                     
logfile=ziplogscript.log                                                                                                                                                                          
                                                                                                                                                                                                  
echo $'\n' >> $logfile                                                                                                                                                                            
echo "`date \"+%Y/%m/%d %H:%M:%S\"` - HC Zip Script Started" >> $logfile                                                                                                                          
echo "Looking for '$string' in hc logs" >> $logfile                                                                                                                                               
                                                                                                                                                                                                  
if grep -q "$string" $filename1 || grep -q "$string" $filename2;                                                                                                                                  
then                                                                                                                                                                                              
   echo "String '$string' was found" >> $logfile                                                                                                                                                  
   echo "Compressing HC logs into hclogs.zip for email" >> $logfile                                                                                                                               
   zip -r9 hclogs.zip $filename1 $filename2                                                                                                                                                       
else                                                                                                                                                                                              
   echo "String '$string' was not found, exiting program" >> $logfile                                                                                                                             
fi
