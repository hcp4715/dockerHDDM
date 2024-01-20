# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# This Dockerfile is for DDM tutorial
# The buid from the base of scipy-notebook, based on python 3.8

FROM jupyter/scipy-notebook:python-3.8

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y build-essential&& \
  apt-get install -y gfortran && \
  rm -rf /var/lib/apt/lists/*

USER $NB_UID


RUN pip install --upgrade pip
RUN pip install numpy==1.22.4 -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install pandas==2.0.1 -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install git+https://gitee.com/epool/pymc2
RUN pip install git+https://gitee.com/epool/kabuki 
RUN pip install git+https://gitee.com/epool/hddm.git@0.8.0 && \
  fix-permissions "/home/${NB_USER}"
# Import matplotlib the first time to build the font cache.
RUN pip install seaborn==0.13.1 -i https://pypi.tuna.tsinghua.edu.cn/simple

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