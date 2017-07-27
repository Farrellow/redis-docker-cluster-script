#!/bin/bash

# 设置两个节点的主从关系

master_node=$1  # 主节点容器名
slave_node=$2   # 从节点容器名

master_node_id=`docker exec $master_node cat /data/nodes.conf | grep myself | \
	cut -d " " -f 1`

slave_host=`docker inspect $slave_node | grep HostIp | cut -d ":" -f 2 | \
	cut -d '"' -f 2`
slave_port=`docker inspect $slave_node | grep HostPort | cut -d ":" -f 2 | \
	cut -d '"' -f 2`

docker exec $slave_node redis-cli -c -h $slave_host -p $slave_port -r 1 \
	CLUSTER REPLICATE $master_node_id
