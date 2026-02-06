#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM amazonlinux:2023

ARG PYTHON_VERSION_ONLYMAJOR=3.12

RUN dnf -y update && \
    dnf install -y \
    python${PYTHON_VERSION_ONLYMAJOR} \
    python${PYTHON_VERSION_ONLYMAJOR}-pip \
    python${PYTHON_VERSION_ONLYMAJOR}-devel \
    gcc \
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
    dnf clean all

ENV PYTHONUNBUFFERED=1
RUN ln -fs /usr/bin/python${PYTHON_VERSION_ONLYMAJOR} /usr/local/bin/python \
    && ln -fs /usr/bin/pip${PYTHON_VERSION_ONLYMAJOR} /usr/local/bin/pip
