#!/bin/bash

add-apt-repository multiverse
apt update

cd /usr/src

wget http://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1%2Bfocal_all.deb

dpkg -i zabbix-*

apt-get update && apt-get upgrade -y

apt-get install zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-get php-mbstring php-bcmath zabbix-apache-conf -y

