#!/bin/bash
#######################################################################################
#Script Name    : mysql_db_size.sh
#Description    : get db size for dump Bar
#Args           : DB Name
#cron           : None
#Logs           : None
#version        : V1
#Related Script : None
#Author         : mshaaban
#editor         : mshaaban
#lastedit       : 15/03/2022
#Email          : mohammad.mnsh@gmail.com
#License        : GNU GPL-3
#######################################################################################

sum=0

size () {
database=$1
db_size=$(mysql -uUser -pPassword \
     --silent \
     --skip-column-names \
     -e "SELECT ROUND(SUM(data_length) * 1.3) AS \"size_bytes\" \
     FROM information_schema.TABLES \
     WHERE table_schema='$database';"
)
size=$(numfmt --to=iec-i --suffix=B "$db_size")
echo $db_size
}

DBs="$*"
nDB="$(echo "$DBs" | awk -F' ' '{print NF; exit}')"
for (( n=(+1); n<=$nDB; n++ ))
do
	DB="$(echo $DBs | awk -v var="$n"  '{print $var}')"
	sum=`expr $sum + $(size $DB)`
done

echo $sum
