#
# VERSION 0.1
# DOCKER-VERSION  23.0.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ibba.cnr.it>
# DESCRIPTION:    beagle docker container
# TO_BUILD:       docker build --rm -t bunop/beagle:latest .
# TO_RUN:         docker run -ti --rm bunop/beagle:latest /bin/bash
# TO_TAG:         docker tag bunop/beagle:latest bunop/beagle:0.1
#

FROM debian:11-slim

ARG BEAGLE_VERSION="22Jul22.46e.jar"
ARG UPSTREAM_VERSION="5.4"

# MAINTAINER is deprecated. Use LABEL instead
LABEL maintainer="paolo.cozzi@ibba.cnr.it"

LABEL software="beagle" \
    base_image="debian:11-slim" \
    container="beagle" \
    about.summary="Genotype calling, genotype phasing and imputation of ungenotyped markers" \
    about.home="https://faculty.washington.edu/browning/beagle/beagle.html" \
    software.version="${BEAGLE_VERSION}" \
    upstream.version="${UPSTREAM_VERSION}" \
    extra.identifiers.biotools="beagle" \
    about.copyright="2013-2022 Brian L. Browning" \
    about.license="GPL-3+" \
    about.license_file="http://faculty.washington.edu/browning/beagle/gpl_license" \
    extra.binaries="/usr/local/bin/beagle, /opt/beagle.${BEAGLE_VERSION}/beagle" \
    about.tags="field::biology, field::biology:bioinformatics, implemented-in::java,:commandline, role::program, use::analysing"

USER root
ENV DEBIAN_FRONTEND noninteractive
ENV BEAGLE_VERSION ${BEAGLE_VERSION}
RUN apt-get update && \
    apt-get install -y openjdk-17-jre && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /opt/beagle.${BEAGLE_VERSION}

ADD http://faculty.washington.edu/browning/beagle/beagle.${BEAGLE_VERSION} /opt/beagle.${BEAGLE_VERSION}/beagle.jar
COPY beagle /opt/beagle.${BEAGLE_VERSION}/beagle

# mind to permissions
RUN chmod 644 /opt/beagle.${BEAGLE_VERSION}/beagle.jar

RUN ln -s /opt/beagle.${BEAGLE_VERSION}/beagle /usr/local/bin/beagle
