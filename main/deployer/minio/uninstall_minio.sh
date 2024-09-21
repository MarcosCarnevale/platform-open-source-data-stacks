#!/bin/bash

# Desinstalar o Tenant do MinIO
echo "Desinstalando o Tenant do MinIO..."
helm uninstall tenant-minio --namespace tenant-minio

# Desinstalar o MinIO Operator
echo "Desinstalando o MinIO Operator..."
helm uninstall minio-operator --namespace minio-operator

# Remover os namespaces (opcional)
echo "Removendo namespaces..."
kubectl delete namespace tenant-minio
kubectl delete namespace minio-operator

# Remover o MinIO Client (mc)
echo "Removendo o MinIO Client (mc)..."
sudo rm /usr/local/bin/mc

# Verificar instalações pendentes
echo "Verificando instalações restantes..."
echo "Helm releases:"
helm list --all-namespaces
echo "Kubernetes recursos:"
kubectl get all --all-namespaces

# Encerrar processos em segundo plano
echo "Encerrando processos em segundo plano..."
jobs -p | xargs -r kill

echo "Desinstalação concluída."

chmod +x uninstall_minio.sh