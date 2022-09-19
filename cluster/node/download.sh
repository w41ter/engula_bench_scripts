#!/bin/bash

# This scripts will download tarball from specified url and verify sha256 sum.
source config.sh
source cluster/config.sh

set -ue

mkdir -p ~/packages/
if [ -f ~/packages/${PACKAGE_NAME}.tar.gz ]; then
    if [ ! -z ${PACKAGE_SHA256_SUM} ]; then
        ORIGIN_SUM=$(sha256sum ~/packages/${PACKAGE_NAME}.tar.gz | cut -d ' ' -f 1)
        if [[ ${ORIGIN_SUM} == ${PACKAGE_SHA256_SUM} ]]; then
            echo "tarball already exists in ~/packages/${PACKAGE_NAME}"
            exit 0
        fi

        echo "found a tarball with same name but different sha256 sum"
        echo "name: ${PACKAGE_NAME}.tar.gz"
        echo "origin sum: ${ORIGIN_SUM}"
        echo "expect sum: ${PACKAGE_SHA256}"
    fi

    echo "remove origin tarbal ~/packages/${PACKAGE_NAME} and download ..."
    rm -rf ~/packages/${PACKAGE_NAME}.tar.gz
fi

curl -s -o /tmp/engula.tar.gz.tmp ${PACKAGE_URL} 2>/dev/null
if [ ! -z ${PACKAGE_SHA256_SUM} ]; then
    ORIGIN_SUM=$(sha256sum /tmp/engula.tar.gz.tmp | cut -d ' ' -f 1)
    if [[ ${ORIGIN_SUM} != ${PACKAGE_SHA256_SUM} ]]; then
        echo "download tarball failed: sha256 is not equals"
        echo "got sum: ${ORIGIN_SUM}"
        echo "expect sum: ${PACKAGE_SHA256}"
        exit 1
    fi
fi

mv /tmp/engula.tar.gz.tmp ~/packages/${PACKAGE_NAME}.tar.gz
