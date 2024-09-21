#!/bin/bash

# Atualizar o sistema
sudo apt update
sudo apt upgrade -y

# Instalar curl (se não estiver instalado)
sudo apt install curl -y

# Baixar a versão mais recente do kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

# Dar permissão de execução
chmod +x ./kubectl

# Mover o binário para um diretório no seu PATH
sudo mv ./kubectl /usr/local/bin/kubectl

# Verificar a instalação
kubectl version --client

# Permitir execução do script
chmod +x instaladores/install_kubectl.sh


# Configura kubectl para usar o cluster
kubectl config use-context kind-$FIRST_CLUSTER

# Verifica a configuração atual
kubectl cluster-info