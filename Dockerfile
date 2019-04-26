# Base Ubuntu 
ARG UBUNTU_VERSION=18.04
# Nvidia CUDA and Deep Neuronal Networks libraries
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu${UBUNTU_VERSION} as base
# For Building on Python and related
ENV LANG C.UTF-8

# Development dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3.7-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
    libgoogle-glog-dev libboost-all-dev libcaffe-cuda-dev libhdf5-dev libatlas-base-dev liblapacke-dev

# Numpy stack and opencv for python
RUN pip3 install numpy opencv-python

# X Server and related
RUN apt-get update && apt-get install -y x11-xserver-utils

# Cmake 3.14 release version
# This is because current repo version of cmake generates problems
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz && \
    tar xzf cmake-3.14.0-Linux-x86_64.tar.gz -C /opt && \
    rm cmake-3.14.0-Linux-x86_64.tar.gz

# Include the new cmake to the path env 
ENV PATH="/opt/cmake-3.14.0-Linux-x86_64/bin:${PATH}"
RUN apt update && apt install sudo

ARG USER_ID=1000
ARG GROUP_ID=1000

# Creates sim user and add to sudoers file
RUN groupadd -g ${GROUP_ID} sim && \
    useradd -m -l -u ${USER_ID} -g sim sim && \
    echo "sim:sim" | chpasswd && adduser sim sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


ENV HOME /home/sim
ENV SIM_ROOT=$HOME

# Added to video group
RUN usermod -a -G video sim
USER sim

# ======================OpenPose===========================
WORKDIR $HOME
# Cloning the repo, this includes osc 3rdparty library and simbotic.cpp demo
RUN git clone --recurse-submodules https://github.com/kevinrev26/openpose.git
# Creating building directory
RUN mkdir -p $HOME/openpose/build

# Compiling OSCPack Library
WORKDIR $HOME/openpose/3rdparty/oscpack
RUN cmake -G "Unix Makefiles"
RUN make

# Compiling openpose
WORKDIR $HOME/openpose/build
# # Building OpenPose
RUN cmake -DBUILD_PYTHON=ON .. && make -j`nproc`
WORKDIR $HOME/openpose