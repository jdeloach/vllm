#!/bin/bash

python_executable=python$1
cuda_home=/usr/local/cuda-$2

# Update paths
PATH=${cuda_home}/bin:$PATH
LD_LIBRARY_PATH=${cuda_home}/lib64:$LD_LIBRARY_PATH

# Install requirements
$python_executable -m pip install wheel packaging
$python_executable -m pip install -r requirements-cuda.txt

# Limit the number of parallel jobs to avoid OOM
export MAX_JOBS=16
# Make sure punica is built for the release (for LoRA)
export VLLM_INSTALL_PUNICA_KERNELS=1
# Make sure release wheels are built for the following architectures
export TORCH_CUDA_ARCH_LIST="8.6"
# Build
$python_executable setup.py bdist_wheel --dist-dir=dist
