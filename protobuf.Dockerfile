FROM nvcr.io/nvidia/l4t-base:r32.3.1 as builder

# https://github.com/protocolbuffers/protobuf/tree/master/python

# Prerequisites and Dependencies
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install build-essential python3-pip checkinstall \
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