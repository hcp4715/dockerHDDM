# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# This Dockerfile is for DDM tutorial
# The buid from the base of scipy-notebook, based on python 3.8

ARG BASE_CONTAINER=jupyter/scipy-notebook:x86_64-python-3.8
FROM $BASE_CONTAINER

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential gcc gfortran && \
    apt-get install -y --no-install-recommends apt-utils ffmpeg dvipng && \
    rm -rf /var/lib/apt/lists/*

# RUN apt-get install -y python3.10 python3.10-dev python3.10-distutils
# RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
#     python3 get-pip.py

# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
#     update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3 1 && \
#     update-alternatives --config python3

USER $NB_UID

RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
# Install Python 3 packages
RUN conda install --quiet --yes \
    # 'python-graphviz' \
    'mkl-service' \
    'numpy=1.22.*' \
    'pandas=2.0.1' \ 
    'pymc=2.3.8' \
    'arviz=0.14.0' \
    && \
    conda clean --all -f -y && \
    fix-permissions "/home/${NB_USER}"

# uinstall pymc 5 to avoid conflict:
RUN pip uninstall --no-cache-dir pandas numpy -y && \
    fix-permissions "/home/${NB_USER}"

USER $NB_UID
RUN pip install --upgrade pip && \
    pip install --no-cache-dir 'plotly==4.14.3' \
    'cufflinks==0.17.3' \
    # install ptitprince for raincloud plot in python
    'ptitprince==0.2.*' \
    'multiprocess==0.70.12.2' \
    'pathos==0.2.8' \
    'p_tqdm' \
    # install paranoid-scientist for pyddm
    'paranoid-scientist' \
    'pyddm' && \
    # install bambi:  incompatible with numpy 1.22.0
    # 'pymc3==3.11.*' \
    # 'bambi==0.8.*' && \
    # 'arviz==0.14.0' \ 
    # 'numpy==1.21.*' &&\ 
    # pip install --no-cache-dir git+https://gitee.com/epool/pymc2.git && \
    pip install --no-cache-dir git+https://gitee.com/epool/kabuki.git && \ 
    pip install --no-cache-dir git+https://gitee.com/epool/ssm-simulators.git && \ 
    pip install --no-cache-dir git+https://gitee.com/epool/hddm.git && \
    pip install 'arviz==0.14.0' 'numpy==1.22.*' && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" &&\
    fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME

# Copy example data and scripts to the example folder
RUN mkdir /home/$NB_USER/scripts && \
    mkdir /home/$NB_USER/example && \
    rm -r /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

COPY /temp/HDDM_official_tutorial_reproduced.ipynb /home/${NB_USER}/example
COPY /temp/RLHDDMtutorial_reproduced.ipynb /home/${NB_USER}/example
COPY /scripts/HDDMarviz.py /home/${NB_USER}/scripts
COPY /scripts/plot_ppc_by_cond.py /home/${NB_USER}/scripts
COPY /scripts/pointwise_loglik_gen.py /home/${NB_USER}/scripts
COPY /scripts/post_pred_gen_redefined.py /home/${NB_USER}/scripts
COPY /scripts/InferenceDataFromHDDM.py /home/${NB_USER}/scripts
COPY /tutorial/dockerHDDM_tutorial.ipynb /home/${NB_USER}/example
COPY /tutorial/dockerHDDM_kabukiRC.ipynb /home/${NB_USER}/example
COPY /tutorial/Run_all_models.py /home/${NB_USER}/example
COPY /tutorial/Def_Models.py /home/${NB_USER}/example

