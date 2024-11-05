#!/bin/bash

echo "Ajustando o sed..."
sed -i -e 's/\r$//' install_helm.sh
sed -i -e 's/\r$//' install_kind.sh
sed -i -e 's/\r$//' install_kubectl.sh
echo "sed ajustado..."

# Executar o script de instalação do Helm
echo "Instalando o Helm..."
./install_helm.sh

# Executar o script de instalação do Kind
echo "Instalando o Kind..."
./install_kind.sh

# Executar o script de instalação do Kubectl
echo "Instalando o Kubectl..."
./install_kubectl.sh

echo "Todas as instalações concluídas!"

# Dando permissão para o Docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

echo "Removendo o arquivo helm-v3.10.3-linux-amd64.tar.gz..."
rm -f helm-v3.10.3-linux-amd64.tar.gz

# Permitir execução do script
chmod +x install_all.sh