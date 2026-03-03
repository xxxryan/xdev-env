#!/bin/bash

NAMESPACE=xdev

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install postgres bitnami/postgresql \
  --create-namespace \
  --set auth.postgresPassword=${POSTGRES_PASSWORD} \
  --set auth.database=${POSTGRES_DB} \
  --set auth.username=${POSTGRES_USER} \
  --set persistence.size=5Gi \
  --set persistence.storageClass=local-path \
  --set primary.service.type=ClusterIP \
  --namespace $NAMESPACE
