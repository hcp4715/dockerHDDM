# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# dockerHDDM 1.1.0
# Base: quay.io/jupyter/scipy-notebook:python-3.12 (Ubuntu 24.04, multi-arch: amd64 + arm64)
# Python 3.12, HDDM latest (gitee epool), arviz 0.20.x, pymc2 from gitee epool

FROM quay.io/jupyter/scipy-notebook:python-3.12

ARG PYMC2_REPO=https://gitee.com/epool/pymc2
ARG PYMC2_REF=master

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"
LABEL version="1.1.0"
LABEL description="dockerHDDM: Docker environment for Hierarchical Drift-Diffusion Modeling"

USER root

# Install system build dependencies (gcc, g++, gfortran are needed for pymc2 compilation)
# Ubuntu 24.04 already includes most tools; these ensure the full build chain is present
RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y apt-utils && \
  apt-get install -y build-essential && \
  apt-get install -y gcc && \
  apt-get install -y g++ && \
  apt-get install -y gfortran && \
  apt-get install -y git && \
  apt-get install -y pkg-config && \
  apt-get install -y libopenblas-dev && \
  apt-get install -y liblapack-dev && \
  rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install HDF5/netcdf4 support via conda (needed for HDDM data I/O)
RUN conda install -c conda-forge --quiet --yes \
  'h5py' \
  'hdf5' \
  'netcdf4' \
  && \
  conda clean --all -f -y && \
  fix-permissions "/home/${NB_USER}"

# Upgrade pip first
RUN pip install --upgrade pip

RUN pip install setuptools wheel "numpy>=1.26,<2" scipy

# Install pandas (compatible with Python 3.12)
RUN pip install pandas -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install pymc2 from gitee mirror (core HDDM dependency)
RUN pip install "git+${PYMC2_REPO}@${PYMC2_REF}"

# Install kabuki and ssm-simulators from gitee mirrors (latest master commit)
RUN pip install git+https://gitee.com/epool/kabuki
RUN pip install git+https://gitee.com/epool/ssm-simulators@dockerHDDM_stable -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install HDDM from gitee mirror (latest master commit)
RUN pip install git+https://gitee.com/epool/hddm.git && \
  fix-permissions "/home/${NB_USER}"

# Install arviz 0.20.x
RUN pip install "arviz<0.21" -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install seaborn (latest compatible version)
RUN pip install seaborn -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install PyTorch (CPU-only, compatible with Python 3.12)
RUN pip install torch --index-url https://download.pytorch.org/whl/cpu && \
  fix-permissions "/home/${NB_USER}" && \
  rm -rf ~/.cache/pip

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" &&\
  fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME

# Copy example data and scripts to the example folder
RUN mkdir /home/$NB_USER/OfficialTutorials && \
  rm -r /home/$NB_USER/work && \
  fix-permissions /home/$NB_USER


COPY /dockerHDDM_Quick_View.ipynb /home/$NB_USER
COPY /dockerHDDM_Workflow.ipynb /home/$NB_USER
COPY /OfficialTutorials/HDDM_Basic_Tutorial.ipynb /home/$NB_USER/OfficialTutorials
COPY /OfficialTutorials/HDDM_Regression_Stimcoding.ipynb /home/$NB_USER/OfficialTutorials
COPY /OfficialTutorials/Posterior_Predictive_Checks.ipynb /home/$NB_USER/OfficialTutorials
COPY /OfficialTutorials/LAN_Tutorial.ipynb /home/$NB_USER/OfficialTutorials
