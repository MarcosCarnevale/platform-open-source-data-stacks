# Trello

## Atividade

Deploy do Airflow no Kubernetes utilizando o Helm, como criterio de aceitação, o Airflow deve ser instalado com sucesso no cluster Kubernetes, estar acessível através do navegador e ter ao menos uma DAG executada com sucesso.

### Tarefa 1: Criar Cluster com Configurações de Worker Nodes

**Título**: Criar Cluster com Configurações de Worker Nodes

**Descrição**:

- Criar um cluster Kubernetes chamado `airflow-cluster` utilizando o Kind com as configurações especificadas no arquivo `kind-cluster.yaml`.
- O cluster deve ser configurado com 3 worker nodes para suportar a carga de trabalho do Airflow.

**Comandos**:

```sh
kind create cluster --name airflow-cluster --config ./main/deployer/airflow/kind-cluster.yaml
```

**Critérios de Aceitação**:

- O cluster `airflow-cluster` deve ser criado com sucesso.
- O cluster deve ter 3 worker nodes em estado [`Ready`](.).

### Tarefa 2: Verificar Criação do Cluster

**Título**: Verificar Criação do Cluster

**Descrição**:

- Verificar se o cluster `airflow-cluster` foi criado com sucesso e está acessível.

**Comandos**:

```sh
kubectl cluster-info --context kind-airflow-cluster
```

**Critérios de Aceitação**:

- O comando deve retornar o endereço do cluster, indicando que ele está acessível.

### Tarefa 3: Verificar Nodes do Cluster

**Título**: Verificar Nodes do Cluster

**Descrição**:

- Listar os nodes do cluster `airflow-cluster` e verificar se todos estão em estado [`Ready`](.).

**Comandos**:

```sh
kubectl get nodes -o wide
```

**Critérios de Aceitação**:

- O comando deve retornar 3 nodes com o status [`Ready`](.).

### Tarefa 4: Criar Namespace para o Airflow

**Título**: Criar Namespace para o Airflow

**Descrição**:

- Criar um namespace chamado [`airflow`](.) para isolar o ambiente do Airflow.

**Comandos**:

```sh
kubectl apply -f ./main/deployer/airflow/airflow-namespace.yaml
```

**Critérios de Aceitação**:

- O namespace [`airflow`](.) deve ser criado com sucesso.

### Tarefa 5: Validar Criação do Namespace

**Título**: Validar Criação do Namespace

**Descrição**:

- Verificar se o namespace [`airflow`](.) foi criado corretamente.

**Comandos**:

```sh
kubectl get ns
```

**Critérios de Aceitação**:

- O comando deve listar o namespace [`airflow`](.).

### Tarefa 6: Adicionar Repositório do Airflow ao Helm

**Título**: Adicionar Repositório do Airflow ao Helm

**Descrição**:

- Adicionar o repositório do Airflow ao Helm para facilitar a instalação e atualização do Airflow no cluster.

**Comandos**:

```sh
helm repo add apache-airflow https://airflow.apache.org/
```

**Critérios de Aceitação**:

- O repositório `apache-airflow` deve ser adicionado ao Helm com sucesso.

### Tarefa 7: Atualizar Repositório do Helm

**Título**: Atualizar Repositório do Helm

**Descrição**:

- Atualizar a lista de pacotes disponíveis no repositório do Helm.

**Comandos**:

```sh
helm repo update
```

**Critérios de Aceitação**:

- A lista de pacotes do repositório `apache-airflow` deve ser atualizada com sucesso.

### Tarefa 8: Validar Repositório do Airflow

**Título**: Validar Repositório do Airflow

**Descrição**:

- Verificar se o repositório do Airflow foi adicionado corretamente e está acessível.

**Comandos**:

```sh
helm search repo apache-airflow
```

**Critérios de Aceitação**:

- O comando deve retornar a lista de pacotes disponíveis no repositório `apache-airflow`.

### Tarefa 9: Instalar o Airflow no Cluster

**Título**: Instalar o Airflow no Cluster

**Descrição**:

- Instalar o Airflow no cluster Kubernetes utilizando o Helm.

**Comandos**:

```sh
helm install airflow apache-airflow/airflow --namespace airflow --debug --timeout 10m0s
```

**Critérios de Aceitação**:

- O Airflow deve ser instalado com sucesso no namespace [`airflow`](.).
- A instalação deve ser concluída dentro do tempo limite de 10 minutos.

### Tarefa 10: Validar Instalação do Airflow

**Título**: Validar Instalação do Airflow

**Descrição**:

- Verificar se os pods do Airflow foram criados corretamente e estão em estado [`Running`](.).

**Comandos**:

```sh
kubectl get pods -n airflow
```

**Critérios de Aceitação**:

- Todos os pods do namespace [`airflow`](.) devem estar em estado [`Running`](;).

### Tarefa 11: Exibir Informações sobre o Airflow

**Título**: Exibir Informações sobre o Airflow

**Descrição**:

- Exibir as informações sobre o pacote Airflow do repositório `apache-airflow` e redirecionar a saída para o arquivo `values.yaml`.

**Comandos**:

```sh
helm show values apache-airflow/airflow > ./main/deployer/airflow/values.yaml
```

**Critérios de Aceitação**:

- O arquivo `values.yaml` deve ser criado com as configurações padrão do Airflow.

### Tarefa 12: Modificar Configurações do Airflow

**Título**: Modificar Configurações do Airflow

**Descrição**:

- Modificar o arquivo `values.yaml` para alterar o executor de [`CeleryExecutor`](.) para [`KubernetesExecutor`](.) e adicionar a configuração de variáveis de ambiente.

**Modificações**:

```yaml
executor: KubernetesExecutor

extraEnvFrom:
  - configMapRef:
      name: 'airflow-variables'
```

**Critérios de Aceitação**:

- O arquivo `values.yaml` deve ser modificado corretamente com as novas configurações.

### Tarefa 13: Aplicar Variáveis de Ambiente para o Airflow

**Título**: Aplicar Variáveis de Ambiente para o Airflow

**Descrição**:

- Aplicar as variáveis de ambiente para o Airflow utilizando o arquivo `variables.yaml`.

**Comandos**:

```sh
kubectl apply -f ./main/deployer/airflow/variables.yaml
```

**Critérios de Aceitação**:

- As variáveis de ambiente devem ser aplicadas com sucesso.

### Tarefa 14: Validar Aplicação das Variáveis de Ambiente

**Título**: Validar Aplicação das Variáveis de Ambiente

**Descrição**:

- Verificar se as variáveis de ambiente foram aplicadas corretamente.

**Comandos**:

```sh
helm ls -n airflow
```

**Critérios de Aceitação**:

- O comando deve retornar a lista de releases no namespace [`airflow`](.) com a revisão das variáveis de ambiente aplicada.

### Tarefa 15: Atualizar o Airflow com as Variáveis de Ambiente

**Título**: Atualizar o Airflow com as Variáveis de Ambiente

**Descrição**:

- Atualizar o Airflow no namespace [`airflow`](.) com as configurações personalizadas do arquivo `values.yaml`.

**Comandos**:

```sh
helm upgrade --install airflow apache-airflow/airflow -n airflow -f ./main/deployer/airflow/values.yaml --debug
```

**Critérios de Aceitação**:

- O Airflow deve ser atualizado com sucesso com as novas configurações.

### Tarefa 16: Validar Atualização do Airflow

**Título**: Validar Atualização do Airflow

**Descrição**:

- Verificar se os pods do Airflow foram atualizados corretamente e estão em estado [`Running`](.).

**Comandos**:

```sh
kubectl get pods -n airflow
helm ls -n airflow
```

**Critérios de Aceitação**:

- Todos os pods do namespace [`airflow`](.) devem estar em estado [`Running`](.).
- A lista de releases deve mostrar a revisão atualizada.

### Tarefa 17: Validar Variáveis de Ambiente Aplicadas

**Título**: Validar Variáveis de Ambiente Aplicadas

**Descrição**:

- Verificar se as variáveis de ambiente foram aplicadas corretamente no pod `airflow-webserver`.

**Comandos**:

```sh
kubectl exec --stdin --tty airflow-webserver-596bdcfd74-nqq6x -n airflow -- /bin/bash -c python3 -c
```

**Critérios de Aceitação**:

- O comando deve exibir as variáveis de ambiente aplicadas.

### Tarefa 18: Instalar Bibliotecas Adicionais

**Título**: Instalar Bibliotecas Adicionais

**Descrição**:

- Criar uma imagem Docker customizada para o Airflow com bibliotecas adicionais.

**Comandos**:

```sh
docker build -t airflow-custom-image:1.0.0 ./main/deployer/airflow/airflow-docker
```

**Critérios de Aceitação**:

- A imagem Docker `airflow-custom-image:1.0.0` deve ser criada com sucesso.

### Tarefa 19: Atualizar Airflow com Imagem Customizada no Kind Cluster

**Título**: Atualizar Airflow com Imagem Customizada no Kind Cluster

**Descrição**:

- Carregar a imagem Docker customizada no cluster Kind `airflow-cluster`.

**Comandos**:

```sh
kind load docker-image airflow-custom-image:1.0.0 --name airflow-cluster
```

**Critérios de Aceitação**:

- A imagem Docker `airflow-custom-image:1.0.0` deve ser carregada no cluster Kind com sucesso.

### Tarefa 20: Atualizar Airflow com Imagem Customizada

**Título**: Atualizar Airflow com Imagem Customizada

**Descrição**:

- Atualizar o Airflow no namespace [`airflow`](.) com a imagem Docker customizada.

**Comandos**:

```sh
helm upgrade --install airflow apache-airflow/airflow -n airflow -f ./main/deployer/airflow/values.yaml --debug
```

**Critérios de Aceitação**:

- O Airflow deve ser atualizado com sucesso utilizando a imagem Docker customizada.

### Tarefa 21: Acessar o Airflow

**Título**: Acessar o Airflow

**Descrição**:

- Configurar o port-forward para acessar o Airflow através do navegador.
- Acessar o Airflow no endereço `http://127.0.0.1:8080`.
- Realizar o login com as credenciais padrão.
- Verificar se o Airflow está acessível e funcionando corretamente.
- Realizar um teste de execução de uma DAG.
- Verificar se a execução da DAG foi concluída com sucesso.
