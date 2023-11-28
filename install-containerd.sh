#!/bin/bash

# Containerd version to install
VERSION=${VERSION:-"1.7.9"}


# install containerd
echo "Install Containerd ${VERSION}"
wget -q https://github.com/containerd/containerd/releases/download/v${VERSION}/cri-containerd-cni-${VERSION}-linux-amd64.tar.gz
sudo tar -C / -xzf cri-containerd-cni-${VERSION}-linux-amd64.tar.gz
sudo systemctl enable containerd
sudo systemctl start containerd

