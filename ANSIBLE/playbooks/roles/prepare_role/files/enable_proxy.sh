#!/bin/bash

sudo cat <<EOF> /etc/apt/apt.conf.d/10proxy
Acquire::http::proxy "http://172.29.60.36:3128";
Acquire::https::proxy "http://172.29.60.36:3128";
EOF

sudo mkdir -p /etc/systemd/system/containerd.service.d
sudo cat <<EOF> /etc/systemd/system/containerd.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://172.29.60.36:3128"
Environment="HTTPS_PROXY=http://172.29.60.36:3128"
Environment="NO_PROXY=localhost"
EOF

sudo systemctl daemon-reload

