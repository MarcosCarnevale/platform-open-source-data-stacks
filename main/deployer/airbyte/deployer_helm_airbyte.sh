# Script para deploy de Airbyte usando Helm

# Download do Helm (linux-amd64)

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Adicionar o repositório do Airbyte

helm repo add airbyte https://airbytehq.github.io/helm-charts
helm repo update

# Validando o repositório
helm search repo airbyte

# Instalando o Airbyte
echo "Instalando o Airbyte..."

helm install airbyte airbyte/airbyte

# Validando a instalação
kubectl get pods -n default

# Acessar o Airbyte 
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=webapp" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use Airbyte"
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT