#!/bin/bash

# 节点分配哈希槽的子函数

node_host=$1   # 节点容器IP
node_port=$2   # 节点容器端口号
start_slot=$3  # 起始哈希槽编号
end_slot=$4    # 结束哈希槽编号

for i in $(seq $start_slot $end_slot); do
	redis-cli -c -h $node_host -p $node_port -r 1 CLUSTER ADDSLOTS $i >/dev/null
done
