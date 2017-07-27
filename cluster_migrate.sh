#!/bin/bash

source_node=$1
target_node=$2

start_slot=$3
end_slot=$4

src_host=`docker inspect $source_node | grep HostIp | cut -d ":" -f 2 | \
	cut -d '"' -f 2`
src_port=`docker inspect $source_node | grep HostPort | cut -d ":" -f 2 | \
	cut -d '"' -f 2`

tar_host=`docker inspect $target_node | grep HostIp | cut -d ":" -f 2 | \
	cut -d '"' -f 2`
tar_port=`docker inspect $target_node | grep HostPort | cut -d ":" -f 2 | \
	cut -d '"' -f 2`

src_node_id=`docker exec $source_node cat /data/nodes.conf | grep myself | \
	cut -d " " -f 1`
tar_node_id=`docker exec $target_node cat /data/nodes.conf | grep myself | \
	cut -d " " -f 1`

docker exec $source_node bash /redis-cluster/cluster_migrate_in_container.sh \
	$start_slot $end_slot $src_node_id $tar_node_id $src_host $src_port \
	$tar_host $tar_port
