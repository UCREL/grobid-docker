#!/bin/bash

GROBID_VERSION=0.6.1
docker build -t ucrel/grobid_build:$GROBID_VERSION --build-arg GROBID_VERSION=$GROBID_VERSION -f ./build.dockerfile .
sed "s/\$GROBID_VERSION/$GROBID_VERSION/g" Dockerfile > temp_dockerfile.dockerfile
docker build -t ucrel/grobid:$GROBID_VERSION -f ./temp_dockerfile.dockerfile .
rm ./temp_dockerfile.dockerfile