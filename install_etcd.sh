#!/bin/bash

VERSION=${1:-'0.4.1'}
VERSION_STR="v${VERSION}-linux-amd64"

echo installing etcd ${VERSION_STR}

curl -L https://github.com/coreos/etcd/releases/download/v${VERSION}/etcd-${VERSION_STR}.tar.gz -o etcd-${VERSION_STR}.tar.gz
tar xzvf etcd-${VERSION_STR}.tar.gz

echo starting etcd...
./etcd-${VERSION_STR}/etcd > etcd.console.out &