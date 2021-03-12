# Grobid Docker

Currently works with Grobid version:

* 0.6.1

Each docker tag is associated with the version of Grobid it was built with e.g. `ucrel/grobid:0.6.1` means that it was built with version `0.6.1`


This contains the Docker files to build the [Grobid server](https://github.com/kermitt2/grobid). To build the image that can run the Grobid server use the script:

``` bash
bash make_docker.sh
```

This built image can be found on the UCREL Docker hub: [https://hub.docker.com/repository/docker/ucrel/grobid](https://hub.docker.com/repository/docker/ucrel/grobid)

For details on the script that builds the docker image see the section [script in detail.](#script-in-detail)

For details on the Grobid server API: [https://grobid.readthedocs.io/en/latest/Grobid-service/](https://grobid.readthedocs.io/en/latest/Grobid-service/)

## How to run Grobid server with docker

The Grobid server uses two ports:

1. `8070` -- this is the main port which the server uses as an API to Grobid
2. `8071` -- this is the admin console.

To run with default settings:

``` bash
docker run --rm --init -p 127.0.0.1:8070:8070 -p 127.0.0.1:8071:8071 ucrel/grobid:0.6.1
```

To run restricting the amount of overall memory Docker will use, in this case 5GB, and the amount of memory the `pdf2xml` tool will use, in this case 4GB, within the Grobid server, further we restrict docker to only use at most 4 CPUS run the following:

``` bash
docker run --rm --init -p 127.0.0.1:8070:8070 -p 127.0.0.1:8071:8071 \
           --memory=5g --memory-swap=5g --cpus=4 \
           --env grobid__3rdparty__pdf2xml__memory__limit__mb=4000 \
           ucrel/grobid:0.6.1
```

**Note** use the `--init` flag when running, [helps remove processes when exiting the container.](https://docs.docker.com/config/containers/multi-service_container/)

An example of how to run docker container through `docker-compose` while restricting the amount of overall memory Docker will use, in this case 5GB, and the amount of memory the `pdf2xml` tool will use, in this case 4GB, within the Grobid server, further we restrict docker to only use at most 4 CPUS. This can be seen in the docker-compose file [./docker-compose.yml](./docker-compose.yml) which can be ran with the following command:
``` bash
docker-compose --compatibility up # --compatibility is required so that it restricts the overall docker memory and number of CPUs
crtl +c # Stop docker-compose after it has started
docker-compose down
```

## What is Grobid

"A machine learning library for extracting, parsing and re-structuring raw documents such as PDF into structured XML/TEI encoded documents with a particular focus on technical and scientific publications." [taken from the Grobid documentation](https://github.com/kermitt2/grobid)

## Main difference between this and the original Grobid docker image

The Grobid library does have it's own Docker image (found at [https://hub.docker.com/r/lfoppiano/grobid/](https://hub.docker.com/r/lfoppiano/grobid/)) that builds the Grobid server but it runs the Grobid server as a root user. The version within this repository runs the Grobid server as a **non-root/non-privileged user** and this version is slightly smaller by 0.3GB (original version 1.55GB, this version 1.22GB). The size difference is due to, in part, running as a **non-root/non-privileged user**.

This version also does not have a Volume mounted at (from what I gather this is where the data is temporary stored when Grobid is processing the PDF.):

`/opt/grobid/grobid-home/tmp`

## Script in detail

The script first complies the Grobid Java code using [build.dockerfile](./build.dockerfile), then the [Dockerfile](./Dockerfile) uses that compiled code, by copying it accross.

If you want to use a newer version of Grobid change the `GROBID_VERSION` variable in the script to the release version you want from the [Grobid GitHub page.](https://github.com/kermitt2/grobid) **Note** by changing the `GROBID_VERSION` variable does not mean it will definitely work, it may require some changes. At the moment it currently works with **Grobid version 0.6.1**.

## Acknowledgements

The work has been funded by the [UCREL research centre at Lancaster University](http://ucrel.lancs.ac.uk/).

We would like to thank the developers of Grobid and Grobid's main author [Patrice Lopez.](https://github.com/kermitt2) for creating the [Grobid software.](https://github.com/kermitt2/grobid)