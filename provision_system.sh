#!/bin/bash
echo ">>>> Set timezone"
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

echo ">>>> Disable firewall"
systemctl stop firewalld
systemctl disable firewalld

echo ">>>> Install EPEL repository"
curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh epel-release-latest-7.noarch.rpm

echo ">>>> Update/install software"
yum update -y
yum install -y unzip gcc kernel-uek-devel wget vim git rlwrap python34
