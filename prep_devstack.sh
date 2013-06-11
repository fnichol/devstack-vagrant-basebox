#!/usr/bin/env bash
set -e

GIT_URL="git://github.com/openstack-dev/devstack.git"
SRC_DIR="/tmp/devstack"
DEST="/opt/stack"
PASS="stack"
IP="172.16.100.10"

banner()  { printf -- "-----> $*\n"; }
log()     { printf -- "       $*\n"; }
warn()    { printf -- ">>>>>> $*\n"; }
fail()    { printf -- "\nERROR: $*\n" ; exit 1 ; }

mkdir -p "$(dirname $SRC_DIR)"

banner "Running apt-get update"
apt-get update

banner "Installing git"
apt-get install -y git

banner "Cloning devstack"
git clone "$GIT_URL" "$SRC_DIR"

banner "Creating $SRC_DIR/localrc"
cat <<_LOCALRC_ > "$SRC_DIR/localrc"
DEST=$DEST
ENABLED_SERVICES+=,tempest
ADMIN_PASSWORD=$PASS
MYSQL_PASSWORD=$PASS
RABBIT_PASSWORD=$PASS
SERVICE_PASSWORD=$PASS
SERVICE_TOKEN=servtoken
HOST_IP=$IP
SERVICE_HOST=\$HOST_IP
NETWORK_GATEWAY=172.16.100.1
FIXED_RANGE=172.16.100.128/25
FIXED_NETWORK_SIZE=128
FLOATING_RANGE=172.16.100.64/26
LOGFILE=stack.sh.log
LOGDAYS=1
LOG_COLOR=False
SCREEN_LOGDIR=\$DEST/logs/screen
API_RATE_LIMIT=False
APT_FAST=True
RECLONE=no
_LOCALRC_

banner "Creating $SRC_DIR/local.sh"
cat <<_LOCALSH_ > "$SRC_DIR/local.sh"
#!/bin/bash
TOP_DIR=$DEST/devstack
source \$TOP_DIR/functions
source \$TOP_DIR/stackrc

# OpenStack credentials
source \$TOP_DIR/openrc

# Add tcp/22 and icmp to default security group
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0

# Load external local.sh if it exists via Vagrant share
if [ -x /vagrant/local.sh ] ; then
  echo "-----> Running local project user script"
  /vagrant/local.sh
fi
_LOCALSH_
chmod +x "$SRC_DIR/local.sh"

banner "Running stack.sh, this may take a while"
time ($SRC_DIR/stack.sh)

banner "Enabling offline mode in localrc"
echo 'OFFLINE=True' >> "$DEST/devstack/localrc"

banner "Cleaning up"
rm -rf "$SRC_DIR"

banner 'All done!'
