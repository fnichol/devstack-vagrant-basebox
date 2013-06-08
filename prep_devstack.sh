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
LOGFILE=stack.sh.log
LOGDAYS=1
LOG_COLOR=False
SCREEN_LOGDIR=\$DEST/logs/screen
API_RATE_LIMIT=False
APT_FAST=True
RECLONE=no
_LOCALRC_

banner "Running stack.sh, this may take a while"
time ($SRC_DIR/stack.sh)

banner "Enabling offline mode in localrc"
echo 'OFFLINE=True' >> "$DEST/devstack/localrc"

banner "Cleaning up"
rm -rf "$SRC_DIR"

banner 'All done!'
