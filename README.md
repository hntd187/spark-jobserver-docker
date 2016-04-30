# spark-jobserver-docker

A docker container for [The Spark Jobserver](https://github.com/spark-jobserver/spark-jobserver)

You can build the image directly from github with

```
sudo docker build -t spark-jobserver/server:0.6.2 https://github.com/hntd187/spark-jobserver-docker.git
```

The following build args are available.

* SJS_VERSION = < Spark Jobserver Version > Default: v0.6.2
* SPARK_VERSION = < Spark Version > Default: 1.6.1
* MESOS_VERSION = < Mesos Version > Default: 0.28.1-2.0.20.ubuntu1404
* HADOOP_VERSION = < Hadoop Version > Default: 2.6

You can run the built image with...

```
sudo docker run -i -t -d -p 0.0.0.0:8090:8090 -p 0.0.0.0:9999:9999 spark-jobserver/server:0.6.2
```