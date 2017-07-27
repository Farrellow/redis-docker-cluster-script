#!/bin/bash

# 为节点批量分配哈希槽

node_name=$1   # 节点容器名
start_slot=$2  # 起始哈希槽编号
end_slot=$3    # 结束哈希槽编号

node_host=`docker inspect $node_name | grep HostIp | cut -d ":" -f 2 | \
	cut -d '"' -f 2`
node_port=`docker inspect $node_name | grep HostPort | cut -d ":" -f 2 | \
	cut -d '"' -f 2`

docker exec $node_name bash /redis-cluster/cluster_addslots_in_container.sh \
	$node_host $node_port $start_slot $end_slot
