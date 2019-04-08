# Initial variables
# 1 
ARG UBUNTU_VERSION=18.04
# Nvidia CUDA and Deep Neuronal Networks libraries
# 2
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu${UBUNTU_VERSION} as base
# 3
ENV LANG C.UTF-8

# 4
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3.7-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
    libgoogle-glog-dev libboost-all-dev libcaffe-cuda-dev libhdf5-dev libatlas-base-dev liblapacke-dev

# Numpy stack and opencv for python
# 5 
RUN pip3 install numpy opencv-python

# X Server
# 6
RUN apt-get update && apt-get install -y x11-xserver-utils

# Cmake 3.14 release version
# 7
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.0/cmake-3.14.0-Linux-x86_64.tar.gz && \
    tar xzf cmake-3.14.0-Linux-x86_64.tar.gz -C /opt && \
    rm cmake-3.14.0-Linux-x86_64.tar.gz
# 8 
ENV PATH="/opt/cmake-3.14.0-Linux-x86_64/bin:${PATH}"
RUN apt update && apt install sudo

# 9
ARG USER_ID=1000
# 10
ARG GROUP_ID=1000

# 11
RUN groupadd -g ${GROUP_ID} sim && \
    useradd -m -l -u ${USER_ID} -g sim sim && \
    echo "sim:sim" | chpasswd && adduser sim sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# 12
ENV HOME /home/sim
# 13
ENV SIM_ROOT=$HOME

# Added to video group
# 14
RUN usermod -a -G video sim

# 15
USER sim

# ======================OpenPose===========================
# 16
WORKDIR $HOME
# RUN git clone --recurse-submodules https://github.com/kevinrev26/openpose.git
# COPY openpose openpose

# # RUN chmod -R 700 $HOME/openpose

# # RUN mkdir -p $HOME/openpose/build

# ============
# Friendly reminder: Maybe we need to build osckpack before
# ============

# WORKDIR $HOME/openpose/build
# USER root
# RUN chmod -R 777 $HOME/openpose
# USER sim
# # Building OpenPose
# # 
# RUN cmake -DBUILD_PYTHON=ON .. && make -j`nproc`
# cmake -DBUILD_PYTHON=ON -DCMAKE_BUILD_TYPE=Debug ..
# 17
WORKDIR $HOME/openpose