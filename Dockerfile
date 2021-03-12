## Docker GROBID image. Custom version which downloads the Grobid data from 
## GitHub, does not use any mount points, and does not run as root user.

## Docker GROBID image using CRF models only

# -------------------
# build runtime image
# -------------------
FROM openjdk:8u212-jre-slim

RUN apt-get update && \
    apt-get -y --no-install-recommends install libxml2 unzip wget

RUN groupadd -r grobid && useradd -r -g grobid grobid
RUN mkdir -p /opt
RUN chown -R grobid:grobid /opt
USER grobid

RUN mkdir -p /opt/grobid
WORKDIR /opt

COPY --from=ucrel/grobid_build:$GROBID_VERSION --chown=grobid:grobid /opt/grobid-source/grobid-core/build/libs/grobid-core-*-onejar.jar ./grobid/grobid-core-onejar.jar
COPY --from=ucrel/grobid_build:$GROBID_VERSION --chown=grobid:grobid /opt/grobid-source/grobid-service/build/distributions/grobid-service-*.zip ./grobid-service.zip
COPY --from=ucrel/grobid_build:$GROBID_VERSION --chown=grobid:grobid /opt/grobid-source/grobid-home/build/distributions/grobid-home-*.zip ./grobid-home.zip

RUN unzip -o ./grobid-service.zip -d ./grobid && \
    mv ./grobid/grobid-service-* ./grobid/grobid-service

RUN unzip ./grobid-home.zip -d ./grobid && \
    mkdir -p ./grobid/grobid-home/tmp

RUN rm *.zip

WORKDIR /opt/grobid

ENV JAVA_OPTS=-Xmx4g

# Add Tini
ENV TINI_VERSION v0.18.0
RUN wget -O /opt/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini
RUN chmod +x /opt/tini

ENTRYPOINT ["/opt/tini", "-s", "--"]
EXPOSE 8070 8071

CMD ["./grobid-service/bin/grobid-service", "server", "grobid-service/config/config.yaml"]

LABEL \
    authors="The contributors" \
    org.label-schema.name="GROBID" \
    org.label-schema.description="Image with GROBID service" \
    org.label-schema.url="https://github.com/kermitt2/grobid" \
    org.label-schema.version=$GROBID_VERSION