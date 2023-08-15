#!/bin/bash

# add user and group
sudo useradd -m atom-bridge --shell /bin/bash

sudo passwd -d atom-bridge

# create a directory
sudo mkdir -p /opt/atom-bridge

# copy jdk to tmp dir
sudo cp /mnt/hgfs/atom-bridge/*.rpm /tmp

# install jdk
sudo rpm -i /tmp/bellsoft-jdk11.0.20+8-linux-amd64.rpm

# set JAVA_HOME and add it to PATH
export JAVA_HOME=/usr/lib/jvm/bellsoft-java11.x86_64
export PATH=$PATH:$JAVA_HOME/bin

# copy abridge
sudo cp -r /mnt/hgfs/atom-bridge/df /opt/atom-bridge/df

# set permissions
sudo chown -R atom-bridge:atom-bridge /opt/atom-bridge

# set inodes limits
su -
echo "*  hard  nofile  50000" >> /etc/security/limits.conf
echo "*  soft  nofile  50000" >> /etc/security/limits.conf
su user

# set tcp sockets numbers
sudo sysctl -w net.ipv4.ip_local_port_range="10000 65000"

# if module nf_ip_conntrack installed
sudo sysctl -w net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait="1"

# disable swaping
sudo swapoff -a # edit /etc/fstab
sudo sed -i '/swap/s/^/#/' /etc/fstab

# run atom bridge
/opt/atom-bridge/df/bin/nifi.sh start --illegal-access=warn
