#!/bin/bash

export RUNLEVEL=1
export DEBIAN_FRONTEND=noninteractive

echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe" > /etc/apt/sources.list
apt-get -qy update

# add ssh
apt-get install -qy openssh-server
sed -i 's/start on filesystem/start on filesystem or dockerboot/' /etc/init/ssh.conf

# add dbus, need for upstart jobs
apt-get install -qy dbus
sed -i 's/start on local-filesystems/start on local-filesystems or dockerboot/' /etc/init/dbus.conf

# change /bin/mknod, need for openjdk-7-jdk => fuse
dpkg-divert --local --rename --add /sbin/mknod && ln -s /bin/true /sbin/mknod

# create user
useradd -m vexor -s /bin/bash
echo "vexor:vexor" | chpasswd
apt-get -qy install sudo
echo "vexor ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# setup ssh for vexor
mkdir -p /home/vexor/.ssh
chmod 0700 /home/vexor/.ssh
cat > /home/vexor/.ssh/config <<EOF
Host *
  ForwardAgent yes
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
EOF
chown -R vexor:vexor /home/vexor/.ssh

# fix locales
locale-gen en_US.UTF-8
dpkg-reconfigure -fnoninteractive locales
update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US"

# There is a conflict with the package versions (maybe is not needed)
# python : Depends: python2.7 (>= 2.7.3) but it is not going to be installed
# Depends: python-minimal (= 2.7.3-0ubuntu2) but 2.7.3-0ubuntu2.2 is to be installed
# python-minimal : Depends: python2.7-minimal (>= 2.7.3) but it is not going to be installed

dpkg --remove --force-all python
dpkg --remove --force-all python2.7-minimal

wget http://cz.archive.ubuntu.com/ubuntu/pool/main/p/python-defaults/python_2.7.3-0ubuntu2.2_amd64.deb
wget http://cz.archive.ubuntu.com/ubuntu/pool/main/p/python-defaults/python-minimal_2.7.3-0ubuntu2.2_amd64.deb
dpkg --install --force-all python-minimal_2.7.3-0ubuntu2.2_amd64.deb
dpkg --install --force-all python_2.7.3-0ubuntu2.2_amd64.deb

#apt-get autoremove
apt-get clean
apt-get autoclean
apt-get update
apt-get install -qyf

# install python and modules, needed for ansible
apt-get install -qy python-minimal
apt-get install -qy python

#ENTRYPOINT ["/sbin/init", "--startup-event", "dockerboot"]
