

# Documentação do Script [`deployer_helm_airbyte.sh`](.)

Este script automatiza o processo de deploy do Airbyte usando Helm no Kubernetes. Ele inclui etapas para baixar e instalar o Helm, adicionar o repositório do Airbyte, instalar o Airbyte e configurar o acesso ao Airbyte.

## Estrutura do Script

### 1. Download do Helm

O script começa baixando o Helm, uma ferramenta de gerenciamento de pacotes para Kubernetes.

```shell
# Download do Helm (linux-amd64)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

- **curl -fsSL -o get_helm.sh**: Baixa o script de instalação do Helm.
- **chmod 700 get_helm.sh**: Dá permissão de execução ao script baixado.
- **./get_helm.sh**: Executa o script de instalação do Helm.

### 2. Adicionar o Repositório do Airbyte

Adiciona o repositório de Helm charts do Airbyte e atualiza a lista de repositórios.

```shell
# Adicionar o repositório do Airbyte
helm repo add airbyte https://airbytehq.github.io/helm-charts
helm repo update
```

- **helm repo add airbyte**: Adiciona o repositório do Airbyte.
- **helm repo update**: Atualiza a lista de repositórios de Helm.

### 3. Validar o Repositório

Valida se o repositório do Airbyte foi adicionado corretamente.

```shell
# Validando o repositório
helm search repo airbyte
```

- **helm search repo airbyte**: Pesquisa o repositório do Airbyte para garantir que foi adicionado corretamente.

### 4. Instalar o Airbyte

Instala o Airbyte no cluster Kubernetes.

```shell
# Instalando o Airbyte
echo "Instalando o Airbyte..."
helm install airbyte airbyte/airbyte
```

- **helm install airbyte airbyte/airbyte**: Instala o Airbyte usando o Helm chart do repositório adicionado.

### 5. Validar a Instalação

Verifica se os pods do Airbyte foram criados corretamente.

```shell
# Validando a instalação
kubectl get pods -n default
```

- **kubectl get pods -n default**: Lista os pods no namespace [`default`](.) para verificar se o Airbyte foi instalado corretamente.

### 6. Acessar o Airbyte

Configura o acesso ao Airbyte através de um port-forward.

```shell
# Acessar o Airbyte 
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=webapp" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use Airbyte"
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```

- **export POD_NAME**: Obtém o nome do pod do Airbyte.
- **export CONTAINER_PORT**: Obtém a porta do container do Airbyte.
- **kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT**: Configura o port-forward para acessar o Airbyte localmente através da porta 8080.

## Como Executar o Script

1. Salve o conteúdo do script em um arquivo chamado [`deployer_helm_airbyte.sh`](.).
2. Dê permissão de execução ao script:

   ```sh
   chmod +x deployer_helm_airbyte.sh
   ```

3. Execute o script:

   ```sh
   ./deployer_helm_airbyte.sh
   ```

Isso automatizará o processo de deploy do Airbyte no seu cluster Kubernetes usando Helm.