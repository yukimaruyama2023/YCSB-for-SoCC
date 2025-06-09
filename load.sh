#!/bin/bash

# 引数がない場合はメッセージを出して終了
if [ $# -lt 1 ]; then
	echo "Usage: $0 <NUM_INSTANCES>"
	echo "Error: NUM_INSTANCES not provided."
	exit 1
fi

NUM_INSTANCES=$1
BASE_PORT=11211
WORKLOAD_FILE="workloads/myworkload"
HOST_ID=$(hostname)

MEMCACHED_HOSTS=""
for ((i = 0; i < NUM_INSTANCES; i++)); do
	PORT=$((BASE_PORT + i))
	MEMCACHED_HOSTS+="127.0.0.1:$PORT,"
done
# 最後のカンマ削除
MEMCACHED_HOSTS="${MEMCACHED_HOSTS%,}"

# 実行（NUMA node 1 の全24コアを使う）
numactl --cpunodebind=1 --membind=1 ./bin/ycsb load memcached -s -P "$WORKLOAD_FILE" \
	-p "memcached.hosts=$MEMCACHED_HOSTS" \
	-p "insert.key_prefix=${HOST_ID}_" \
	-threads 24 >"NUMA-LOG/output-multi-Load.txt"
