#!/bin/bash

SERVER_URL=$(kubectl config view  -o jsonpath="{.clusters[0].cluster.server}")
CLUSTER_NAME=$(kubectl config view  -o jsonpath="{.clusters[0].name}")
TOKEN=$(kubectl get secret test-sa-2-secret -n test-web-2 -o jsonpath="{.data.token}" | base64 --decode)
CERTIFICATE_AUTHORITY_DATA=$(kubectl get secret test-sa-2-secret -n test-web-2 -o jsonpath="{.data.ca\.crt}")

cat <<EOF> test-web-2-kube.config
apiVersion: v1
kind: Config
users:
- name: test-sa-2
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
    user: test-sa-2
    namespace: test-web-2
  name: test-sa-context
current-context: test-sa-context
EOF
