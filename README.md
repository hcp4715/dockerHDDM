# A HDDM docker image

This is dockerHDDM github repo `hddm:1.1.0`: Python 3.12, HDDM (latest), arviz 0.20.x, and pymc2 from the Gitee epool mirror. This version is compatible for both amd64 and arm64.

> **v1.1.0 Changelog**: Upgraded Python from 3.9 to 3.12, Ubuntu from 22.04 to 24.04, arviz from 0.15.1 to 0.20.x. kabuki/hddm use latest gitee epool commits. pymc2 is installed from the `master` branch of `https://gitee.com/epool/pymc2` and builds without numpy.distutils.

In the `OfficialTutorial` folder, you can look for [official jupyter notebooks from HDDM](http://ski.clps.brown.edu/hddm_docs/tutorial.html) that have been tested and verified to work.

The `dockerHDDM_Quick_View.ipynb` and `dockerHDDM_Workflow.ipynb` are new notebooks using new functions from dockerHDDM (more details see [dockerHDDM paper](https://osf.io/preprints/psyarxiv/6uzga)).

## Report issues

If you have any problem in using this docker image, please report an issue at the [github repo](https://github.com/hcp4715/hddm_docker/issues)

## How to cite us

If you used this docker image in your research, please cite [Wiecki et al 2013](https://www.frontiersin.org/articles/10.3389/fninf.2013.00014/full) and our preprint:

> Pan, W., Geng, H., Zhang, L., Fengler, A., Frank, M. J., Zhang, R.-Y., & Chuan-Peng, H. (2025). dockerHDDM: A user-friendly environment for Bayesian hierarchical drift-diffusion modeling. *Advances in Methods and Practices in Psychological Science*, *8*(1), 25152459241298700. https://doi.org/10.1177/25152459241298700

## How to use this docker image

First, make sure you have successfully installed and started docker. you can find very user-friendly instructions on the [official Docker website](https://docs.docker.com/get-docker/).

Second, pull the docker image from docker hub:

```
docker pull hcp4715/hddm:1.1.0
```

Third, run the docker image with the following command:

```
docker run -it --rm\
-v $(pwd):/home/jovyan/work \
-p 8888:8888 hcp4715/hddm:1.1.0 jupyter notebook
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

## External Resources

### Youtube Video Tutorial

[dockerHDDM installation and usage guide | cognitive modeling | RT modeling | tutorial](https://www.youtube.com/watch?v=ZU1fbXEuP8s)

### Bilibili Video Tutorial

[dockerHDDM安装和使用介绍视频](https://www.bilibili.com/video/BV1u28Ye1ERw/)


## How this docker image was built

We also provide a `Dockerfile` at root path to build the customized docker image.

**v1.1.0** is built on Ubuntu 24.04 (Python 3.12), based on the reproducible Jupyter Docker Stacks image [`quay.io/jupyter/scipy-notebook:82d322f00937`](https://github.com/jupyter/docker-stacks#using-old-images). This Dockerfile was originally created by Dr. Rui Yuan @ Stanford and has been maintained and upgraded by the dockerHDDM team. See `Dockerfile` for the details.

Code for building the docker image (don't forget the `.` in the end):

```
docker build -t [username]/hddm:[tag] -f Dockerfile .
```

* [username] is your username on Docker Hub.
* [tag] is docker images tag, e.g., `latest` or `1.1.0`.

### Test the Docker build with GitHub Actions

Open the repository's `Actions` page, select `dockerHDDM CI (Build & Publish)`,
and run the workflow manually with `publish` set to `false`. The workflow builds
an amd64 image without publishing it, then verifies that `pymc`, `kabuki`, and
`hddm` import successfully.

Set `publish` to `true` only when the validation build passes and you want to
publish the amd64 and arm64 images to Docker Hub.

## Acknowledgement

Thank [@madslupe](https://github.com/madslupe) for his previous HDDM image, which laid the base for the current version.

Thank [Dr Rui Yuan](https://scholar.google.com/citations?user=h8_wSLkAAAAJ&hl=en) for his help in creating the Dockerfile.

We would like to express our gratitude to the HDDM package for providing the dataset `cavanagh_theta_nn.csv` as an example in our study. Please note that this dataset is not owned by us and is used for illustrative purposes only. For reference, the dataset can be found at [HDDM GitHub repository](https://github.com/hddm-devs/hddm/blob/master/hddm/examples/cavanagh_theta_nn.csv).
