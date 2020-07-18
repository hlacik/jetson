# opencv 4.4.0-pre with dnn

## Sources

1. https://docs.opencv.org/master/d2/de6/tutorial_py_setup_in_ubuntu.html
2. https://gist.github.com/YashasSamaga/6d37bc403c0934329b078b4bad98c7f2
3. https://www.pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
 
## deps

## cmake

export ARCH_BIN=5.3
cmake \
    -D WITH_CUDA=ON \
    -D CUDA_ARCH_BIN=${ARCH_BIN} \
    -D CUDA_FAST_MATH=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D CPACK_BINARY_DEB=ON \
    ../



## build

make -j$(nproc)
make install -j$(nproc)
make package -j$(nproc)