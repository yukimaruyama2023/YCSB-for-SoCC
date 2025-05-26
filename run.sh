#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <number_of_instances>"
	exit 1
fi

NUM_INSTANCES=$1
BASE_PORT=11211
WORKLOAD_FILE="workloads/myworkload"
HOST_ID=$(hostname)

for ((i = 0; i < NUM_INSTANCES; i++)); do
	PORT=$((BASE_PORT + i))
	PREFIX="${HOST_ID}_instance${i}_"
	echo "Running workload against memcached on port $PORT"
	./bin/ycsb run memcached -s -P "$WORKLOAD_FILE" \
		-p "memcached.hosts=127.0.0.1:$PORT" \
		-p "insert.key_prefix=$PREFIX" \
		-threads $(nproc) \
		>"LOG/output-${PORT}-Run.txt" &
done

wait
echo "All $NUM_INSTANCES workloads run completed."
