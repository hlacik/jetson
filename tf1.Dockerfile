FROM nvcr.io/nvidia/l4t-base:r32.3.1

# https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html
#
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install build-essential pkg-config python3-dev \
    && apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran \
    && apt-get -y install curl && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py \
    && pip install numpy h5py pybind11 \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf ~/.cache
ENV DEBIAN_FRONTEND=dialog

# tensorflow-1.15.2+nv20.3-cp36-cp36m-linux_aarch64.whl
ARG JP_VERSION=43
ARG TF_VERSION=1.15.2
ARG NV_VERSION=20.3

RUN pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v$JP_VERSION tensorflow==$TF_VERSION+nv$NV_VERSION \
    && rm -rf ~/.cache