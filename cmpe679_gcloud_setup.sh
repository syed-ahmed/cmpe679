#!/bin/bash
NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list

echo "Checking for CUDA and installing."
# Check for CUDA and try to install.
if ! dpkg-query -W cuda-9-0; then
  # The 16.04 installer works with 16.10.
  curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
  dpkg -i ./cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
  apt-get update
  apt-get install cuda-9-0 -y
fi
# Enable persistence mode
nvidia-smi -pm 1

echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf
echo "PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}" >> ~/.bashrc
echo "LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64" >> ~/.bashrc

echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list
export CUDNN_VERSION=7.0.5.15

apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda9.0 \
            libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0 && \
    rm -rf /var/lib/apt/lists/*

#install frameworks
apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        graphviz \
        language-pack-en \
        libcurl4-openssl-dev \
        libffi-dev \
        libsqlite3-dev \
        libzmq3-dev \
        libfreetype6-dev \
        libpng12-dev \
        pandoc \
        python3 \
        python3-dev \
        pkg-config \
        vim \
	    wget \
        sqlite3 \
        rsync \
        software-properties-common \
        unzip \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    pip3 --no-cache-dir install requests[security] && \
    rm -rf /root/.cache

pip3 --no-cache-dir install \
        Cython \
        Jinja2 \
        MarkupSafe \
        Pillow \
        Pygments \
        appnope \
        argparse \
        backports-abc \
        backports.ssl-match-hostname \
        certifi \
        cycler \
        decorator \
        future \
        gnureadline \
        h5py \
        ipykernel \
        ipython-genutils \
        ipywidgets \
        jsonschema \
        jupyter \
        jupyter-client \
        jupyter-console \
        jupyter-core \
        matplotlib \
        mistune \
        nbconvert \
        nbformat \
        nltk \
        notebook \
        numpy \
        path.py \
        pexpect \
        pickleshare \
        ptyprocess \
        pyparsing \
        python-dateutil \
        pytz \
        pyzmq \
        qtconsole \
        scipy \
        simplegeneric \
        singledispatch \
        six \
        terminado \
        tornado \
        traitlets \
        h5py \
        scikit-learn \
        && \
        python3 -m ipykernel.kernelspec && \
        rm -rf /root/.cache

# install caffe2
apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        cmake \
        libgflags-dev \
        libgtest-dev \
        libiomp-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libopenmpi-dev \
        libsnappy-dev \
        openmpi-bin \
        openmpi-doc \
        libgoogle-glog-dev \
        libprotobuf-dev \
        protobuf-compiler && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

pip3 install --no-cache-dir --upgrade pip setuptools wheel

pip3 --no-cache-dir install \
        hypothesis \
        flask \
        pydot \
        python-nvd3 \
        pyyaml \
        requests \
        scikit-image \
        protobuf && \
        rm -rf /root/.cache

git clone --branch master --recursive https://github.com/caffe2/caffe2.git
cd caffe2 && mkdir build && cd build \
    && cmake .. \
    -DCUDA_ARCH_NAME=Manual \
    -DCUDA_ARCH_BIN="35 52 60 61" \
    -DCUDA_ARCH_PTX="61" \
    -DUSE_NNPACK=OFF \
    -DUSE_ROCKSDB=OFF \
    -DUSE_NNPACK=OFF \
    -DUSE_ROCKSDB=OFF \
    -DPYTHON_EXECUTABLE=$(which python3) \
    -DPYTHON_INCLUDE_DIR=$(python3 -c 'from distutils import sysconfig; print(sysconfig.get_python_inc())') \
    && make -j"$(nproc)" install \
    && ldconfig \
    && make clean \
    && cd .. \
    && rm -rf build \
    && cd ..

PYTHONPATH=/usr/local:$PYTHONPATH

# install caffe
apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        libatlas-base-dev \
        libboost-all-dev \
        libhdf5-serial-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

git clone https://github.com/opencv/opencv && \
    cd opencv && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd ../../

CAFFE_ROOT=$HOME/caffe

git clone -b 1.0 --depth 1 https://github.com/BVLC/caffe.git && cd caffe && \
    git clone https://github.com/NVIDIA/nccl.git && cd nccl && make -j install && cd .. && rm -rf nccl && \
    pip3 install --upgrade pip && \
    cd python && for req in $(cat requirements.txt) pydot; do pip3 install $req; done && cd .. && \
    mkdir build && cd build && \
    cmake \
        -DUSE_CUDNN=1 \
        -DUSE_NCCL=1 \
        -Dpython_version=3 .. && \
    make -j"$(nproc)" && \
    cd ../../

PYCAFFE_ROOT=$CAFFE_ROOT/python
PYTHONPATH=$PYCAFFE_ROOT:$PYTHONPATH
PATH=$CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
echo "PATH=${PATH}" >> ~/.bashrc
echo "PYTHONPATH=${PYTHONPATH}" >> ~/.bashrc

echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
pip3 --no-cache-dir install python-dateutil --upgrade

# install tensorflow
pip3 --no-cache-dir install tensorflow-gpu

# install pytorch
pip3 install http://download.pytorch.org/whl/cu90/torch-0.3.0.post4-cp35-cp35m-linux_x86_64.whl 
pip3 install torchvision

source ~/.bashrc
