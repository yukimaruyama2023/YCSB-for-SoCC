#!/bin/bash

NUM_INSTANCES=10
BASE_PORT=11211
WORKLOAD_FILE="workloads/myworkload"
HOST_ID=$(hostname)

# memcached ホストリストを作成
MEMCACHED_HOSTS=""
for ((i = 0; i < NUM_INSTANCES; i++)); do
	PORT=$((BASE_PORT + i))
	MEMCACHED_HOSTS+="127.0.0.1:$PORT,"
done
# 最後のカンマ削除
MEMCACHED_HOSTS="${MEMCACHED_HOSTS%,}"

# 実行（NUMA node 1 の全24コアを使う）
numactl --cpunodebind=1 --membind=1 ./bin/ycsb run memcached -s -P "$WORKLOAD_FILE" \
	-p "memcached.hosts=$MEMCACHED_HOSTS" \
	-p "insert.key_prefix=${HOST_ID}_" \
	-threads 24 >"LOG/output-multi-Run.txt"
