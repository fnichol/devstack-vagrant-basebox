#!/usr/bin/env bash
set -e

GIT_URL="git://github.com/openstack-dev/devstack.git"
SRC_DIR="/usr/local/src/devstack"
PASS="stack"
IP="33.33.33.33"

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
DEST=/opt/stack
ENABLED_SERVICES+=,tempest
ADMIN_PASSWORD=$PASS
MYSQL_PASSWORD=$PASS
RABBIT_PASSWORD=$PASS
SERVICE_PASSWORD=$PASS
SERVICE_TOKEN=servtoken
HOST_IP=$IP
SERVICE_HOST=$HOST_IP
LOGFILE=stack.sh.log
LOGDAYS=1
LOG_COLOR=False
SCREEN_LOGDIR=$DEST/logs/screen
API_RATE_LIMIT=False
APT_FAST=True
RECLONE=no
_LOCALRC_

banner "Creating $SRC_DIR/local.sh"
cat <<_LOCALSH_ > "$SRC_DIR/local.sh"
#!/bin/bash
TOP_DIR=$SRC_DIR
source \$TOP_DIR/functions
source \$TOP_DIR/stackrc

# OpenStack credentials
source \$TOP_DIR/openrc

# Add tcp/22 and icmp to default security group
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
_LOCALSH_
chmod +x "$SRC_DIR/local.sh"

banner "Running stack.sh, this may take a while"
time ($SRC_DIR/stack.sh)

banner "Enabling offline mode in localrc"
echo 'OFFLINE=True' >> "$SRC_DIR/localrc"

banner 'All done!'
