# Apache Hive Data Warehouse Migration Project

## 1. Introduction

This project documents the migration of an airline data warehouse from Google Cloud Storage to a Hive-based solution running on Hadoop with Tez as the execution engine. The architecture is containerized using Docker. The project includes schema transformation, performance tuning, and support for both ACID and non-ACID Hive tables.

## 2. Project Overview

### 2.1 Objectives

* Containerize a Hadoop-Hive environment using Docker.
* Migrate a traditional data warehouse schema to Hive (ACID and non-ACID tables).
* Optimize Hive performance with Tez, partitioning, and bucketing.

### 2.2 Key Features

* Hive with Tez execution engine
* ACID support via `DbTxnManager`
* Automated data loads from Google Cloud Storage (GCS) to HDFS
* Optimized storage with ORC, partitioning, and bucketing
* PostgreSQL-backed Hive Metastore

## 3. System Architecture

### 3.1 Dockerized Hadoop-Hive Cluster

| Service        | Description                          | Ports        |
| -------------- | ------------------------------------ | ------------ |
| master1/2/3    | NameNode, ZooKeeper, ResourceManager | 9870, 8088   |
| worker1        | DataNode, NodeManager                | -            |
| postgres       | PostgreSQL (Hive Metastore)          | 5432         |
| hive-metastore | Hive Metastore Service               | 9083         |
| hive-server2   | JDBC/Thrift Interface                | 10000, 10002 |

### Config Highlights

* HDFS HA using ZooKeeper + JournalNodes
* Tez as Hive's execution engine
* ACID: Enabled for transactional support

## 4. Project Structure

```
HIVE_PROJECT/
├── code/
│   └── GCS_TO_HDFS.py
├── config/
│   ├── hadoop/
│   │   ├── core-site.xml
│   │   ├── hdfs-site.xml
│   │   ├── mapred-site.xml
│   │   └── yarn-site.xml
│   ├── hive/
│   │   └── hive-site.xml
│   └── tez/
│       └── tez-site.xml
├── Hive_DataBase/
│   ├── final_tables.sql
│   ├── load_data.sql
│   └── staging_tables.sql
├── scripts/
│   ├── entrypoint.sh
│   └── hive_entrypoint.sh
├── zookeeper/
│   └── zoo.cfg
├── docker-compose.yml
├── Dockerfile.hadoop
└── Dockerfile.hive
```

### 5. Key Files

* `docker-compose.yml`: Defines cluster services
* `Dockerfile.hadoop`: Sets up Hadoop & ZooKeeper
* `Dockerfile.hive`: Installs Hive, Tez, JDBC
* `staging_tables.sql`: External ORC staging tables
* `final_tables.sql`: ACID-compliant optimized tables
* `load_data.sql`: Load from staging to final
* `GCS_TO_HDFS.py`: Automates data movement from GCS

## 6. Deployment

### Option 1: Using `build` in `docker-compose.yml`

```bash
docker-compose build
docker-compose up -d
```

### Option 2: Using Prebuilt Images

```bash
docker build -f Dockerfile.hadoop -t hadoop-cluster:latest .
docker build -f Dockerfile.hive -t hive-cluster:latest .
docker-compose up -d
```
