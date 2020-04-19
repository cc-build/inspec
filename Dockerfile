FROM ubuntu:18.04
LABEL maintainer="Cinc Project <docker@cinc.sh>"

ARG VERSION=4.37.17
ARG CHANNEL=stable

ENV PATH=/opt/cinc-auditor/bin:/opt/cinc-auditor/embedded/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Run the entire container with the default locale to be en_US.UTF-8
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8


RUN mkdir -p /share

RUN apt-get update && \
    apt-get install -y wget rpm2cpio cpio && \
    wget "http://ftp-osl.osuosl.org/pub/cinc/files/${CHANNEL}/cinc-auditor/${VERSION}/el/7/cinc-auditor-${VERSION}-1.el7.x86_64.rpm" -O /tmp/cinc-auditor.rpm && \
    rpm2cpio /tmp/cinc-auditor.rpm | cpio -idmv && \
    rm -rf /tmp/cinc-auditor.rpm

# Install any packages that make life easier for an InSpec installation
RUN apt-get install -y git

ENTRYPOINT ["cinc-auditor"]
CMD ["help"]
VOLUME ["/share"]
WORKDIR /share
