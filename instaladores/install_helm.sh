#!/bin/bash

# Atualizar o sistema
sudo apt update
sudo apt upgrade -y

# Instalar Snap (se necessário)
sudo apt install snapd -y

# Instalar o Helm usando Snap
sudo snap install helm --classic

# Alternativa: baixar e instalar manualmente
# Baixar a versão mais recente do Helm
wget https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz

# Extrair o arquivo
tar -zxvf helm-v3.10.3-linux-amd64.tar.gz

# Mover o executável para um diretório no seu PATH
sudo mv linux-amd64/helm /usr/local/bin/helm

# Verificar a instalação
helm version

# Permitir execução do script
chmod +x instaladores/install_helm.sh