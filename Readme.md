# k8s-setup
 
This repo helps setup a single-node cluster using K8S, containerd and kata.  
This assumes you are on an Ubuntu VM which supports VMX.

## install pre-requisites: 
 
Install Kubernetes, containerd, CNI plugins, disable swap, enable br_netfilter and ip_forwarding for ipv4: 
```bash  
./install-k8s.sh
./install-containerd.sh 
``` 
 
## Start a cluster 
 
We start a cluster using a  kubeadm configuration yaml `kubeadm.yaml` included in the repo: 
```bash 
./create_k8s_node.sh 
``` 
 
## Setup kata

Setup Kata using the artefacts provided in the kata-containers repo:
```
kubectl apply -f https://raw.githubusercontent.com/kata-containers/kata-containers/main/tools/packaging/kata-deploy/kata-rbac/base/kata-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/kata-containers/kata-containers/main/tools/packaging/kata-deploy/kata-deploy/base/kata-deploy-stable.yaml
kubectl apply -f https://raw.githubusercontent.com/kata-containers/kata-containers/main/tools/packaging/kata-deploy/runtimeclasses/kata-runtimeClasses.yaml
```

More information about kata-containers can be found at https://github.com/kata-containers/kata-containers/blob/main/tools/packaging/kata-deploy/README.md 

After kata-deploy is up and running, you'll see kata artifacts are installed at /opt/kata, and that 'etc/containerd/config.toml' was updated to register the kata handlers.


