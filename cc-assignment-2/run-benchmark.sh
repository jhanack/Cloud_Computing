#!/bin/bash

ip_qemu="127.0.0.1"
port_qemu=2200
ip_qemu_kvm="127.0.0.1"
port_qemu_kvm=2201

#### host machine ####
# create csv file with result headers
echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" > benchmark_results_host.csv
# run benchmark 10 times
for i in $(seq 1 10)
do
  ./benchmark.sh > benchmark_results_host.csv
done

#### QEMU without KVM ####
# copy benchmark script to vm
scp benchmark.sh "maxksoll@${ip_qemu}:~/home/maxksoll/Documents/benchmark.sh" -P port_qemu
# create csv file with result headers
ssh "maxksoll@${ip_qemu}" echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" > ~/home/maxksoll/Documents/benchmark_results.csv
# run benchmark 10 times
for i in $(seq 1 10)
do
  ssh "maxksoll@${ip_qemu}" ~/home/maxksoll/Documents/benchmark.sh > ~/home/maxksoll/Documents/benchmark_results.csv
done
# retrieve results from VM
scp "maxksoll@${ip_qemu}:~/home/maxksoll/Documents/benchmark_results.csv" benchmark_results_qemu.csv -P port_qemu

#### QEMU with KVM ####
# copy benchmark script to vm
scp benchmark.sh "maxksoll@${ip_qemu_kvm}:~/home/maxksoll/Documents/benchmark.sh" -P port_qemu_kvm
# create csv file with result headers
ssh "maxksoll@${ip_qemu_kvm}" echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" > ~/home/maxksoll/Documents/benchmark_results.csv
# run benchmark 10 times
for i in $(seq 1 10)
do
  ssh "maxksoll@${ip_qemu_kvm}" ~/home/maxksoll/Documents/benchmark.sh > ~/home/maxksoll/Documents/benchmark_results.csv
done
# retrieve results from VM
scp "maxksoll@${ip_qemu_kvm}:~/home/maxksoll/Documents/benchmark_results.csv" benchmark_results_qemu_kvm.csv -P port_qemu_kvm

#### DOCKER ####
# create csv file with result headers
echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" > benchmark_results_docker.csv
# run benchmark 10 times
for i in $(seq 1 10)
do
  docker run -it --rm --name running-docker-container benchmark-app > benchmark_results_host.csv
done
