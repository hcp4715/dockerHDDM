# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

## This is a docker image built for research purpose
## By Dr. Hu Chuan-Peng, Nanjing Normal University, Nanjing, China.

## In this version, jupyter lab and jupyter have higher version:
# jupyterlab - 3.0.14
# jupyter_client - 6.1.12
# jupyter_core - 4.7.1
## Which means that some extension for plotting in jupyter should be upgraded too:
# ipympl >= 0.8
# matplotlib >= 3.3.1
# ipywidgets >= 0.76
# jupyter_widget *
#  
## Also note, I removed ipyparallel and used p_tqdm for parallel processing

ARG BASE_CONTAINER=jupyter/minimal-notebook:python-3.8
FROM $BASE_CONTAINER

LABEL maintainer="Hu Chuan-Peng <hcp4715@hotmail.com>"

USER root

# ffmpeg for matplotlib anim & dvipng for latex labels
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends ffmpeg dvipng && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Install Python 3 packages
RUN conda install --quiet --yes \
    'arviz=0.11.4' \
    'beautifulsoup4=4.9.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=2.4.*' \
    'bottleneck=1.3.*' \
    'cloudpickle=2.1.*' \
    'cython=0.29.*' \
    'dask=2.15.*' \
    'dill=0.3.*' \
    'h5py=2.10.*' \
    'hdf5=1.10.*' \
    'ipywidgets' \
    'ipympl*' \
    'jupyter_bokeh' \
    'jupyterlab_widgets' \
    'matplotlib-base=3.5.*' \
    'numba=0.55.*' \
    'numexpr=2.7.*' \
    # changed to 1.22.4 for hddm 0.9.8
    'numpy=1.22.4' \
    'pandas=1.0.5' \
    'patsy=0.5.*' \
    'protobuf=3.11.*' \
    'pytables=3.6.*' \
    'scikit-image=0.16.*' \
    'scikit-learn=1.1.*' \
    'scipy=1.7.3' \
    'seaborn=0.11.*' \
    'sqlalchemy=1.3.*' \
    'statsmodels=0.13.*' \
    'sympy=1.5.*' \
    'vincent=0.4.*' \
    'widgetsnbextension=3.5.*'\
    'xlrd=1.2.*' \
    'pymc=2.3.8' \
    'git' \
    'mkl-service' \
    && \
    conda clean --all -f -y && \
    fix-permissions "/home/${NB_USER}"
    
USER $NB_UID
RUN pip install --upgrade pip && \
    # update pillow for compatibility
    pip install --no-cache-dir 'pillow==8.4' && \
    # install these two for torch 1.7.0
    pip install --no-cache-dir 'dataclasses' && \
    pip install --no-cache-dir 'future==0.18.2' && \
    # install plotly and its chart studio extension
    pip install --no-cache-dir 'chart_studio==1.1.0' && \
    pip install --no-cache-dir 'plotly==4.14.3' && \
    pip install --no-cache-dir 'cufflinks==0.17.3' && \
    # install ptitprince for raincloud plot in python
    pip install --no-cache-dir 'ptitprince==0.2.*' && \
    pip install --no-cache-dir 'p_tqdm' && \
    fix-permissions "/home/${NB_USER}"

# install kabuki and hddm from Github
RUN pip install --no-cache-dir git+https://github.com/AlexanderFengler/ssms@main  && \
    pip install --no-cache-dir git+https://github.com/hddm-devs/kabuki && \
    pip install --no-cache-dir git+https://github.com/hddm-devs/hddm && \
    fix-permissions "/home/${NB_USER}"

# Install pymc3 and bambi are not compitable with numpy 1.22.4, removed from this docker image
# RUN pip install --no-cache-dir 'pymc3==3.11.*' && \
#     # can not use bambi 0.9 because it require pymc4
#     # pip install --no-cache-dir 'bambi==0.8.*' && \
#     pip install --no-cache-dir 'paranoid-scientist' && \
#     pip install --no-cache-dir 'pyddm' && \
#     fix-permissions "/home/${NB_USER}"

# Install PyTorch, CPU-only
RUN conda install -c pytorch --quiet --yes \
    'pytorch=1.7.0' \
    'torchvision=0.8.0' \
    'torchaudio=0.7.0' \
    'cpuonly' \
    && \
    conda clean --all -f -y && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" &&\
     fix-permissions "/home/${NB_USER}"

USER $NB_UID
WORKDIR $HOME
	
# # Create a folder for example
# RUN mkdir /home/$NB_USER/example && \
#    fix-permissions /home/$NB_USER

# # Copy example data and scripts to the example folder
# COPY /example/HDDM_official_tutorial_reproduced.ipynb /home/${NB_USER}/example
# COPY /example/LAN_Tutorial_reproduced.ipynb /home/${NB_USER}/example