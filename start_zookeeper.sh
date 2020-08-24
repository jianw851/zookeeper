#!/bin/sh
sed -i -r 's|#(log4j.appender.ROLLINGFILE.MaxBackupIndex.*)|\1|g' $ZOOKEEPER_HOME/conf/log4j.properties
sed -i -r 's|#autopurge|autopurge|g' $ZOOKEEPER_HOME/conf/zoo.cfg
/opt/zookeeper-${ZOOKEEPER_VERSION}/bin/zkServer.sh start-foreground

