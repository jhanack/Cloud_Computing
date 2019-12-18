#!/bin/bash

# Record the Unix timestamp before starting the benchmarks.
time=$(date +%s)
runtime=5

# make c programm
discard=$(make forksum)

# Calculate time to run
end=$((SECONDS+runtime))

num_executions=0

while [ $SECONDS -lt $end ]; do
	threads=$(./forksum 100 6000)
	num_executions=$(($num_executions + 1))
done

echo "$num_executions"



# Run the sysbench CPU test and extract the "events per second" line.
1>&2 echo "Running CPU test..."
cpu=$(sysbench --time=$runtime cpu run | grep "events per second" | awk '/ [0-9.]*$/{print $NF}')

# Run the sysbench memory test and extract the "transferred" line. Set large total memory size so the benchmark does not end prematurely.
1>&2 echo "Running memory test..."
mem=$(sysbench --time=$runtime --memory-block-size=4K --memory-total-size=100T memory run | grep transferred | awk '/([0-9.]* MiB.sec)/{print $1}')

# Prepare one file (1GB) for the disk benchmarks
1>&2 sysbench --file-total-size=1G --file-num=1 fileio prepare

# Run the sysbench sequential disk benchmark on the prepared file. Use the direct disk access flag. Extract the number of read MiB.
1>&2 echo "Running fileio sequential read test..."
diskSeq=$(sysbench --time=$runtime --file-test-mode=seqrd --file-total-size=1G --file-num=1 --file-extra-flags=direct fileio run | grep "read, MiB" | awk '/ [0-9.]*$/{print $NF}')

# Run the sysbench random access disk benchmark on the prepared file. Use the direct disk access flag. Extract the number of read MiB.
1>&2 echo "Running fileio random read test..."
diskRand=$(sysbench --time=$runtime --file-test-mode=rndrd --file-total-size=1G --file-num=1 --file-extra-flags=direct fileio run | grep "read, MiB" | awk '/ [0-9.]*$/{print $NF}')

# test network performance with iperf3 and extract desired KPI via grep
# PARAMETERS:
#    -c 35.223.83.97: client side iperf connecting to specified server IP
#    -t 60: run benchmark for 60 seconds
#    -4: use IPv4 only
#    -P 5: use 5 parallel connections
netUplink=$(iperf3 -c 35.223.83.97 -t 60 -4 -P 5 | grep -oP '\[SUM\].*?[0-9]+\.[0-9]+ Mbits\/sec.*?sender' | grep -oP '[0-9]+\.[0-9]+ Mbits' | grep -oP '[0-9]+\.[0-9]+')

# Output the benchmark results as one CSV line
echo "$time,$cpu,$mem,$diskSeq,$diskRand,$netUplink"
