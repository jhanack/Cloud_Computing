#!/bin/bash
echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" | cat > results-native.csv
echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" | cat > results-docker.csv
echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" | cat > results-kvm.csv
echo "time,cpu,mem,diskRand,diskSeq,fork,uplink" | cat > results-qemu.csv
