3 основных компонента:

containerd - среда для запуска контейнеров
runc - инструмент для запуска контейнеров
cni plugins - компонент, обеспечивающий сетевую связанность между контейнерами



1. Установить containerd в папку /usr/local
tar Cxzvf /usr/local containerd-1.6.2-linux-amd64.tar.gz

2. Запустить как системный демон containerd
2.1 Добавить файл containerd.service в папку /etc/systemd/system
2.2 Перезагрузить и добавить в автозагрузку демона
systemctl daemon-reload
systemctl enable --now containerd


3. Установить runc
install -m 755 runc.amd64 /usr/local/sbin/runc

4. Установить CNI plugins
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz


containerd config default | sudo tee /etc/containerd/config.toml > /dev/null 2>&1
sudo sed -i 's/SystemCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo apt-mark hold - запретить изменение пакетов в автоматическом режиме в Debian/ubuntu



или запустить скрипт install_containerd.sh
 