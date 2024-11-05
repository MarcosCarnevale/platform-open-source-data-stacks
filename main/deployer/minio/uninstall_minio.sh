#!/bin/bash

# Define o namespace
NAMESPACE="minio"

# Obtém o nome da release Helm instalada no namespace minio
RELEASE_NAME=$(helm list --namespace "$NAMESPACE" -q)

# Verifica se a release existe e a desinstala
if [ -n "$RELEASE_NAME" ]; then
  echo "Desinstalando a release $RELEASE_NAME no namespace $NAMESPACE..."
  helm uninstall "$RELEASE_NAME" --namespace "$NAMESPACE"
else
  echo "Nenhuma release encontrada no namespace $NAMESPACE."
fi

# Remove o repositório Helm
echo "Removendo o repositório Helm minio..."
helm repo remove minio

# Deleta o namespace minio
echo "Deletando o namespace $NAMESPACE..."
kubectl delete namespace "$NAMESPACE"


echo "Uninstall finalizado"