# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# dockerHDDM 1.1.0
# Base: quay.io/jupyter/scipy-notebook:82d322f00937 (Ubuntu 24.04, Python 3.12, multi-arch)
# Python 3.12, HDDM latest, arviz latest, pymc2 from GitHub

ARG JUPYTER_BASE_IMAGE=quay.io/jupyter/scipy-notebook:82d322f00937
FROM ${JUPYTER_BASE_IMAGE}

ARG PYMC2_REPO=https://github.com/panwanke/pymc2.git
ARG PYMC2_REF=master
ARG KABUKI_REPO=https://github.com/panwanke/kabuki.git
ARG KABUKI_REF=master
ARG SSM_SIMULATORS_REPO=https://github.com/panwanke/ssm-simulators.git
ARG SSM_SIMULATORS_REF=dockerHDDM_stable
ARG HDDM_REPO=https://github.com/panwanke/hddm.git
ARG HDDM_REF=master

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"
LABEL version="1.1.0"
LABEL description="dockerHDDM: Docker environment for Hierarchical Drift-Diffusion Modeling"

USER root

# Install system build dependencies (gcc, g++, gfortran are needed for pymc2 compilation)
# Ubuntu 24.04 already includes most tools; these ensure the full build chain is present
RUN apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    gfortran \
    git \
    pkg-config \
    libopenblas-dev \
    liblapack-dev && \
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

RUN pip install setuptools wheel "numpy>=2,<3" scipy "cython>=3,<4"

# Install pandas (compatible with Python 3.12)
RUN pip install pandas -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install the latest arviz release while keeping NumPy within the tested major line
RUN pip install "arviz==1.1.0" "numpy>=2,<3" -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install the maintained Python 3.12 / NumPy 2 compatible forks from GitHub
RUN pip install --no-deps "git+${PYMC2_REPO}@${PYMC2_REF}"

RUN pip install --no-deps "git+${KABUKI_REPO}@${KABUKI_REF}"

RUN pip install --no-deps "git+${SSM_SIMULATORS_REPO}@${SSM_SIMULATORS_REF}" -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip install --no-build-isolation --no-deps "git+${HDDM_REPO}@${HDDM_REF}" && \
  fix-permissions "/home/${NB_USER}"

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
