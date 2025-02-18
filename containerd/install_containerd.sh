#!/bin/bash


echo "установка ontainerd...."

tar Cxzvf /usr/local containerd-1.7.22-linux-amd64.tar.gz
mv containerd.service.txt /etc/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

systemctl restart containerd

echo "УСПЕШНО"

echo "установка runc..."

install -m 755 runc.amd64 /usr/local/sbin/runc

echo "УСПЕШНО"
 
echo "установка CNI pluggins..."

mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.5.1.tgz

echo "УСПЕШНО"

