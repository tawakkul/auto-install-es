#!/bin/bash
currentTime=$(date '+%Y-%m-%d %H:%M:%S')
es_path=$2

#create path to install es
if [! -d $es_path ];then
	mkdir -p $es_path
	echo "es path created."
fi
if [! -d $es_path ];then
	echo "failed to create es path , make sure you have the right"
	exit 1
fi

#untar the packge
tar_dir=$1
ls $tar_dir | grep 'elasticsearch-.*[gz]$'
if [ $? -ne 0 ];then
	echo "make sure there is a package of es at the current dir."
	exit 1
else
	tar -zxvf $tar_dir/$(ls $tar_dir | grep 'elasticsearch-.*[gz]$') -C $es_path
fi

esbanben=`ls $es_path | grep 'elasticsearch-*'`

#set the path
echo "" >> ~/.bash_profile
echo "#ES $currentTIme" >> ~/.bash_prifile
echo "export ES_HOME=$es_path/$esbanben" >> ~/.bash_profile
echo 'export PATH=$PATH:$ES_HOME/bin' >> ~/.bash_profile
source ~/.bash_profile

confpath=$es_path/$esbanben/config

#modify profile
echo "cluster.name: $clusterName" >> $confpath/elasticsearch.yml
echo "path.data: $pathData" >> $confpath/elasticsearch.yml
echo "path.logs: $pathlogs" >> $confpath/elasticsearch.yml
echo "bootstrap.memory_lock: false" >> $confpath/elasticsearch.yml
echo "bootstrap.system_call_filter: false" >> $confpath/elasticsearch.yml
echo "network.host: 0.0.0.0" >> $confpath/elasticsearch.yml
echo "http.port: $httpport" >> $confpath/elasticsearch.yml
echo "transport.tcp.port: $transporttcpport" >> $confpath/elasticsearch.yml
echo "discovery.zen.ping.unicast.hosts: [$unicasthosts]" >> $confpath/elasticsearch.yml
array=(${unicasthosts//,/})
len=${#array[@]}
masternodes=`expr $len / 2 + 1`
echo "discovery.zen.minimum_master_nodes: $masternodes" >> $confpath/elasticsearch.yml

