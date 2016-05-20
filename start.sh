#!/bin/bash

mode=$1

case $mode in
  single)
    docker run -d -p 9200:9200 -p 9300:9300 \
      --env CLUSTER_NAME=dev \
      --env CLUSTER_FORCE_ZONE=zone1,zone2 \
      --env NODE_NAME=elastic-01 \
      --name elastic weezhard/elasticsearch /bin/bash
    ;;
  multi-node)
    docker network create --subnet=172.18.0.0/16 elastic

    docker run -d --net elastic --ip 172.18.0.21 \
      --env CLUSTER_NAME=prod \
      --env CLUSTER_FORCE_ZONE=zone1,zone2 \
      --env NODE_NAME=elastic-01 \
      --env NODE_ZONE=zone1 \
      --env UNICAST_HOSTS=172.18.0.21,172.18.0.22,172.18.0.23 \
      --name elastic1 weezhard/elasticsearch /bin/bash

    docker run -d --net elastic --ip 172.18.0.22 \
      --env CLUSTER_NAME=prod \
      --env CLUSTER_FORCE_ZONE=zone1,zone2 \
      --env NODE_NAME=elastic-02 \
      --env NODE_ZONE=zone2 \
      --env UNICAST_HOSTS=172.18.0.21,172.18.0.22,172.18.0.23 \
      --name elastic2 weezhard/elasticsearch /bin/bash

    docker run -d --net elastic --ip 172.18.0.23 \
      --env CLUSTER_NAME=prod \
      --env CLUSTER_FORCE_ZONE=zone1,zone2 \
      --env NODE_NAME=elastic-03 \
      --env NODE_ZONE=zone1 \
      --env UNICAST_HOSTS=172.18.0.21,172.18.0.22,172.18.0.23 \
      --name elastic3 weezhard/elasticsearch /bin/bash
    ;;
    *)
      echo "Unknown option"
    ;;
esac
