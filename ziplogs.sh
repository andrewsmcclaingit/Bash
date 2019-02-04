#!/bin/bash

filename1="hc1.txt"
filename2="hc2.txt"
string="test"
if grep -q "$string" $filename1 || grep -q "$string" $filename2;
#if grep -q "$string" $filename1 && grep -q "$string" $filename2;
#if grep -q "$string" $filename;
then
    echo "String was found"
    echo "archival compressing has begun"
    zip -r9 hclogs.zip $filename1 $filename2
   #GZIP=-9  tar -cf hclogs.tar.gz zip.sh
else
    echo "nono"
fi
