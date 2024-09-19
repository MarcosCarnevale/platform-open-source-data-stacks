# Documentação de Deployment do Jupyter Notebook

Este documento descreve o processo completo para configurar e implantar o __Jupyter Notebook__ em um cluster Kubernetes local utilizando __Kind__ (Kubernetes in Docker). Abaixo estão os detalhes sobre a criação do cluster, configuração do namespace, deployment do Jupyter Notebook, e acesso ao ambiente.

## `jupyter-deployer.sh`

Este script automatiza a criação do cluster Kind, configuração do namespace e deployment do Jupyter Notebook, e a configuração de port-forwarding para acessar o Jupyter Notebook no navegador.

```sh
# Criando cluster Kind
kind create cluster --name jupyter-cluster
```

- __Ação__: Cria um novo cluster Kubernetes local usando Kind com o nome `jupyter-cluster`.
- __Por que__: O cluster Kind fornece um ambiente Kubernetes local para desenvolvimento e teste. O nome do cluster `jupyter-cluster` ajuda a identificar o ambiente específico para o Jupyter Notebook.

```sh
# Verificando se o cluster foi criado com sucesso
kubectl cluster-info --context kind-jupyter-cluster
```

- __Ação__: Verifica as informações do cluster para garantir que o cluster Kind foi criado corretamente.
- __Por que__: Confirmar que o cluster está funcionando e acessível é crucial antes de prosseguir com outras configurações.

```sh
# Criando o namespace Jupyter
kubectl apply -f ./main/deployer/jupyter/jupyter-namespace.yaml
```

- __Ação__: Aplica a configuração do namespace para o Jupyter Notebook a partir do arquivo `jupyter-namespace.yaml`.
- __Por que__: O namespace `jupyter` isola os recursos do Jupyter Notebook dentro do cluster, evitando conflitos com outros recursos e ajudando na organização.

```sh
# Verificando se o namespace foi criado com sucesso
kubectl get namespaces
```

- __Ação__: Lista todos os namespaces no cluster para confirmar a criação do namespace `jupyter`.
- __Por que__: Certifica-se de que o namespace foi criado e está ativo.

```sh
# Criando o deployment do Jupyter Notebook
kubectl apply -f ./main/deployer/jupyter/jupyter-deployment.yaml
```

- __Ação__: Aplica a configuração do deployment do Jupyter Notebook a partir do arquivo `jupyter-deployment.yaml`.
- __Por que__: O deployment configura o Jupyter Notebook como um pod no cluster, definindo o container e suas especificações.

```sh
# Verificando se o deployment foi criado com sucesso
kubectl get deployments -n jupyter
```

- __Ação__: Lista os deployments no namespace `jupyter` para garantir que o deployment do Jupyter Notebook está em execução.
- __Por que__: Verificar o estado do deployment ajuda a confirmar que o Jupyter Notebook está corretamente implantado e funcionando.

```sh
# Capturando o token do Jupyter Notebook
JUPYTER_TOKEN=$(kubectl exec -it $(kubectl get pods -n jupyter -o name | cut -d/ -f2) -n jupyter -- bash -c "jupyter notebook list" | grep http | cut -d' ' -f1 | cut -d'=' -f2)
```

- __Ação__: Executa um comando dentro do pod do Jupyter Notebook para recuperar o token de autenticação necessário para acessar a interface web.
- __Por que__: O token é necessário para autenticar o acesso ao Jupyter Notebook via navegador.

```sh
# Configurando port-forward para acessar o Jupyter Notebook
echo "Para acessar o Jupyter, abra o navegador e acesse http://localhost:8888?token=$JUPYTER_TOKEN"
kubectl port-forward deployment/jupyter -n jupyter 8888:8888
```

- __Ação__: Configura o port-forwarding para mapear a porta 8888 do deployment Jupyter Notebook para a porta 8888 da máquina local.
- __Por que__: O port-forwarding permite acessar a interface do Jupyter Notebook em `http://localhost:8888` a partir do navegador local.

## `jupyter-deployment.yaml`

Arquivo de configuração para o deployment e serviço do Jupyter Notebook.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jupyter-deployment
  namespace: jupyter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jupyter
  template:
    metadata:
      labels:
        app: jupyter
    spec:
      containers:
      - name: jupyter
        image: jupyter/pyspark-notebook:latest
        ports:
        - containerPort: 8888
        resources:
          limits:
            memory: "2Gi"
            cpu: "1000m"
        volumeMounts:
        - name: notebook-storage
          mountPath: /home/jovyan/work
      volumes:
      - name: notebook-storage
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: jupyter-service
  namespace: jupyter
spec:
  type: NodePort
  ports:
  - port: 8888
    targetPort: 8888
    nodePort: 30001
  selector:
    app: jupyter
```

- __Deployment__:
  - __`apiVersion`__: Define a versão da API usada para o deployment.
  - __`kind`__: Tipo de recurso (Deployment).
  - __`metadata`__: Informações sobre o deployment, incluindo nome e namespace.
  - __`spec`__: Define a especificação do deployment, como número de réplicas, seletor de labels, template do pod, e configurações do container.
  - __`containers`__: Especifica o container do Jupyter Notebook, incluindo a imagem Docker, portas, e limites de recursos.
  - __`volumes`__: Define volumes para armazenamento temporário dos notebooks.

- __Service__:
  - __`apiVersion`__: Define a versão da API usada para o serviço.
  - __`kind`__: Tipo de recurso (Service).
  - __`metadata`__: Informações sobre o serviço, incluindo nome e namespace.
  - __`spec`__: Define a especificação do serviço, incluindo o tipo `NodePort`, portas, e seletor de labels.

## `jupyter-namespace.yaml`

Arquivo de configuração para o namespace onde o Jupyter Notebook será implantado.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: jupyter
  labels:
    name: jupyter
```

- __`apiVersion`__: Define a versão da API usada para o namespace.
- __`kind`__: Tipo de recurso (Namespace).
- __`metadata`__: Informações sobre o namespace, incluindo nome e labels.

---

Este guia fornece uma visão abrangente de cada etapa do processo de configuração e deploy do Jupyter Notebook, detalhando o propósito e a importância de cada comando e configuração.
