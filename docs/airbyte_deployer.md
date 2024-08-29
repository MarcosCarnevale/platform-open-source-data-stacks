# Descrição do Deployment do Airbyte

Este arquivo YAML é usado para definir e configurar o deployment do Airbyte em um cluster Kubernetes. Aqui está uma explicação detalhada de cada seção:

## airbyte_deployer.yaml

### Metadados e Informações Gerais

- **componente**: Nome do componente, neste caso, [`airbyte_deployer`](.).
- **namespace**: Namespace Kubernetes onde o componente será implantado, [`airbyte`](.).
- **chart**: Nome do Helm chart, [`airbyte`](.).
- **release**: Nome do release, [`airbyte`](.).
- **version**: Versão do release, [`0.1.0`](.).
- **criado em**: Data de criação, [`2024-08-29`](.).

### Objetivo

- Descreve que este componente é responsável por realizar o deploy do Airbyte em um cluster Kubernetes.

### Recursos

- Lista os recursos Kubernetes que serão criados:
  - 1 Deployment
  - 1 Service
  - 1 Ingress
  - 1 PersistentVolume
  - 1 PersistentVolumeClaim

### Dependências

- Indica que não há dependências.

### Configurações

- Nome do release: [`airbyte`](.)
- Namespace: [`airbyte`](.)
- Versão do Chart: [`0.1.0`](.)
- Porta do serviço: [`8000`](.)
- URL de acesso: [`airbyte.local`](.)
- Volume: [`10Gi`](.)

### Comandos

- **Instalação**: [`helm install airbyte airbyte/airbyte -n airbyte -f airbyte_deployer.yaml`](.)
- **Atualização**: [`helm upgrade airbyte airbyte/airbyte -n airbyte -f airbyte_deployer.yaml`](.)
- **Desinstalação**: [`helm uninstall airbyte -n airbyte`](.)

### Notas

- Indica que não há notas adicionais.

### Recursos Kubernetes Definidos

#### Deployment

- **apiVersion**: [`apps/v1`](.)
- **kind**: [`Deployment`](.)
- **metadata**: Nome e namespace do deployment.
- **spec**: Especificações do deployment, incluindo réplicas, seletor de labels, template de pod, containers, portas, variáveis de ambiente e volume mounts.

#### Service

- **apiVersion**: [`v1`](.)
- **kind**: [`Service`](.)
- **metadata**: Nome e namespace do serviço.
- **spec**: Especificações do serviço, incluindo seletor de labels, portas e tipo de serviço ([`NodePort`](.)).

#### Ingress

- **apiVersion**: [`networking.k8s.io/v1`](.)
- **kind**: [`Ingress`](.)
- **metadata**: Nome, namespace e anotações do ingress.
- **spec**: Especificações do ingress, incluindo regras de roteamento HTTP.

#### PersistentVolume

- **apiVersion**: [`v1`](.)
- **kind**: [`PersistentVolume`](.)
- **metadata**: Nome e namespace do volume persistente.
- **spec**: Especificações do volume persistente, incluindo modos de acesso, capacidade e caminho no host.

#### PersistentVolumeClaim

- **apiVersion**: [`v1`](.)
- **kind**: [`PersistentVolumeClaim`](.)
- **metadata**: Nome e namespace da claim.
- **spec**: Especificações da claim, incluindo modos de acesso, recursos solicitados e classe de armazenamento.

#### Namespace

- **apiVersion**: [`v1`](.)
- **kind**: [`Namespace`](.)
- **metadata**: Nome do namespace.

Este arquivo YAML configura todos os recursos necessários para implantar o Airbyte em um cluster Kubernetes, incluindo deployment, serviço, ingress, volumes persistentes e namespace.