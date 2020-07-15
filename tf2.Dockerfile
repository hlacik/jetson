FROM nvcr.io/nvidia/l4t-base:r32.4.3

# https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html
#
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install pkg-config python3-pip \
    && apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html
#
RUN python3 -m pip install --upgrade pip setuptools wheel \
    && pip3 install numpy h5py pybind11 \
    #
    # Clean up
    && rm -rf ~/.cache

# protobuf cpp_implementation
#
ARG PROTOBUF_DEB=https://github.com/hlacik/jetson/releases/download/protobuf/protobuf_3.12.3-1_arm64.deb
ARG PROTOBUF_PYTHON=https://github.com/hlacik/jetson/releases/download/protobuf/protobuf-3.12.3-cp36-cp36m-linux_aarch64.whl

RUN wget -q  ${PROTOBUF_DEB} -P /tmp \
    && wget ${PROTOBUF_PYTHON} -q  -P /tmp \
    && dpkg -i /tmp/protobuf_*_arm64.deb \
    && pip3 --no-cache-dir install /tmp/protobuf-*-linux_aarch64.whl \
    && rm /tmp/protobuf_*_arm64.deb /tmp/protobuf-*-linux_aarch64.whl

# tensorflow-2.2.0+nv20.6-cp36-cp36m-linux_aarch64.whl
#
ARG JP_VERSION=44
ARG TF_VERSION=2.2.0
ARG NV_VERSION=20.6

RUN pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v$JP_VERSION tensorflow==$TF_VERSION+nv$NV_VERSION \
    #
    # Clean up
    && rm -rf ~/.cache