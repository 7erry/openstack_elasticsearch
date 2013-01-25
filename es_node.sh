#!/bin/bash

###############################################
# leave a paper trail
set -e -x
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# update repo's and upgrade/patch os
cd ~
sudo apt-get update && apt-get upgrade -y
sudo locale-gen en_US.UTF-8
sudo apt-get install -y wget

# Headless java
sudo apt-get install openjdk-7-jre-headless -y

###############################################
# change based on preferred version (latest ga)
# install elastic search
wget http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.2.tar.gz -O elasticsearch.tar.gz
tar -xf elasticsearch.tar.gz
rm elasticsearch.tar.gz
sudo mv elasticsearch-* elasticsearch
sudo mv elasticsearch /usr/local/share

# use a service wrapper to ensure elastic search starts/stops with the os lifecycle 
curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz
sudo mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/
rm -Rf *servicewrapper*
sudo /usr/local/share/elasticsearch/bin/service/elasticsearch install
sudo ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch

# get the cloud aws plugin and install it 
sudo /usr/local/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/1.10.0

# configure cloud aws plugin for ec2 auto discovery of nodes
echo "discovery.zen.ping.multicast.enabled: false" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "discovery.zen.ping.unicast.enabled: false" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "cluster.name: PoC" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "plugin.mandatory:" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "      cloud-aws" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "cloud:" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "    aws:" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "        access_key: YOURACCESSKEY" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "        secret_key: YOURSECRETKEY" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "        region: us-east-1 " >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo " " >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "discovery:" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "    type: ec2" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "    ec2:" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "        groups: ElasticSearch" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "    zen:" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "        ping_timeout: 30s" >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo " " >>/usr/local/share/elasticsearch/config/elasticsearch.yml
echo "network:" >>/usr/local/share/elasticsearch/config/elasticsearch.yml 
echo "    bind_host: _ec2_" >>/usr/local/share/elasticsearch/config/elasticsearch.yml 
echo " " >>/usr/local/share/elasticsearch/config/elasticsearch.yml


# start elastic search service 
sudo service elasticsearch start
#curl http://localhost:9200
# done
