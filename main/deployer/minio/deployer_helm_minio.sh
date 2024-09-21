#!/bin/bash

# Instalar o MinIO Client (mc)
if ! command -v mc &> /dev/null; then
    echo "Instalando o MinIO Client (mc)..."
    wget https://dl.min.io/client/mc/release/linux-amd64/mc
    chmod +x mc
    sudo mv mc /usr/local/bin/
fi

# Instalação do MinIO Operator
helm install \
  --namespace minio-operator \
  --create-namespace \
  minio-operator ./operator

# Verificando instalação
kubectl get all --namespace minio-operator

# Namespace do Kubernetes
NAMESPACE="tenant-minio"

# Instalando TENANT
helm install \
  --namespace $NAMESPACE \
  --create-namespace \
  $NAMESPACE ./tenant

# Aguardando o Pod do MinIO
sleep 10

# Verificando o estado dos Pods
kubectl get pods -n $NAMESPACE
kubectl describe pods -n $NAMESPACE  # Adicionado para detalhes

# Aguarde até que o serviço esteja disponível
sleep 15

# Expondo a porta MinIO do Tenant (port-forward) em segundo plano
kubectl port-forward svc/myminio-hl 9000:9000 -n $NAMESPACE &

# Aguardando um pouco mais para garantir que o port-forward está ativo
sleep 30

# Criando um alias para o serviço Tenant
mc alias set myminio https://localhost:9000 minio minio123 --insecure
mc mb myminio/mybucket --insecure

# Verificando os Pods e port-forward
kubectl get pods -n $NAMESPACE
