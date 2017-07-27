#!/bin/bash

config_file=$1

for i in `cat $config_file | awk -F ' ' '{print $1";"$2";"$3";"$4}'`; do
	name=`echo $i | cut -d ";" -f 1`
	port=`echo $i | cut -d ";" -f 2`
	host=`echo $i | cut -d ";" -f 3`
	image=`echo $i | cut -d ";" -f 4`
	#echo "name = $name, port = $port, host = $host, image = $image"
	./create_redis_container.sh $name $port $host $image
done
