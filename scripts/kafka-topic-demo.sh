#!/usr/bin/env bash
set -euo pipefail

docker exec -it xdev-kafka bash -lc \
  'kafka-topics.sh --bootstrap-server kafka:9094 --create --if-not-exists --topic demo --partitions 1 --replication-factor 1 && \
   kafka-topics.sh --bootstrap-server kafka:9094 --list'
