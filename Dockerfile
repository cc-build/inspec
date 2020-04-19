FROM ruby:alpine
LABEL maintainer="Cinc Project <docker@cinc.sh>"

ARG EXPEDITOR_VERSION
ARG VERSION=4.23.15

# GEM_SOURCE is kept away from expeditor controlled ARGs to accomodate 3rd party distros
ARG GEM_SOURCE=https://packagecloud.io/cinc-project/stable

# Allow VERSION below to be controlled by either VERSION or EXPEDITOR_VERSION build arguments
ENV VERSION ${EXPEDITOR_VERSION:-${VERSION}}

RUN mkdir -p /share
RUN apk add --update build-base libxml2-dev libffi-dev git openssh-client
RUN gem install --no-document --source ${GEM_SOURCE} --version ${VERSION} inspec
RUN gem install --no-document --source ${GEM_SOURCE} --version ${VERSION} cinc-auditor-bin
RUN apk del build-base

ENTRYPOINT ["cinc-auditor"]
CMD ["help"]
VOLUME ["/share"]
WORKDIR /share
