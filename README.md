# A HDDM docker image
There a few different images, see hcp4715/hddm/tags.

These three are currently used images:

`latest`: same as `hddm:0.9.8RC`;

`hddm:0.9.8RC`: Python 3.8.8, the latest version of [HDDM 0.9.8](https://hddm.readthedocs.io/en/latest/index.html), fixed a few bugs (credit to Wanke and [zenkavi](https://github.com/zenkavi)), this tag include images, one for machines with amd64 (intel) chips (same as `hddm:0.9.8-amd64`), one for machines with arm64 chips (m1/m2/apple, same as `hddm:0.9.8-arm64`).

`hddm:0.9.8-amd64`: the HDDM 0.9.8 image for machines with amd64 (intel) chips; 

`hddm:0.9.8-arm64`: the HDDM 0.9.8 image for machines with arm64 (m1/m2/apple) chips; 

`hddm:0.8_tutorial`: Python 3.8.8, HDDM 0.8, kabuki 0.6.4, and with functions bridging HDDM model results and `arviz`. For machines with amd64 (intel) chips, with tutorial notebook linked to **Version 6** of the [this preprint](https://psyarxiv.com/6uzga/); 

`hddm:0.8_tutorial_arm64`: Python 3.8.8, HDDM 0.8, kabuki 0.6.4, and with functions bridging HDDM model results and `arviz`. For machines with arm64 (m1/m2/apple) chips, with tutorial notebook linked to **Version 6** of the [this preprint](https://psyarxiv.com/6uzga/); 

`hddm:0.9.8`: Python 3.8.8, the original version of HDDM 0.9.8. No example folder inside this image yet; amd64 only.

`hddm:0.8`: Python 3.8.8, HDDM 0.8, and kabuki 0.6.4. This version is more stable with classic HDDM functions; amd64 only.

These two are historical images, I keep them in case that some one has used it before.

`hddm:arviz`: Python 3.7, HDDM 0.8, kabuki 0.6.4, and testing scripts that aimed at working with arviz.

`hddm:tutorial_alpha`: Python 3.8.8, HDDM 0.8, and kabuki 0.6.4 installed directly from github, also with testing scripts that aimed at working with arviz

## What is HDDM? 
HDDM is a python package for hierarchical drift diffusion modelling, see [here](https://hddm.readthedocs.io/en/latest/index.html) for more. Please note the original HDDM developing team has released an updated version `[HSSM](https://lnccbrown.github.io/HSSM/)`. The purpose of this image is for those who are still using HDDM.

## What's new about this docker image?
This docker image was based on a previous HDDM docker image by Mads ([@madslupe](https://hub.docker.com/r/madslupe/hddm)), with a few improvements. 
* Parallel processing with `p_tqdm` (`pathos` and `tqdm`). 
* With the latest HDDM package.
* A few new python packages that are used for plotting (`seaborn`, `plotly`).
* Python packages for Bayesian inference (`Arviz`).

In the `example` folder of this docker image (see below on how to use this image), you can find jupyter notebooks. Most of them include a jupyter notebook that reproduce the [official tutorial](http://ski.clps.brown.edu/hddm_docs/tutorial.html).

## How to use this docker image
### Installation
First, install docker and test it. There are many tutorials on this.

#### Ubuntu
Please read this [post on docker's website](https://docs.docker.com/engine/install/ubuntu/) for installing docker for linux (ubuntu included).

Then, pull the current docker image from docker hub:

```
docker pull hcp4715/hddm:0.8
```

**Note**: you may need sudo permission to run the command `docker`.

#### Window 10 (pro)
Please read this [post](https://docs.docker.com/docker-for-windows/install/) for installing docker on window 10. During the installation of docker, you might be instructed to install/update your window subsystem linux (WSL), please follow the instruction to finish the installation of docker.

Then, open window power shell, and pull the current docker image from docker hub:

```
docker pull hcp4715/hddm:0.8
```

### Open Jupyter notebook

After pulling it from docker hub, you can then run jupyter notebook in the container (e.g., in bash of linux or power shell of windows):

#### Example code for Ubuntu:
```
docker run -it --rm --cpus=4 \
-v /home/hcp4715/hddm_docker:/home/jovyan/work \
-p 8888:8888 hcp4715/hddm:0.8 jupyter notebook
```

#### Example code for windows:

```
docker run -it --rm --cpus=4 -v /d/hcp4715/hddm_docker:/home/jovyan/work -p 8888:8888 hcp4715/hddm:0.i jupyter notebook  
```

or run docker in the current working direction

```
docker run -it  --rm -v ${PWD}:/home/jovyan/work -p 8888:8888 hcp4715/hddm jupyter notebook
```

#### Explanations of the example code

`docker run` ---- Run a docker image in a container

`-it` ---- Keep STDIN open even if not attached

`--rm` ---- Automatically remove the container when it exits

`--cpus=5` ---- Number of cores will be used by docker

`-v` ---- Mount a folder to the container

`/home/hcp4715/hddm_docker` ---- The directory of a local folder where I stored my data. [For Linux]

`/d/hcp4715/hddm_docker` ---- The directory of a local folder under drive D. It appears as `D:\hcp4715\hddm_docker` in windows system.

`/home/jovyan/work` ---- The directory inside the docker image (the mounting point of the local folder in the docker image). Note that the docker container itself likes a mini virtual linux system, so the file system inside it is linux style. 

`-p` ---- Publish a container’s port(s) to the host

`hcp4715/hddm:0.8` ---- The docker image to run, `0.8` after `:` is the tag of the current docker image.

`jupyter notebook` ---- Open juypter notebook when start running the container.

After running the code above, bash will has output like this:

```
....
....
To access the notebook, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/nbserver-6-open.html
Or copy and paste one of these URLs:
    http://174196acc395:8888/?token=75f1a7a8ffcbb55f0c2802433a9a5d57ac00868e05089c09
 or http://127.0.0.1:8888/?token=75f1a7a8ffcbb55f0c2802433a9a5d57ac00868e05089c09
```

Copy the full url (http://127.0.0.1:8888/?token=.......) to a browser (firefox or chrome) and it will show a web page, this is the interface of jupyter notebook! Note, in Windows system, it might be `localhost` instead of `127.0.0.1` in the url.

Under the `Files` tab, there should be three folders: `work` and `example`. The `work` folder is the local folder mounted in docker container. The `example` folder was the one built in docker image, this folder includes one dataset and one jupyter notebook, you can test the parallel processing by running this jupyter notebook.

Enter `work` folder, you can start your analysis within jupyter notebook.

## Using example
The `example` folder also includes two other jupyter notebooks, `HDDM_official_tutorial_reproduced.ipynb` reproduces the tutorial code, using the `HDDM` in this docker image. 

```
docker run -it --rm --cpus=4 \
-p 8888:8888 hcp4715/hddm:0.8 jupyter notebook
```

## Potential errors
* Permission denied. If you still encounter this error, please see this [post](https://groups.google.com/forum/#!topic/hddm-users/Qh-aOC0N6cU) about the permission problem. 

## How this docker image was built
An alternative way to get the docker image is to build it from `Dockerfile`.

I built this docker image under Ubuntu 20.04. 

This Dockerfile is modified by Dr. Rui Yuan @ Stanford, based on the Dockerfile of [jupyter/scipy-notebook](https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile). We installed additional packages for HDDM and `ipyparallel`, and configured the `ipyparallel` so that we can run it in jupyter noebook (doesn't work for jupyterlab yet). See `Dockerfile` for the details

Code for building the docker image (don't forget the `.` in the end):

```
docker build -t hcp4715/hddm:0.8 -f Dockerfile .
```

## Acknowledgement
Thank [@madslupe](https://github.com/madslupe) for his previous HDDM image, which laid the base for the current version.

Thank [Dr Rui Yuan](https://scholar.google.com/citations?user=h8_wSLkAAAAJ&hl=en) for his help in creating the Dockerfile.

## Report issues
If you have any problem in using this docker image, please report an issue at the [github repo](https://github.com/hcp4715/hddm_docker/issues) 