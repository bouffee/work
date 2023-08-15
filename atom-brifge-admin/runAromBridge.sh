#!/bin/bash

set -e  # Exit script on error

# add user and group
sudo useradd -m atom-bridge --shell /bin/bash
echo "User 'atom-bridge' created successfully."
sudo passwd -d atom-bridge
echo "Password for 'atom-bridge' removed."

# create a directory
sudo mkdir -p /opt/atom-bridge
echo "Directory '/opt/atom-bridge' created."

# copy jdk to tmp dir
sudo cp /mnt/hgfs/atom-bridge/*.rpm /tmp
echo "JDK RPM files copied to '/tmp'."

# install jdk
sudo rpm -i /tmp/bellsoft-jdk11.0.20+8-linux-amd64.rpm
echo "JDK installed successfully."

# set JAVA_HOME and add it to PATH
su atom-bridge -c 'export JAVA_HOME=/usr/lib/jvm/bellsoft-java11.x86_64'
su atom-bridge -c 'export PATH=$PATH:$JAVA_HOME/bin'
echo "JAVA_HOME set for 'atom-bridge' user."

# copy abridge
sudo cp -r /mnt/hgfs/atom-bridge/df /opt/atom-bridge/df
echo "Abridge files copied to '/opt/atom-bridge/df'."

# set permissions
sudo chown -R atom-bridge:atom-bridge /opt/atom-bridge
echo "Permissions set for '/opt/atom-bridge'."

# set inodes limits
su -c 'echo "*  hard  nofile  50000" >> /etc/security/limits.conf'
su -c 'echo "*  soft  nofile  50000" >> /etc/security/limits.conf'
echo "Inode limits set in '/etc/security/limits.conf'."

# set tcp sockets numbers
sudo sysctl -w net.ipv4.ip_local_port_range="10000 65000"
echo "TCP socket range set."

# if module nf_ip_conntrack installed
# sudo sysctl -w net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait="1"
# echo "netfilter settings adjusted."

# disable swapping
sudo swapoff -a
sudo sed -i '/swap/s/^/#/' /etc/fstab
echo "Swap disabled."

# run atom bridge
# /opt/atom-bridge/df/bin/nifi.sh start --illegal-access=warn

# run atom bridge as a service
echo "Creating systemd service unit file for atom-bridge..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/atom-bridge.service
[Unit]
Description=Atom.Bridge
After=network.target

[Service]
Restart=always
RestartSec=3
LimitNOFILE=500000
Type=forking
User=atom-bridge
Group=atom-bridge
Environment=JAVA_HOME=/usr/lib/jvm/bellsoft-java11.x86_64
ExecStart=/opt/atom-bridge/df/bin/nifi.sh start --illegal-access=warn
ExecStop=/opt/atom-bridge/df/bin/nifi.sh stop

[Install]
WantedBy=multi-user.target
EOF'
echo "Systemd service unit file created."


# Reload systemd and start the service
sudo systemctl daemon-reload
echo "Systemd daemon reloaded."
sudo systemctl enable atom-bridge.service
sudo systemctl start atom-bridge.service
echo "Atom-bridge service enabled and started."
sudo systemctl status atom-bridge.service
