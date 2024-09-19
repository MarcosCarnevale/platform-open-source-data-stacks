#!/bin/bash

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