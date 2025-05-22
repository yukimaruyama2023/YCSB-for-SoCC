#!/bin/bash

# 使用方法: ./flush.sh 10 → 11211 〜 11220 に flush_all を送る

if [ -z "$1" ]; then
	echo "Usage: $0 <count>"
	exit 1
fi

START_PORT=11211
COUNT=$1

for ((i = 0; i < COUNT; i++)); do
	PORT=$((START_PORT + i))
	echo "Flushing Memcached on port $PORT..."
	echo "flush_all" | nc 127.0.0.1 $PORT
done

echo "All done."
