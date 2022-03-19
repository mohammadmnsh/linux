#!/bin/bash
#######################################################################################
#Script Name    : export_mysql_db.sh
#Description    : export db with replica information "with progress bar"
#Args           : none
#cron           : none
#log            : none
#version        : V1
#Related Script : mysql_db_size.sh
#Author         : mshaaban
#editor         : mshaaban
#lastedit       : 15-03-2022
#Email          : mohammad.mnsh@gmail.com
#License        : GNU GPL-3
#######################################################################################

set -o pipefail -o errexit

databases="x y z"
db_size=$(mysql_db_size.sh $databases)
export_name=db.sql.gz
user=root
password=password

trap 'rm -rf "$export_name" "postion.txt" && mysql -u$user -p$password --execute="SET GLOBAL read_only = 0; UNLOCK TABLES;start slave;"' ERR INT TERM HUP SIGINT

mysql -u"$user" -p"$password" --execute='stop slave; FLUSH TABLES WITH READ LOCK; SET GLOBAL read_only = 1; SHOW MASTER STATUS; ' >> postion.txt
        mysqldump -u$user -p$password --databases $databases --hex-blob | pv --size $db_size | gzip  > $export_name
mysql -u"$user" -p"$password" --execute='SET GLOBAL read_only = 0; UNLOCK TABLES;start slave;'

