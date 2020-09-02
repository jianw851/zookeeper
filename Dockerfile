FROM ubuntu:20.04
MAINTAINER jwang
USER root

# Install OpenJDK-8
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y net-tools && \
    apt-get install -y vim && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# install wget gpg
RUN apt-get install -y wget && \
    apt-get install -y gnupg;

# set up env vars
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64/
ENV ZOOKEEPER_VERSION 3.5.8
ENV ZOOKEEPER_HOME /opt/zookeeper-${ZOOKEEPER_VERSION}

# Download Zookeeper
RUN wget -q http://mirror.vorboss.net/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
wget -q https://www.apache.org/dist/zookeeper/KEYS && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512

# Verify download
RUN sha512sum -c apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512 && \
gpg --import KEYS && \
gpg --verify apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc

# Install
RUN tar -xzf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -C /opt

# Configure
RUN mv /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin /opt/zookeeper-${ZOOKEEPER_VERSION}
RUN mv /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo_sample.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg
RUN sed  -i "s|/tmp/zookeeper|$ZOOKEEPER_HOME/data|g" $ZOOKEEPER_HOME/conf/zoo.cfg; mkdir $ZOOKEEPER_HOME/data

# entry point
ADD start_zookeeper.sh /usr/bin/start_zookeeper.sh 
EXPOSE 2181 2888 3888
WORKDIR /opt/zookeeper-${ZOOKEEPER_VERSION}
VOLUME ["/opt/zookeeper-${ZOOKEEPER_VERSION}/conf", "/opt/zookeeper-${ZOOKEEPER_VERSION}/data"]
ENTRYPOINT ["/usr/bin/start_zookeeper.sh"]
