#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM amazonlinux:2

ARG PYTHON_VERSION=3.7.17
ARG PYTHON_VERSION_ONLYMAJOR=3.7
RUN yum -y update &&\
    yum install -y shadow-utils findutils gcc sqlite-devel zlib-devel \
                   bzip2-devel openssl-devel readline-devel libffi-devel tar gzip make && \
    cd /usr/local/src && \
    curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && make && make altinstall && \
    rm -rf /usr/local/src/Python-${PYTHON_VERSION}* && \
    yum remove -y shadow-utils audit-libs libcap-ng && yum -y autoremove && \
    yum clean all

ENV PYTHONUNBUFFERED 1
RUN yum install -y \
    openssl \
    openssl-devel \
    python3-devel \
    openldap-devel \
    libxml2-devel \
    xmlsec1-devel \
    xmlsec1-openssl-devel \
    libtool-ltdl-devel \
    epel-release \
    python3-pip \
	cairo-devel \
    pango \
    gcc-c++ \
    zlib-devel \
    libjpeg-devel \
    openjpeg2-devel \
    libffi-devel \
    mysql-devel
RUN ln -fs /usr/local/bin/python${PYTHON_VERSION_ONLYMAJOR} /usr/local/bin/python \
    && ln -fs /usr/local/bin/pip${PYTHON_VERSION_ONLYMAJOR} /usr/local/bin/pip
