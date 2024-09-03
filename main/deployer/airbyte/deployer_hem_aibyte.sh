# Script para deploy de Airbyte usando Helm

# Download do Helm (linux-amd64)

# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh

# # Adicionar o repositório do Airbyte

# helm repo add airbyte https://airbytehq.github.io/helm-charts
# helm repo update

# Validando o repositório
helm search repo airbyte

# Instalando o Airbyte
echo "Instalando o Airbyte..."

helm install airbyte airbyte/airbyte
