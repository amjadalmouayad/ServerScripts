#!/bin/bash

#color
cecho () {
  local _color=$1; shift
  echo -e "$(tput setaf $_color)$@$(tput sgr0)"
}

# you can also define some variables
red=1; green=2; 


ntpdate 78.110.96.12
hwclock -w
#Disable SELINUX
sed -i.bak 's/^\(SELINUX=\).*/\1Disable/' /etc/selinux/config

#install tor
yum -y install epel-release
yum -y install tor
service tor start

chkconfig iptables off
chkconfig ip6tables off
service ip6tables stop
service iptables stop


#install postgresql
cecho $green "download postgresql" 
cd ~
curl -O http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm
torify curl -O https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-centos96-9.6-3.noarch.rpm

echo_st="$(echo $?)"
if [ $echo_st = 0 ];
then
        cecho $green "download complete postgresql"
else
        cecho $red "faild to download postgresql"
fi
rpm -ivh pgdg*
yum list postgres*
cecho $green  "install postgresql"
yum -y install postgresql96-server

echo_st="$(echo $?)"
if [ $echo_st = 0 ];
then
        cecho $green "complete install postgresql"
else
        cecho $red "faild to install postgresql"
fi

service postgresql-9.6 initdb
chkconfig postgresql-9.6 on
service postgresql-9.6 start


#install java 8 
cecho $green "install java"
#install jre
cd ~
torify wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jre-8u60-linux-x64.rpm"

echo_st="$(echo $?)"
if [ $echo_st = 0 ];
then
        cecho $green "download complete Java JRE"
else
        cecho $red "faild to download java JRE"
fi

sudo yum -y localinstall jre-8u60-linux-x64.rpm
#install jdk
cd ~
torify wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"

echo_st="$(echo $?)"
if [ $echo_st = 0 ];
then
        cecho $green "download complete Java JDK"
else
        cecho $red "faild to download Java JDK"
fi

sudo yum -y localinstall jdk-8u60-linux-x64.rpm

export JAVA_HOME=/usr/java/jdk1.8.0_60/
 
export JRE_HOME=/usr/java/jdk1.8.0_60/jre

export PATH=/usr/java/jdk1.8.0_60/bin:$PATH 


#Download Pentaho
cd /
mkdir Pentaho
cd /Pentaho
torify wget https://downloads.sourceforge.net/project/pentaho/Data%20Integration/7.0/pdi-ce-7.0.0.0-25.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpentaho%2F&ts=1494250902&use_mirror=cytranet

echo_st="$(echo $?)"
if [ $echo_st = 0 ];
then
        cecho $green "download complete pentaho-server-ce-7.0.0.0-25"
else 
        cecho $red "faild to download pentaho-server-ce-7.0.0.0-25"

fi

unzip pentaho-server-ce-7.0.0.0-25.zip
chmod -R 777 Pentaho/pentaho-server/*
h_name="$(hostname)"
my_ip="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"

echo -n $my_ip  $h_name >> /etc/hosts

#run pentaho

/Pentaho/pentaho-server/start-pentaho.sh
