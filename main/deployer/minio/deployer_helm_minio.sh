#!/bin/bash

# Adicionando o repositório do Minio
helm repo add minio https://charts.min.io/

# Criando o namespace
kubectl create namespace minio

# Instalando o Chart
echo "Instalando Chart"
helm install --namespace minio --set rootUser=rootuser,rootPassword=rootpass123 --generate-name minio/minio
echo "Chart Instalado"

# Instalando o Chart (toy-setup)
helm install --namespace minio --set resources.requests.memory=512Mi --set replicas=1 --set persistence.enabled=false --set mode=standalone --set rootUser=rootuser,rootPassword=rootpass123 --generate-name minio/minio
echo "toy-setup Instalado"

# Exportando o nome do pod
export POD_NAME=$(kubectl get pods --namespace minio -l "release=minio-*" -o jsonpath="{.items[0].metadata.name}")

# Encaminhando a porta
kubectl port-forward $POD_NAME 9000 --namespace minio &

# Download do cliente MinIO (mc)
echo "Baixando o cliente MinIO (mc)..."
curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/

# Exportando as credenciais
ROOT_USER=$(kubectl get secret --namespace minio -o jsonpath="{.data.rootUser}" | base64 --decode)
ROOT_PASSWORD=$(kubectl get secret --namespace minio -o jsonpath="{.data.rootPassword}" | base64 --decode)

if [[ -z "$ROOT_USER" || -z "$ROOT_PASSWORD" ]]; then
    echo "Erro: Não foi possível obter o usuário ou a senha do MinIO."
    exit 1
fi

# Exportando a variável de ambiente para o cliente mc
export MC_HOST_minio-local="http://${ROOT_USER}:${ROOT_PASSWORD}@localhost:9000"

# Listando os buckets do MinIO
mc ls minio-local
