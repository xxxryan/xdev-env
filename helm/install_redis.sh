#!/bin/bash

NAMESPACE=xdev

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install redis bitnami/redis \
  --create-namespace \
  --set architecture=standalone \
  --set auth.enabled=false \
  --set persistence.size=1Gi \
  --set persistence.storageClass=local-path \
  --namespace $NAMESPACE
