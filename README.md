# grobid-docker

This contains the Docker files to build the [Grobid server](https://github.com/kermitt2/grobid). To build the image that can run the Grobid server use the script:

``` bash
```

This built image can be found on the UCREL Docker hub: []()

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

To run restricting the amount of overall memory Docker will use, in this case 5GB, and the amound of memory the `pdf2xml` tool will use, in this case 4GB, within the Grobid server run the following:

``` bash
docker run --rm --init -p 127.0.0.1:8070:8070 -p 127.0.0.1:8071:8071 --memory=5g --memory-swap=5g --env grobid__3rdparty__pdf2xml__memory__limit__mb=4000 ucrel/grobid:0.6.1
```

## What is Grobid

"A machine learning library for extracting, parsing and re-structuring raw documents such as PDF into structured XML/TEI encoded documents with a particular focus on technical and scientific publications." [taken from the Grobid documentation](https://github.com/kermitt2/grobid)

## Main difference between this and the original Grobid docker image
The Grobid library does have it's own Docker image (found at [https://hub.docker.com/r/lfoppiano/grobid/](https://hub.docker.com/r/lfoppiano/grobid/)) that builds the Grobid server but it runs the Grobid server as a root user. The version within this repository runs the Grobid server as a **non-root/privileged user**.


## Script in detail

The script first complies the Grobid Java code using [build.dockerfile](./build.dockerfile), then the [Dockerfile](./Dockerfile) uses that compiled code, by copying it accross.
