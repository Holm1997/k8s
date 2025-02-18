#!/bin/bash

SERVER_URL=$(kubectl config view  -o jsonpath="{.clusters[0].cluster.server}")
CLUSTER_NAME=$(kubectl config view  -o jsonpath="{.clusters[0].name}")
TOKEN=$(kubectl get secret test-sa-secret -n test-web-1 -o jsonpath="{.data.token}" | base64 --decode)
CERTIFICATE_AUTHORITY_DATA=$(kubectl get secret test-sa-secret -n test-web-1 -o jsonpath="{.data.ca\.crt}")

cat <<EOF> test-web-1-kube.config
apiVersion: v1
kind: Config
users:
- name: test-sa
  user:
    token: $TOKEN
clusters:
- cluster:
    certificate-authority-data: $CERTIFICATE_AUTHORITY_DATA
    server: $SERVER_URL
  name: $CLUSTER_NAME
contexts:
- context:
    cluster: $CLUSTER_NAME
    user: test-sa
    namespace: test-web-1
  name: test-sa-context
current-context: test-sa-context
EOF
