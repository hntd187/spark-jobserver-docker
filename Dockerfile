FROM phusion/baseimage:0.9.18
CMD ["/sbin/my_init"]

ENV TERM=xterm
ARG MESOS_VERSION=0.28.1-2.0.20.ubuntu1404
ARG SJS_VERSION=v0.6.2
ARG SPARK_VERSION=1.6.1
ARG HADOOP_VERSION=2.6

RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN apt-get update
RUN apt-get install wget git openjdk-7-jdk -y -o Dpkg::Options::="--force-confold" 
RUN apt-get install mesos=${MESOS_VERSION} -y -o Dpkg::Options::="--force-confold"
RUN apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt
RUN chmod 0755 /usr/local/bin/sbt

RUN mkdir /app

ENV FILE_NAME=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
RUN wget -q http://d3kbcqa49mib13.cloudfront.net/${FILE_NAME}.tgz
RUN tar xzf ${FILE_NAME}.tgz
RUN rm ${FILE_NAME}.tgz
RUN mv ${FILE_NAME} /spark
RUN git clone https://github.com/spark-jobserver/spark-jobserver.git
RUN cd spark-jobserver && git checkout ${SJS_VERSION}

RUN cd spark-jobserver && sbt -q clean update package assembly

RUN cp /spark-jobserver/bin/server_start.sh /app/server_start.sh
RUN cp /spark-jobserver/bin/server_stop.sh /app/server_stop.sh
RUN cp /spark-jobserver/bin/setenv.sh /app/setenv.sh

RUN cp /spark-jobserver/config/log4j-stdout.properties /app/log4j-server.properties
RUN cp /spark-jobserver/config/docker.conf /app/docker.conf
RUN cp /spark-jobserver/config/docker.sh /app/settings.sh
RUN cp /spark-jobserver/job-server-extras/target/scala-2.10/spark-job-server.jar /app/spark-job-server.jar

ENV JOBSERVER_MEMORY=1G
ENV SPARK_HOME=/spark
VOLUME /database

ENTRYPOINT /app/server_start.sh
EXPOSE 8090
EXPOSE 9999
