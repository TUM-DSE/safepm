FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies for PMDK
RUN apt-get update && apt-get -qq install -y \
    autoconf \
    automake \
    pkg-config \
    libndctl-dev \
    libdaxctl-dev \
    libglib2.0-dev \
    libncurses5-dev \
    libfuse-dev \
    libuv1-dev \
    pandoc \
    libfabric-dev \
    # Dependencies to compile PMDK
    git \
    build-essential \
    # Install dependencies for memkind
    libnuma-dev \
    libtool \
    numactl \
    unzip \
    # Install dependencies for libpmemobj-cpp
    cmake \
    # Install dependencies for pmemkv
    libtbb-dev

# Add the shared library path
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Install PMDK
WORKDIR /
RUN git clone https://github.com/TUM-DSE/safepm-pmdk.git /pmdk_safepm -b pmasan-1.9.2
WORKDIR /pmdk_safepm
RUN make DEBUG=1 -j7

COPY . /safepm-bench-scripts
WORKDIR /pmdk_safepm/src/benchmarks
RUN /safepm-bench-scripts/change_pmembench_bugs_file_path.sh
WORKDIR /safepm-bench-scripts

# Necessary to mount the device and use full potential
#ENTRYPOINT mkdir /mnt/pmem0 && mount -o dax /dev/pmem0 /mnt/pmem0  && /bin/bash
