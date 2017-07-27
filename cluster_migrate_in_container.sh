#!/bin/bash

start_slot=$1   # 起始哈希槽编号
end_slot=$2     # 结束哈希槽编号

src_node_id=$3  # 源节点id
tar_node_id=$4  # 目标节点id

src_host=$5     # 源节点ip
src_port=$6     # 源节点端口
tar_host=$7     # 目标节点ip
tar_port=$8     # 目标节点端口

for slot in $(seq $start_slot $end_slot); do
	redis-cli -c -h $tar_host -p $tar_port -r 1 \
		CLUSTER SETSLOT $slot IMPORTING $src_node_id
	redis-cli -c -h $src_host -p $src_port -r 1 \
		CLUSTER SETSLOT $slot MIGRATING $tar_node_id

	key_exist=1
	while [ $key_exist = 1 ]; do
		key_exist=0
		for key in `redis-cli -c -h $src_host -p $src_port -r 1 \
			    CLUSTER GETKEYSINSLOT $slot 10 | cut -f 1`; do
			redis-cli -c -h $src_host -p $src_port -r 1 \
				    MIGRATE $tar_host $tar_port $key 0 2000
			key_exist=1
		done
	done

	redis-cli -c -h $src_host -p $src_port -r 1 \
		    CLUSTER SETSLOT $slot NODE $src_node_id
	redis-cli -c -h $tar_host -p $tar_port -r 1 \
		    CLUSTER SETSLOT $slot NODE $tar_node_id
done
