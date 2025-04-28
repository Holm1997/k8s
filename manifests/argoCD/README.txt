1. Kubectl create namespace argocd

2. Kubectl apply -f argocd.yml

3. kubectl create -n argocd secret tls argocd-server-tls \
  --cert=/path/to/cert.pem \
  --key=/path/to/key.pem