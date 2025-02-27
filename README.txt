KUBERNETES
1.31.1

Для установки кластера используется ansible [2.16]

Основные конфигурационные файлы:
ANSIBLE/ansible.cfg
ANSIBLE/hosts
ANSIBLE/group_vars



1. Удалить файл подкачки
	sudo swapoff -a
	sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

2. Установить модули Overlay и br_netfilter

	sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
	sudo modprobe overlay
	sudo modprobe br_netfilter

3. Установить правила для сетевого трафика
	
	sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1  
EOF
	sudo sysctl --system


4. Дополнительные компоненты
nfs-utils
bash-completion
tar
python3
chrony
mc
vim
rsyslog
git
jq
conntrack


containerd config default | sudo tee /etc/containerd/config.toml > /dev/null 2>&1
sudo sed -i 's/SystemCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd enable


sudo mkdir -p /etc/systemd/system/containerd.service.d
sudo touch /etc/systemd/system/containerd.service.d/http-proxy.conf
nano /etc/systemd/system/containerd.service.d/http-proxy.conf

[Service]
Environment="HTTP_PROXY=http://proxy.example.com"
Environment="HTTPS_PROXY=http://proxy.example.com"
Environment="NO_PROXY=localhost"




Зависимости:
	- conntrack
	- socat
	- rsyslog
	- mc
	- btop
	- python3
	- net-tools
	- nfs-client









-----------------------------------------------------------------------------------
1.Создать новый токен:
	- kubeadm token create

2.Cделать отпечаток центра сертификации кластера:
	- |
	  openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \ 
	  openssl rsa -pubin -outform der 2>/dev/null | \
	  openssl dgst -sha256 -x | sed 's/^.* //'

3. 3агрузить ключ от сертификата:
	- kubeadm init phase upload-certs --upload-certs



Добавить мастер ноду:

kubeadm join 192.168.0.125:7443 --token 1_ПУНКТ  --discovery-token-ca-cert-hash 2_ПУНКТ \
	--control-plane --certificate-key 3_ПУНКТ

Добавитть рабочую ноду:

kubeadm join 192.168.0.125:7443 --token 1_ПУНКТ  --discovery-token-ca-cert-hash 2_ПУНКТ \
	--certificate-key 3_ПУНКТ
