# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# This Dockerfile is for DDM tutorial
# The buid from the base of scipy-notebook, based on python 3.8

FROM jupyter/scipy-notebook:python-3.8

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y apt-utils && \
  apt-get install -y build-essential&& \
  apt-get install -y gcc && \
  apt-get install -y g++ && \
  apt-get install -y gfortran && \
  rm -rf /var/lib/apt/lists/*

USER $NB_UID

# conda install -c conda-forge python-graphviz
RUN conda install -c conda-forge --quiet --yes \
  'h5py' \
  'hdf5' \
  'netcdf4' \
  && \
  conda clean --all -f -y && \
  fix-permissions "/home/${NB_USER}"

RUN pip install --upgrade pip
RUN  pip install 'pandas==2.0.1'  -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install git+https://gitee.com/epool/pymc2
RUN pip install git+https://gitee.com/epool/kabuki 
RUN pip install git+https://gitee.com/epool/ssm-simulators -i https://pypi.tuna.tsinghua.edu.cn/simple 
RUN pip install git+https://gitee.com/epool/hddm.git && \
  fix-permissions "/home/${NB_USER}"

RUN pip install git+https://github.com/arviz-devs/arviz.git@2c50144d0b804078a6deebc7a861e583fe8d40c6
RUN pip install torch==1.9.0 -i https://pypi.tuna.tsinghua.edu.cn/simple && \
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