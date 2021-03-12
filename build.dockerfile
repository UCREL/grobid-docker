## Docker GROBID image. Custom version which downloads the Grobid data from 
## GitHub, does not use any mount points, and does not run as root user.

## Docker GROBID image using CRF models only

# -------------------
# build builder image
# -------------------
FROM openjdk:8u212-jdk as builder

USER root

RUN apt-get update && \
    apt-get -y --no-install-recommends install libxml2 wget unzip

RUN groupadd -r grobid && useradd -r --create-home -g grobid grobid
RUN mkdir -p /opt/grobid-source
RUN chown -R grobid:grobid /opt

USER grobid

WORKDIR /opt/grobid-source

ARG GROBID_VERSION

# gradle and source information
RUN wget -O grobid.zip https://github.com/kermitt2/grobid/archive/${GROBID_VERSION}.zip && \
    unzip grobid.zip && \
    rm grobid.zip && \
    cp -r ./grobid-$GROBID_VERSION/gradle/ ./gradle/ && \
    cp ./grobid-$GROBID_VERSION/gradlew ./ && \
    cp ./grobid-$GROBID_VERSION/gradle.properties ./ && \
    cp ./grobid-$GROBID_VERSION/build.gradle ./ && \
    cp ./grobid-$GROBID_VERSION/settings.gradle ./ && \
    cp -r ./grobid-$GROBID_VERSION/grobid-home/ ./grobid-home/ && \
    cp -r ./grobid-$GROBID_VERSION/grobid-core/ ./grobid-core/ && \
    cp -r ./grobid-$GROBID_VERSION/grobid-service/ ./grobid-service/ && \
    cp -r ./grobid-$GROBID_VERSION/grobid-trainer/ ./grobid-trainer/ && \
    rm -rf grobid-$GROBID_VERSION


RUN sed -i 's/tasks.distZip.enabled = false/tasks.distZip.enabled = true/g' build.gradle
RUN ./gradlew clean assemble --no-daemon  --info --stacktrace && \
    rm -rf /home/grobid/.gradle