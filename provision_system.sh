#!/bin/bash

echo ">>>> Configure and mount extra disk"
parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary 512 100%
mkfs.xfs /dev/sdb1
mkdir /u01
echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /u01   xfs   noatime,nobarrier   0   0 >> /etc/fstab
mount /u01

echo ">>>> Set timezone"
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

echo ">>>> Disable firewall"
systemctl stop firewalld
systemctl disable firewalld

echo ">>>> Install additional repositories"
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://rhel7.iuscommunity.org/ius-release.rpm

echo ">>>> Update/install software"
yum update -y
yum install -y unzip gcc kernel-uek-devel wget vim git rlwrap python35u

