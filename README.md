# A HDDM docker image

This is dockerHDDM github repo `hddm:1.0.1`: Python 3.9, HDDM 1.0.1. This version is a more versatile version compatible for both amd64 and arm64.

In the `OfficialTutorial` folder, you can look for [official jupyter notebooks from HDDM](http://ski.clps.brown.edu/hddm_docs/tutorial.html) that have been tested and verified to work.

The `dockerHDDM_Quick_View.ipynb` and `dockerHDDM_Workflow.ipynb` are new notebooks using new functions from dockerHDDM (more details see [dockerHDDM paper](https://osf.io/preprints/psyarxiv/6uzga)).

## Report issues

If you have any problem in using this docker image, please report an issue at the [github repo](https://github.com/hcp4715/hddm_docker/issues)

## How to cite us

If you used this docker image in your research, please cite [Wiecki et al 2013](https://www.frontiersin.org/articles/10.3389/fninf.2013.00014/full) and our preprint:

> Pan, W., Geng, H., Zhang, L., Fengler, A., Frank, M., ZHANG, R., & Chuan-Peng, H. (2022, November 1). dockerHDDM: A user-friendly environment for Bayesian Hierarchical Drift-Diffusion Modeling. https://doi.org/10.31234/osf.io/6uzga

## How to use this docker image

First, make sure you have successfully installed and started docker. you can find very user-friendly instructions on the [official Docker website](https://docs.docker.com/get-docker/).

Second, pull the docker image from docker hub:

```
docker pull hcp4715/hddm:1.0.1
```

Third, run the docker image with the following command:

```
docker run -it --rm\
-v $(pwd):/home/jovyan/work \
-p 8888:8888 hcp4715/hddm:1.0.1 jupyter notebook
```

- `-v $(pwd):/home/jovyan/work` allows you to mount the current working directory to the docker container.
- you can change the `$(pwd)` to any directory (e.g., "D:/hddm" in Windows) you want to mount to the docker container.
- Note, for Windows users, `$(pwd)` only work in Powershell other than cmd.exe.

Finally, open your browser and go to the following URL （After running the code above, bash will has output like this）:

```
....
....
To access the notebook, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/nbserver-6-open.html
Or copy and paste one of these URLs:
    http://174196acc395:8888/?token=75f1a7a8ffcbb55f0c2802433a9a5d57ac00868e05089c09
 or http://127.0.0.1:8888/?token=75f1a7a8ffcbb55f0c2802433a9a5d57ac00868e05089c09
```

- Copy the full url (http://127.0.0.1:8888/?token=.......) to a browser (firefox or chrome) and it will show a web page, this is the interface of jupyter notebook! Note, in Windows system, it might be `localhost` instead of `127.0.0.1` in the url.
- The jupyter notebooks (e.g., `dockerHDDM_Workflow.ipynb`) mentioned above also exists in the Jupyter interface.

## How this docker image was built

We also provide a `Dockerfile` at root path to build the customized docker image.

We built this docker image under Ubuntu 22.04. This Dockerfile is modified by Dr. Rui Yuan @ Stanford, based on the Dockerfile of [jupyter/scipy-notebook](https://hub.docker.com/r/jupyter/scipy-notebook/dockerfile). We installed additional packages for HDDM. See `Dockerfile` for the details

Code for building the docker image (don't forget the `.` in the end):

```
docker build -t [username]/hddm:[tag] -f Dockerfile .
```

* [username] is your username on Docker Hub.
* [tag] is docker images tag, e.g., `latest` or `1.0.1`.

## Acknowledgement

Thank [@madslupe](https://github.com/madslupe) for his previous HDDM image, which laid the base for the current version.

Thank [Wanke Pan](https://github.com/panwanke/), [Dr Rui Yuan](https://scholar.google.com/citations?user=h8_wSLkAAAAJ&hl=en) for his help in creating the Dockerfile.
