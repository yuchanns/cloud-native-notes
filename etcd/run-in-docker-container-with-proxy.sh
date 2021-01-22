#!/bin/bash
#
# yuchanns@20210122
#
  ETCD_DATA=$(pwd)/etcd-data
  if [ ! -d $ETCD_DATA  ]; then
      mkdir $ETCD_DATA
  fi
  docker run \
  --env https_proxy="127.0.0.1:1080" \
  --env no_proxy="127.0.0.1,localhost,0.0.0.0" \
  -d \
  -p 2379:2379 \
  -p 2380:2380 \
  --mount type=bind,source=$(pwd)/etcd-data,destination=/etcd-data \
  --name etcd-gcr-v3.4.9 \
  gcr.io/etcd-development/etcd:v3.4.9 \
  /usr/local/bin/etcd \
  --name s1 \
  --data-dir /etcd-data \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --initial-cluster s1=http://0.0.0.0:2380 \
  --initial-cluster-token tkn \
  --initial-cluster-state new \
  --log-level info \
  --logger zap \
  --log-outputs stderr && \
  docker exec etcd-gcr-v3.4.9 /bin/sh -c "/usr/local/bin/etcd --version" && \
  docker exec etcd-gcr-v3.4.9 /bin/sh -c "/usr/local/bin/etcdctl version" && \
  docker exec etcd-gcr-v3.4.9 /bin/sh -c "/usr/local/bin/etcdctl endpoint health" && \
  docker exec etcd-gcr-v3.4.9 /bin/sh -c "/usr/local/bin/etcdctl put foo bar" && \
  docker exec etcd-gcr-v3.4.9 /bin/sh -c "/usr/local/bin/etcdctl get foo"

