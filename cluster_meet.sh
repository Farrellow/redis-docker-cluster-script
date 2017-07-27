#!/bin/bash

# 将目标节点添加到客户端连接节点所在的集群

cli_name=$1  # 客户端连接节点容器名
tar_name=$2  # 目标节点容器名

cli_host=`docker inspect $cli_name | grep HostIp | cut -d ":" -f 2 | \
	cut -d '"' -f 2`
cli_port=`docker inspect $cli_name | grep HostPort | cut -d ":" -f 2 | \
	cut -d '"' -f 2`

tar_host=`docker inspect $tar_name | grep HostIp | cut -d ":" -f 2 | \
	cut -d '"' -f 2`
tar_port=`docker inspect $tar_name | grep HostPort | cut -d ":" -f 2 | \
	cut -d '"' -f 2`

docker exec $cli_name redis-cli -c -h $cli_host -p $cli_port -r 1 \
	CLUSTER MEET $tar_host $tar_port
