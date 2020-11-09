# Adapted from: https://github.com/AFLplusplus/AFLplusplus/blob/stable/Dockerfile
FROM ubuntu:20.04 AS aflplusplus
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get -y install --no-install-suggests --no-install-recommends \
    apt-transport-https \
    apt-utils \
    automake \
    bash-completion \
    build-essential \
    bison \
    ca-certificates \
    curl \
    dialog \
    git \
    gnupg \
    gnuplot \
    flex \
    jupp \
    python3 \
    python3-dev \
    python-is-python3 \
    python3-setuptools \
    libglib2.0-dev \
    libpixman-1-dev \
    libtool \
    libtool-bin \
    nano \
    vim \
    wget

RUN echo deb http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main >> /etc/apt/sources.list \
 && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN echo deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu focal main >> /etc/apt/sources.list \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1E9377A2BA9EF27F

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
      gcc-10 g++-10 gcc-10-plugin-dev gcc-10-multilib \
      libc++-10-dev gdb lcov

RUN apt-get install -y \
      clang-11 clang-tools-11 libc++1-11 libc++-11-dev \
      libc++abi1-11 libc++abi-11-dev libclang1-11 libclang-11-dev \
      libclang-common-11-dev libclang-cpp11 libclang-cpp11-dev liblld-11 \
      liblld-11-dev liblldb-11 liblldb-11-dev libllvm11 libomp-11-dev \
      libomp5-11 lld-11 lldb-11 llvm-11 llvm-11-dev llvm-11-runtime llvm-11-tools

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 0
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 0

RUN rm -rf /var/cache/apt/archives/*

ENV LLVM_CONFIG llvm-config-11
ENV AFL_SKIP_CPUFREQ 1

RUN git clone https://github.com/vanhauser-thc/afl-cov /opt/afl-cov \
 && cd /opt/afl-cov \
 && make install

ARG AFL_VERSION=2.68c
RUN git clone https://github.com/AFLplusplus/AFLplusplus /opt/afl++ \
 && cd /opt/afl++ \
 && git checkout "${AFL_VERSION}"

WORKDIR /opt/afl++

RUN export REAL_CXX=g++-10 \
 && export CC=gcc-10 \
 && export CXX=g++-10 \
 && make clean \
 && make distrib \
 && make install \
 && make clean

RUN echo 'export PS1="[afl++]$PS1"' >> ~/.bashrc
ENV IS_DOCKER 1

COPY docker/afl-fuzz-parallel /usr/local/bin

RUN apt-get install -y sudo \
 && useradd --create-home --shell /bin/bash fuzzer \
 && usermod -aG sudo fuzzer \
 && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
 && mkdir /workspace \
 && chmod -R 777 /workspace
USER fuzzer
WORKDIR /workspace
