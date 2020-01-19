FROM ubuntu:19.04

RUN apt-get update
RUN apt-get install -y build-essential clang curl lld
ENV PATH "$PATH:/usr/lib/llvm-8/bin"
CMD [ "/bin/bash" ]