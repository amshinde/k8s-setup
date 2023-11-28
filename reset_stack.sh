#!/usr/bin/env bash

set -o nounset

#Cleanup
reset_cluster() {
	sudo -E kubeadm reset -f
}

cleanup_cni_configuration() {
        # Remove existing CNI configurations:    
        local cni_config_dir="/etc/cni"
        local cni_interface="cni0"
        sudo rm -rf /var/lib/cni/networks/*      
        sudo rm -rf "${cni_config_dir}"/*        
        if ip a show "$cni_interface"; then      
                sudo ip link set dev "$cni_interface" down
                sudo ip link del "$cni_interface"        
        fi
}

# Reset kubernetes
export KUBECONFIG="$HOME/.kube/config"
reset_cluster

sudo systemctl stop kubelet 
systemctl is-active containerd && sudo systemctl stop containerd
systemctl is-active crio && sudo systemctl stop crio

cleanup_cni_configuration

#cleanup stale file under /run
sudo sh -c 'rm -rf /run/flannel'


# The kubeadm reset process does not clean your kubeconfig files.
# you must remove them manually.
sudo -E rm -rf "$HOME/.kube"

# Stop runc processes
runc_path=$(command -v runc)
runc_container_union="$($runc_path list)"
if [ -n "$runc_container_union" ]; then
        while IFS='$\n' read runc_container; do
                container_id="$(echo "$runc_container" | awk '{print $1}')"
                if [ "$container_id" != "ID" ]; then
                        $runc_path delete -f $container_id
                fi
        done <<< "${runc_container_union}"
fi


sudo pkill -9 qemu
sudo pkill -9 kata
sudo pkill -9 kube

sudo systemctl is-enabled containerd && sudo systemctl restart containerd
#sudo systemctl restart kubelet
#reset_cluster
