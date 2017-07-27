#!/bin/bash

# 创建一个新的redis节点容器

name=$1  # 节点容器名
port=$2  # 节点端口号
host=$3  # 节点容器的docker所在本机IP
images=$4  # docker镜像名称

usage="$0 <name> <port>"

echo 'local host is(当前IP地址):'$host

# 1.判断容器名称参数
if [ -z $name ]; then
	echo 'redis node name is null: '$usage
	exit
else
	echo 'redis node name = '$name
fi

# 2.判断容器节点端口号参数
expr $port "+" 1 >/dev/null
if [ $? -eq 0 ]; then
	if [ -z $port ]; then
		echo 'port is null: '$usage
		exit
	else
        echo 'port = '$port
	fi
else
	echo 'port is not number: '$usage
	exit
fi

# 3.创建redis节点容器
# 3.1.配置文件
redis_node_dir=/data/redis-cluster/$port
mkdir -p $redis_node_dir
cp /data/redis-cluster/redis.conf $redis_node_dir
sed -i "s/port 6379/port $port/g" $redis_node_dir/redis.conf

# 3.2.创建容器
docker run -d --name $name -v /data/redis-cluster:/redis-cluster --net host \
	-p $host:$port:$port $images \
	/usr/local/bin/redis-server /redis-cluster/$port/redis.conf

if [ $? -eq 0 ]; then
	if [ `docker inspect -f '{{.State.Running}}' $name` = 'true' ]; then
	    echo 'create redis cluster node container success'
	else
	    echo 'create redis cluster node container failure'
        docker rm $name
	    rm -rf $redis_node_dir
	fi
else
	echo 'create redis cluster node container failure'
    docker rm $name
	rm -rf $redis_node_dir
fi
