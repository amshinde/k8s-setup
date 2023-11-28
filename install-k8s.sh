#!/bin/bash

# install pre-reqs
sudo apt-get update && sudo apt-get -y upgrade && sudo apt install -y curl 

# remove older k8s install
if [ "$(command -v kubelet)" != "" ]; then
   sudo -E apt purge kubelet -y
fi

# Install Kubernetes:

sudo bash -c "cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial-unstable main
EOF"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo -E apt update
sudo -E apt install -y kubelet kubeadm kubectl

# Packets traversing the bridge should be sent to iptables for processing
echo br_netfilter | sudo -E tee /etc/modules-load.d/k8s.conf
sudo -E modprobe -i br_netfilter
sudo -E bash -c 'echo "net.bridge.bridge-nf-call-ip6tables = 1" > /etc/sysctl.d/k8s.conf'
sudo -E bash -c 'echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf'
sudo -E bash -c 'echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/k8s.conf'
sudo -E sysctl --system

# setup necessary bits for running k8s:
sudo swapoff -a

sudo -E systemctl enable kubelet

# install containerd
#VERSION="1.5.2"
#echo "Install Containerd ${VERSION}"
#wget -q https://github.com/containerd/containerd/releases/download/v${VERSION}/cri-containerd-cni-${VERSION}-linux-amd64.tar.gz
#sudo tar -C / -xzf cri-containerd-cni-${VERSION}-linux-amd64.tar.gz
#sudo systemctl enable containerd
#sudo systemctl start containerd

#sudo modprobe br_netfilter
#echo 1 | sudo tee -a /proc/sys/net/ipv4/ip_forward > /dev/null

