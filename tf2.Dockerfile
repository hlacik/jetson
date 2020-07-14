FROM nvcr.io/nvidia/l4t-base:r32.3.1

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
RUN python3 -m pip install --upgrade pip setuptools wheel six \
    && pip3 install numpy h5py pybind11 \
    #
    # Clean up
    && rm -rf ~/.cache

# tensorflow-2.1.0+nv20.3-cp36-cp36m-linux_aarch64.whl
#
ARG JP_VERSION=43
ARG TF_VERSION=2.1.0
ARG NV_VERSION=20.3

RUN pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v$JP_VERSION tensorflow==$TF_VERSION+nv$NV_VERSION \
    #
    # Clean up
    && rm -rf ~/.cache