#!/bin/bash
# Nome do novo cluster
NEW_CLUSTER_NAME="open-source"

# Atualizar o sistema
sudo apt update
sudo apt upgrade -y

# Instalar curl (se não estiver instalado)
sudo apt install curl -y

# Baixar a versão mais recente do Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-amd64

# Dar permissão de execução
chmod +x ./kind

# Mover o binário para um diretório no seu PATH
sudo mv ./kind /usr/local/bin/kind

# Verificar a instalação
kind version

# Permitir execução do script
chmod +x instaladores/install_kind.sh


# Lista todos os clusters existentes
CLUSTERS=$(kind get clusters)

if [ -n "$CLUSTERS" ]; then
    # Se houver clusters existentes, use o primeiro
    FIRST_CLUSTER=$(echo "$CLUSTERS" | head -n 1)
    echo "Usando o cluster existente: '$FIRST_CLUSTER'."
else
    # Se não houver clusters, crie um novo com o nome definido
    echo "Nenhum cluster encontrado. Criando um novo cluster '$NEW_CLUSTER_NAME'."
    kind create cluster --name "$NEW_CLUSTER_NAME"
    FIRST_CLUSTER="$NEW_CLUSTER_NAME"
fi