#!/bin/sh

# a simple script to download content of OA-Repositories into the deposit_storage if direct 
# access via OAI Harvest Job is not successful due to limitations of Rosetta Harvesting facilities

oaipath="/ingest_storage/oai_harvests/hbz/"
depositpath="/deposit_storage/source_file_streams/hssrub/"

find /ingest_storage/oai_harvests/hbz/ -name dc.xml -printf "%p\n" | while read -r fname; 
do 
     grep '<dc:source>' $fname >> ~/dc_source.txt ;
done;
sed -e 's/<dc:source>\|<\/dc:source>//g' ~/dc_source.txt > ~/urls.txt;
cd $depositpath;
pwd;
wget --no-check-certificate -x -i ~/urls.txt;
rm ~/dc_source.txt; rm ~/urls.txt;
cd ~/;
