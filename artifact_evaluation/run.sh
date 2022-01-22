#!/bin/bash
set -e

cd "$(dirname "$0")"

########## PMEMBENCH ##########

cd ../benchmarks/pmembench
docker build -t safepm-pmembench .
mkdir -p results/pmembench_map
mkdir -p results/pmembench_tx
mkdir -p results/pmembench_open_create
mkdir -p results/pmembench_map_partial_cov
docker run -v /mnt/pmem0/stavrakakis/kartal/:/mnt/pmem0/stavrakakis/kartal/ -v $(pwd)/results:/results -it safepm-pmembench bash run.sh

########## PMEMKV ##########

cd ../pmemkv
./run-variants.sh

########## RIPE ##########

cd ../ripe
./run-variants.sh
