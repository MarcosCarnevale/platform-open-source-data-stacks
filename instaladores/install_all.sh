#!/bin/bash

echo "Ajustando o sed..."
sed -i -e 's/\r$//' instaladores/install_helm.sh
sed -i -e 's/\r$//' instaladores/install_kind.sh
sed -i -e 's/\r$//' instaladores/install_kubectl.sh
echo "sed ajustado..."

# Executar o script de instalação do Helm
echo "Instalando o Helm..."
./instaladores/install_helm.sh

# Executar o script de instalação do Kind
echo "Instalando o Kind..."
./instaladores/install_kind.sh

# Executar o script de instalação do Kubectl
echo "Instalando o Kubectl..."
./instaladores/install_kubectl.sh

echo "Todas as instalações concluídas!"

# Dando permissão para o Docker
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

# Permitir execução do script
chmod +x instaladores/install_all.sh