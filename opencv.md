# opencv 4.4.0-pre with dnn

## Sources

1. https://www.pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
2. https://github.com/AastaNV/JEP/blob/master/script/install_opencv4.3.0_Jetson.sh

## Cmake parameters

    cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_ENABLE_NONFREE=ON -D WITH_CUDA=ON -D WITH_CUDNN=ON -D OPENCV_DNN_CUDA=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D CUDA_ARCH_BIN=5.3 -D WITH_CUBLAS=1 -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules/ -D BUILD_OPENCV_PYTHON2=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF ..

## Build parameters

    make -j$(nproc)
    checkinstall --default --install=no --backup=no --pkgname=opencv