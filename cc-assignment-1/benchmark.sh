#!/bin/sh

#### CPU speed benchmark ####
# parameters:
#    max-time: maximum time used for benchmark (60 seconds)
#
# --> parse desired output with grep
CPU=$(sysbench --max-time=60 cpu run | grep -oP "events per second:\s*\K\d+\.[0-9][0-9]")

#### Memory access benchmark ####
# parameters:
#    max-time: maximum time used for benchmark (60 seconds)
#    memory-block-size: size of the memory block used (4 KB)
#    memory-total-size: amount of data transferred in total (100 TB)
#
# --> parse desired output with grep
MEM=$(sysbench --max-time=60 memory --memory-block-size=4K --memory-total-size=100T run | grep -oP "transferred \(\s*\K\d+\.[0-9][0-9]")

#### Prepare the file that will be used by the fileio test ####
# parameters:
#    max-time: maximum time used for benchmark (60 seconds)
#    file-num: number of files used (1 file)
#    file-total-size: total size of the file used (1 GB)
DUMP=$(sysbench --max-time=60 fileio prepare --file-num=1 --file-total-size=1G)

#### Fileio benchmark -- sequential read ####
# parameters:
#    max-time: maximum time used for benchmark (60 seconds)
#    file-num: number of files used (1 file)
#    file-total-size: total size of the file used (1 GB)
#    file-test-mode: the type of file I/O to be tested (sequential read)
#    file-extra-flags: additional test setup (here: use direct disk access)
#
# --> parse desired output with grep
SEQ=$(sysbench --max-time=60 fileio run --file-num=1 --file-total-size=1G --file-test-mode=seqrd --file-extra-flags=direct | grep -oP "reads\/s:\s*\K\d+\.[0-9][0-9]")

#### Fileio benchmark -- random read ####
# parameters:
#    max-time: maximum time used for benchmark (60 seconds)
#    file-num: number of files used (1 file)
#    file-total-size: total size of the file used (1 GB)
#    file-test-mode: the type of file I/O to be tested (random read)
#    file-extra-flags: additional test setup (here: use direct disk access)
#
# --> parse desired output with grep
RND=$(sysbench --max-time=60 fileio run --file-num=1 --file-total-size=1G --file-test-mode=rndrd --file-extra-flags=direct | grep -oP "reads\/s:\s*\K\d+\.[0-9][0-9]")

#### Current epoch timestamp ####
DATE=$(date '+%s')

# combine measurements into csv format
OUTPUT="$DATE,$CPU,$MEM,$SEQ,$RND"

# get base directory so that the script can be run from any location [specifically from cron job directory]
BASEDIR=$(dirname $0)

# append measurements to result file
echo $OUTPUT >> "${BASEDIR}/results.csv"
