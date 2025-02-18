#!/bin/bash

#1. Отключение файла подкачки
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#2. Загрузка модулей ядра overlay и br_netfilter
sudo cat <<EOF> /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

#3. Установка правил для сетевого трафика
sudo cat <<EOF> /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
net.ipv4.ip_nonlocal_bind = 1
EOF
sudo sysctl --system

#4. Установка среды для заупска и выполнения контейнеров containerd

echo "установка сontainerd...."

tar Cxzvf /usr/local /tmp/KUBERNETES/containerd/containerd-1.7.22-linux-amd64.tar.gz
mv /tmp/KUBERNETES/containerd/containerd.service.txt /etc/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

systemctl restart containerd

echo "УСПЕШНО"

echo "установка runc..."

install -m 755 /tmp/containerd/runc.amd64 /usr/local/sbin/runc

echo "УСПЕШНО"

echo "установка CNI pluggins..."

mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin /tmp/containerd/cni-plugins-linux-amd64-v1.5.1.tgz

echo "УСПЕШНО"

echo "Установка утилиты crictl"

tar Cxzvf /usr/bin /tmp/crictl/crictl-v1.31.1-linux-amd64.tar.gz
sudo cp /tmp/crictl/crictl.yaml.txt /etc/crictl.yaml

echo "УСПЕШНО"

#5. Установка утилит kubeadm, kubectl а также kubelet
sudo mv /tmp/KUBERNETES/kubeadm/kubeadm /usr/bin/kubeadm
sudo mv /tmp/KUBERNETES/kubectl /usr/bin/kubectl
sudo mv /tmp/KUBERNETES/kubelet/kubelet /usr/bin/kubelet
sudo mv /tmp/KUBERNETES/kubelet/kubelet.service.txt /etc/systemd/system/kubelet.service
sudo mkdir /etc/systemd/system/kubelet.service.d
sudo cat <<EOF> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generate at runtime, populating
# the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably,
# the user should use the .NodeRegistration.KubeletExtraArgs object in the configuration files instead.
# KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
EOF

sudo chmod 700 /usr/bin/kubeadm
sudo chmod 700 /usr/bin/kubectl
sudo chmod 700 /usr/bin/kubelet

sudo systemctl daemon-reload
sudo systemctl enable kubelet
