FROM nvcr.io/nvidia/l4t-base:r32.3.1 as builder

# https://github.com/protocolbuffers/protobuf/tree/master/python

# Prerequisites and Dependencies
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install curl unzip build-essential python3-pip checkinstall \
    && pip3 --no-cache-dir install Cython \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ARG PB_VERSION=3.12.3

WORKDIR /usr/local/src

# Download & Install protoc
RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v$PB_VERSION/protoc-$PB_VERSION-linux-aarch_64.zip -o protoc.zip \
    && unzip protoc.zip -d protoc \
    && rm protoc.zip \
    && cp ./protoc/bin/protoc /usr/local/bin/protoc \
    && rm -rf ./protoc

# Download protobuf-python
RUN curl -L https://github.com/protocolbuffers/protobuf/releases/download/v$PB_VERSION/protobuf-python-$PB_VERSION.zip -o protobuf-python.zip \
    && unzip protobuf-python.zip \
    && rm protobuf-python.zip \
    && mv protobuf-$PB_VERSION protobuf

WORKDIR /usr/local/src/protobuf

# Make & Install protobuf
RUN ./configure \
    && make \
    && make install \
    && ldconfig \
    && checkinstall --default --install=no --backup=no --pkgversion=$PB_VERSION

WORKDIR /usr/local/src/protobuf/python

# Make protobuf-python
RUN python3 setup.py build --cpp_implementation \
    && python3 setup.py bdist_wheel -d ./ --cpp_implementation

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
RUN python3 -m pip install --upgrade pip setuptools wheel \
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

# protobuf cpp_implementation
#
COPY --from=builder /usr/local/src/protobuf/protobuf_*_arm64.deb /tmp/.
COPY --from=builder /usr/local/src/protobuf/python/protobuf-*-linux_aarch64.whl /tmp/.

RUN && dpkg -i /tmp/protobuf_*_arm64.deb \
    && pip3 --no-cache-dir install /tmp/protobuf-*-linux_aarch64.whl \
    && rm /tmp/protobuf_*_arm64.deb /tmp/protobuf-*-linux_aarch64.whl