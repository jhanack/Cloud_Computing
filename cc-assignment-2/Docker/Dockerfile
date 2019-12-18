FROM gcc:4.9
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN gcc -o myapp src/forksum.c
RUN apt-get update
RUN apt-get install sysbench
CMD ["./myapp","100","1000"]
CMD ["chmod +x src/benchmark.sh"]
CMD ["./src/benchmark.sh"]
