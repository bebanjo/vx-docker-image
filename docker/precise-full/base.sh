#!/bin/bash

set -e
set -x

export RUNLEVEL=1
export DEBIAN_FRONTEND=noninteractive
export PYTHONUNBUFFERED=1

# To run sshd through supervisord use a better place
mkdir -p -m0700 /var/run/sshd

cd /tmp/provision

apt-get install -qy python-software-properties
apt-add-repository -y ppa:rquillo/ansible
apt-get update
apt-get install -qy ansible

ansible-playbook playbooks/site.yml -v -i playbooks/inventory -c local

apt-get purge -qy ansible
apt-get autoremove -qy

#ENTRYPOINT ["/sbin/init", "--startup-event", "dockerboot"]


