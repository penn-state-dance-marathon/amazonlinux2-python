#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM amazonlinux:2023

ARG PYTHON_VERSION=3.12.12
ARG PYTHON_VERSION_ONLYMAJOR=3.12

# Install build dependencies (AL2023 uses dnf instead of yum)
RUN dnf -y update && \
    dnf install -y shadow-utils findutils gcc sqlite-devel zlib-devel \
                   bzip2-devel openssl-devel readline-devel libffi-devel \
                   tar gzip make

# Build and install Python
RUN cd /usr/local/src && \
    curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && make && make altinstall && \
    rm -rf /usr/local/src/Python-${PYTHON_VERSION}*

# Install additional development libraries for Python packages
RUN dnf install -y \
    gcc-c++ \
    openldap-devel \
    libxml2-devel \
    xmlsec1 \
    xmlsec1-devel \
    xmlsec1-openssl \
    xmlsec1-openssl-devel \
    libtool-ltdl-devel \
    cairo-devel \
    pango \
    libjpeg-turbo-devel \
    openjpeg2-devel \
    mariadb-connector-c-devel \
    libxslt-devel && \
    dnf remove -y shadow-utils && \
    dnf clean all

ENV PYTHONUNBUFFERED=1
RUN ln -fs /usr/local/bin/python${PYTHON_VERSION_ONLYMAJOR} /usr/local/bin/python \
    && ln -fs /usr/local/bin/pip${PYTHON_VERSION_ONLYMAJOR} /usr/local/bin/pip
