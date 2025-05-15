1. Kubectl create namespace argocd

2. Kubectl apply -f argocd.yml

3. kubectl create -n argocd secret tls argocd-server-tls \
  --cert=/path/to/cert.pem \
  --key=/path/to/key.pem

4. argocd admin initial-password -n argocd

5. argocd login <ARGOCD_SERVER>

6. argocd account update-password