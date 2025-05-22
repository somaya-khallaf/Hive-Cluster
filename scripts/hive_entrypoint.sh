#!/bin/bash
# hive_entrypoint.sh

case ${SERVICE_NAME} in
  "metastore")

    # wait for master1 namenode to be ready
    echo "Waiting for master1 namenode..."
    until nc -z master1 8020; do
      sleep 5
    done

    if [ ! -f /usr/local/hive/check ]; then
      echo "Initializing Hive metastore schema..."
      schematool -dbType postgres -initSchema 
      touch /usr/local/hive/check
    else
      echo "Hive metastore schema already initialized."
    fi

    # Create required HDFS directories
    echo "Creating HDFS directories..."
    hdfs dfs -mkdir -p /tez
    hdfs dfs -chmod 777 /tez
    hdfs dfs -put /usr/local/tez/share/tez.tar.gz /tez/
      
    # Start metastore
    echo "Starting Hive metastore..."
    hive --service metastore
    ;;

  "hiveserver2")
    echo "Waiting for metastore to be ready..."
    until nc -z hive-metastore 9083; do
      sleep 5
    done
    echo "Starting HiveServer2..."
    hiveserver2
    ;;
    
  *)
    echo "Unknown service name: ${SERVICE_NAME}"
    exit 1
    ;;
esac