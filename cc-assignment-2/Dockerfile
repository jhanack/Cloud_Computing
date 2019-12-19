# set OS for container
FROM ubuntu:18.04
# transfer project code to container
COPY . /usr/src/myapp
# set project directory as working directory
WORKDIR /usr/src/myapp

# install required packages via packet manager
RUN apt-get update
RUN apt-get install -y sysbench
RUN apt-get install -y iperf3
RUN apt-get install -y bc
RUN apt-get install -y make

# execute benchmark
CMD ["./benchmark.sh"]
