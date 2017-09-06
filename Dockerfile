FROM ubuntu:16.04

MAINTAINER sshuair<sshuair@gmail.com>

# version settings
# ARG PYTHON_VERSION=3.5
# ARG TENSORFLOW_ARCH=cpu
# ARG TENSORFLOW_VERSION=1.2.1
# ARG PYTORCH_VERSION=v0.2
# ARG MXNET_VERISON=latest
# ARG KERAS_VERSION=1.2.0



# install dependencies
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends\ 
        build-essential \
        software-properties-common \
        curl \
        cmake \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        zip \
        unzip \
        git \
        wget \
        vim \
        ca-certificates \
        python3 \
        python3-dev \
        python3-pip \
        ipython3 \
        graphviz \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# install mapnik ，note: mapnik must install before gdal
RUN apt-get update && apt-get --fix-missing install -y python3-mapnik && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



# install gdal  
RUN add-apt-repository -y ppa:ubuntugis/ppa && \ 
    apt update && \ 
    apt-get install -y --no-install-recommends gdal-bin libgdal-dev python3-gdal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install python package
RUN pip3 --no-cache-dir install \
        setuptools

# note: due to pytorch 0.2 rely on numpy 1.13, it's have to upgrade numpy from 1.11.0 to 1.13.1
RUN pip3 --no-cache-dir install --upgrade \
        numpy
RUN pip3 --no-cache-dir install \
        Pillow \
        ipykernel \
        jupyter \
        scipy \
        h5py \
        scikit-image \
        matplotlib \
        pandas \
        scikit-learn \
        sympy \
        shapely \
        bokeh \
        geopandas \
        hyperopt \
        folium \
        ipyleaflet \
        xgboost \
        rasterio \
        progressbar33 \
        opencv-contrib-python \
        && \
    python3 -m ipykernel.kernelspec


# RUN git clone --recursive https://github.com/dmlc/xgboost && \
#     cd xgboost && \
#     make -j4 && \
#     cd python-package && \
#     python3 setup.py install


# install tensorflow and keras
RUN pip3 --no-cache-dir install tensorflow && \
    pip3 --no-cache-dir install keras

# install mxnet
RUN pip3 --no-cache-dir install mxnet  && \
    pip3 --no-cache-dir install graphviz

# install pytorch
RUN pip3 --no-cache-dir install http://download.pytorch.org/whl/cu75/torch-0.2.0.post2-cp35-cp35m-manylinux1_x86_64.whl && \ 
    pip3 --no-cache-dir install torchvision



# TODO: 配置jupyter-Notebook，tensorboard已经可以运行
# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
# COPY notebooks /notebooks

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# TensorBoard
EXPOSE 6006
# jupyter noteboook
EXPOSE 8888

RUN mkdir /workdir

WORKDIR "/workdir"

CMD ["/run_jupyter.sh", "--allow-root" ]
