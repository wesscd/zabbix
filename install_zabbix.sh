#!/bin/bash

# author: Wesley Marques
# describe: Instalar Zabbix
# version: 0.1
# license: MIT License

clear

# CONS
NICKNAME=$(ip address show | grep -w 2 | awk '{print $2}')

if [ $USER != 'root' ]
    then
        echo "------------------------------------"
        echo "You need privileges of administrator"
        echo "------------------------------------"

   exit 1
fi 

which apt > /dev/null 2>&1

if [ $? -ne 0 ]
    then
        echo "------------------------------------------"
        echo "Your OS is not compatible with this script"
        echo "------------------------------------------"
        echo

        exit 2
fi
if [ ! -d /etc/netplan/original ]
    then
        mkdir -p /etc/netplan/original
        mv /etc/netplan/*.yaml /etc/netplan/original || mv /etc/netplan/*.yml /etc/netplan/original
    fi
    echo "------------------------------------"
    echo "        NETPLAN CONFIGURE           "
    echo "        Input IP Address            "
    echo "------------------------------------"
    echo
    
    read IP

    echo "------------------------------------"
    echo "Input CIDR"
    echo
    echo "Ex:"
    echo ""
    echo "24 = 255.255.255.0"
    echo "16 = 255.255.0.0"
    echo "8 = 255.0.0."
    echo ""
    echo "------------------------------------"
    echo

    
    echo 

    read CIDR
    
    if [ $CIDR -gt 32 -o $CIDR -lt 0 ]
    	then
		echo
		echo "------------------------------------"
		echo "Prefix out of range"
		echo "------------------------------------"
		echo
        exit 3
    fi

    echo "------------------------------------"
    echo "           Input GATEWAY"
    echo "------------------------------------"

    read GATEWAY

    echo "------------------------------------"
    echo "           Input DNS1"
    echo "------------------------------------"

    read DNS1

    echo "------------------------------------"
    echo "           Input DNS2"
    echo "------------------------------------"

    read DNS2

    echo "
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    $NICKNAME
       dhcp4: no
       dhcp6: no
       addresses: [$IP/$CIDR]
       gateway4: $GATEWAY
       nameservers:
           addresses: [$DNS1,$DNS2]" > /etc/netplan/01-netcfg.yaml
    echo
    echo "checking file syntax"

    netplan --debug generate > /dev/null 2>&1

    if [ $? -ne 0 ]
    then
        echo
        echo "Error of sintax"
        echo

        exit 4

    else
        echo
            netplan apply

        echo "Done"
    fi

    echo 
    echo "------------------------------------"
    echo "Checking internet connection"
    echo "------------------------------------"
    echo

    ping -c 4 8.8.8.8

    sleep 2

    clear

    echo "------------------------------------"
    echo "IP ADDRESS CONFIGURED"
    echo "------------------------------------"
    echo

    #networkctl status

    sleep 2
    
    echo "------------------------------------"
    echo "------------------------------------"
    echo "------ UPDATING REPOSITORIES -------"
    echo "------------------------------------"
    echo "------------------------------------"
    
    apt update && apt upgrade -y
    
    sleep 10

    echo "------------------------------------"
    echo "------------------------------------"
    echo "Starting installation of SAMBA4"
    echo "------------------------------------"
    echo "------------------------------------"

    echo "------------------------------------"
    echo "Adjusting date and time"
    echo "------------------------------------"

    timedatectl set-timezone America/Sao_Paulo

    apt install ntp ntpdate -y

    service ntp stop

    ntpdate a.st1.ntp.br

    service ntp start

    sleep 5

    clear

    mkdir /dl_zabbix

    cd /dl_zabbix

    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1+ubuntu18.04_all.deb

    dpkg -i zabbix-release_6.0-1+ubuntu18.04_all.deb

    apt update

    apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

    # Execute os camandos abaixo após o script siga os passos do link abaixo apartir do passo C.
    #
    # https://www.zabbix.com/download?zabbix=6.0&os_distribution=ubuntu&os_version=18.04_bionic&db=mysql&ws=apache
    #
    
