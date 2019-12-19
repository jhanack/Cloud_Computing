FROM ubuntu:18.04
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

RUN apt-get update
RUN apt-get install -y sysbench
RUN apt-get install -y iperf3
RUN apt-get install -y bc
RUN apt-get install -y make

CMD ["./benchmark.sh"]


