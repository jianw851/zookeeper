#!/bin/sh
set -e
set -x
[ -z "$ID_OFFSET" ] && ID_OFFSET=1
export ZOOKEEPER_SERVER_ID=$((${HOSTNAME##*-} + $ID_OFFSET))
echo "${ZOOKEEPER_SERVER_ID:-1}" | tee /var/lib/zookeeper/data/myid
/opt/zookeeper/bin/zookeeper-server-start.sh /opt/zookeeper/config/zookeeper.properties
