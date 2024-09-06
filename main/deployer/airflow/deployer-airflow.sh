#!/bin/bash

# 1. criando cluster ja com as configurações de worker nodes
kind create cluster --name airflow-cluster --config ./main/deployer/airflow/kind-cluster.yaml

# Aqui estamos criando um cluster chamado airflow-cluster com as configurações do arquivo kind-cluster.yaml
# Previamente configuramos para subir o cluster com 3 worker nodes
# Motivo: O Airflow é uma ferramenta que demanda bastante processamento, então é interessante subir o cluster com mais de um worker node
# assim podemos distribuir a carga de trabalho entre os nodes e paralelizar a execução de tarefas

# 2. Verificando se o cluster foi criado com sucesso
kubectl cluster-info --context kind-airflow-cluster

# No caso de sucesso, o comando acima deve retornar o endereço do cluster
# que por ser um aplicativo local, deve ser algo como http://127.0.0.1:<port>

# 3. Verificando os nodes do cluster
kubectl get nodes -o wide

# O comando acima deve retornar os 3 worker nodes que configuramos no arquivo kind-cluster.yaml
# todos os nodes devem estar com o status Ready

# 4. Criando namespace para o Airflow
kubectl apply -f ./main/deployer/airflow/airflow-namespace.yaml

# Nesta etapa estamos criando um namespace chamado airflow para isolar o ambiente
# Importante: Isolar o ambiente é uma prática recomendada para evitar conflitos entre aplicações
# dado que trabalharemos com múltiplos serviços, é interessante manter o ambiente isolado

# 5. Validando a criação do namespace
kubectl get ns

# O comando acima deve retornar a lista de namespaces do cluster
# dentre eles, deve constar o namespace airflow
# se preferir, você pode filtrar o resultado para exibir apenas o namespace airflow
# basta executar o comando: kubectl get ns | grep airflow ou kubectl get ns airflow

# 6. Adicionando o repositório do Airflow
helm repo add apache-airflow https://airflow.apache.org/

# Aqui estamos adicionando o repositório do Airflow ao Helm
# O Helm é um gerenciador de pacotes para Kubernetes, ele facilita a instalação e atualização de aplicações no cluster
# Assim dispensando a necessidade de criar manifestos yaml para cada aplicação
# O Helm trabalha com repositórios, onde cada repositório contém os pacotes das aplicações
# No caso do Airflow, o repositório é mantido pela Apache Software Foundation

# 7. Atualizando o repositório
helm repo update

# O comando acima atualiza a lista de pacotes disponíveis no repositório
# é importante manter o repositório atualizado para garantir que estamos instalando a versão mais recente da aplicação
# além disso, o comando também verifica se o repositório está acessível
# Importante: Caso não haja a necessidade de atualizar o repositório, você pode pular esta etapa, 
# dado que a atualização para uma nova versão pode levar algum tempo.

# 8. Validando o repositório
helm search repo apache-airflow

# O comando acima deve retornar a lista de pacotes disponíveis no repositório do Airflow
# caso a conexão com o repositório esteja funcionando corretamente, você verá a lista de pacotes disponíveis

# 9. Instalando o Airflow
helm install airflow apache-airflow/airflow --namespace airflow --debug --timeout 10m0s

# Aqui estamos instalando o Airflow no cluster Kubernetes
# O comando acima instala o pacote airflow do repositório apache-airflow no namespace airflow
# é recomendado utilizar a chamada --debug para exibir informações detalhadas sobre a instalação
# o parâmetro --timeout 10m0s define um tempo limite de 10 minutos para a instalação
# Visto que, em condiçoes normais a instalação deve ser concluída em torno de 5min, caso ultrapasse este tempo,
# é possível que haja algum problema na instalação
# Neste caso o --debug será útil para identificar o problema

# 10. Validando a instalação
kubectl get pods -n airflow

# root@DESKTOP-O00CRK5:./platform-open-source-data-stacks# kubectl get pods -n airflow
# NAME                                 READY   STATUS    RESTARTS        AGE
# airflow-postgresql-0                 1/1     Running   0               10m
# airflow-redis-0                      1/1     Running   0               10m
# airflow-scheduler-95c96c679-mjlbz    2/2     Running   0               10m
# airflow-statsd-769b757665-l859q      1/1     Running   0               10m
# airflow-triggerer-0                  2/2     Running   0               10m
# airflow-webserver-799df6464d-gn89q   1/1     Running   1 (5m39s ago)   10m
# airflow-worker-0                     2/2     Running   0               10m

# O comando acima deve retornar a lista de pods do namespace airflow
# todos os pods devem estar com o status Running
# caso algum pod esteja com o status diferente, é possível que haja algum problema na instalação
# neste caso, você pode verificar os logs do pod para identificar o problema

# 11.

# 12. Exibindo informações sobre o Airflow
helm show values apache-airflow/airflow > ./main/deployer/airflow/values.yaml

# O comando acima exibe as informações sobre o pacote airflow do repositório apache-airflow
# e redireciona a saída para o arquivo values.yaml
# este arquivo contém as configurações padrão do Airflow, como por exemplo, as configurações do banco de dados
# você pode editar este arquivo para personalizar as configurações do Airflow de acordo com suas necessidades
# Importante: O arquivo values.yaml é um arquivo de configuração do Helm, ele é utilizado para definir as configurações
# do pacote que será instalado no cluster Kubernetes
# caso você deseje alterar as configurações do Airflow, você pode editar este arquivo e depois instalar o Airflow novamente
# para aplicar as alterações
# Modo de uso: helm install airflow apache-airflow/airflow --namespace airflow -f ./main/deployer/airflow/values.yaml

# Faremos duas modificações no arquivo values.yaml:

# 1. Configuração do executor:
# executor: CeleryExecutor (default)
# executor: KubernetesExecutor (modificado)

# 2. Configuração de Variáveis de Ambiente:
# extraEnvFrom: ~ (default)
# extraEnvFrom: |
#   - configMapRef:
#       name: 'airflow-variables'

# O primeiro passo é alterar o executor de CeleryExecutor para KubernetesExecutor
# O executor é responsável por executar as tarefas do Airflow, o executor padrão é o CeleryExecutor
# que utiliza o Celery como mecanismo de execução de tarefas
# no entanto, para este ambiente, utilizaremos o KubernetesExecutor, que executa as tarefas em pods do Kubernetes
# o KubernetesExecutor é mais adequado para ambientes Kubernetes, pois aproveita a escalabilidade e a tolerância a falhas do Kubernetes

# O segundo passo é adicionar a configuração de variáveis de ambiente
# as variáveis de ambiente são utilizadas para configurar o ambiente de execução do Airflow
# neste caso, estamos apontando para um ConfigMap chamado airflow-variables contido no arquivo variables.yaml
# o ConfigMap é uma forma de armazenar configurações e dados sensíveis no Kubernetes de maneira segura


# 13. Aplicando variáveis de ambiente para o Airflow
kubectl apply -f ./main/deployer/airflow/variables.yaml

# O comando acima aplica as variáveis de ambiente para o Airflow
# as variáveis de ambiente são utilizadas para configurar o ambiente de execução do Airflow
# neste caso, estamos definindo as variáveis de ambiente para o Airflow, como por exemplo, o AIRFLOW_VAR_MY_S3_BUCKET

# 14. Validando a aplicação das variáveis de ambiente
helm ls -n airflow

# O comando acima deve retornar a lista de releases no namespace airflow
# você deve perceber que temos na saida 1 REVISON, decorrente da atualização das variáveis de ambiente

# 15. Atualizando o Airflow com as variáveis de ambiente
helm upgrade --install airflow apache-airflow/airflow -n airflow -f ./main/deployer/airflow/values.yaml --debug

# O comando acima instala o Airflow no namespace airflow com as configurações personalizadas do arquivo values.yaml
# este arquivo contém as configurações padrão do Airflow, você pode editá-lo para personalizar as configurações do Airflow
# de acordo com suas necessidades
# Importante: O arquivo values.yaml é um arquivo de configuração do Helm, ele é utilizado para definir as configurações
# do pacote que será instalado no cluster Kubernetes
# caso você deseje alterar as configurações do Airflow, você pode editar este arquivo e depois instalar o Airflow novamente
# para aplicar as alterações

# 16. Validando a atualização
kubectl get pods -n airflow

helm ls -n airflow

# 17.

# 18. Validando as variáveis de ambiente foram aplicadas
kubectl exec --stdin --tty airflow-webserver-596bdcfd74-nqq6x -n airflow -- /bin/bash -c python3 -c

# O comando acima executa um comando no pod airflow-webserver no namespace airflow
# neste caso, estamos executando o comando python3 -c para exibir as variáveis de ambiente do Airflow
# você deve ver a lista de variáveis de ambiente que foram aplicadas anteriormente
# use o comando "from airflow.models import Variable; print(Variable.get('MY_S3_BUCKET'))", exit()" para exibir o valor da variável MY_S3_BUCKET

# 19.  Acessando o Airflow
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow
echo "Visit http://127.0.0.1:8080 to use Airflow"

# O comando acima cria um encaminhamento de porta para o serviço airflow-webserver no namespace airflow
# assim, é possível acessar o Airflow através do endereço http://127.0.0.1:8080
# este é o endereço padrão do Airflow, onde você pode acessar o painel de controle e gerenciar seus DAGs
# Importante: O comando acima deve ser executado no terminal onde o cluster foi criado
# caso contrário, o encaminhamento de porta não será efetuado corretamente
# Importante: O encaminhamento de porta é uma forma de acessar serviços que não estão expostos externamente
# através de um endereço local, caso a porta 8080 esteja em uso, você pode alterar a porta de encaminhamento
# basta alterar o segundo valor do comando, por exemplo: kubectl port-forward svc/airflow-webserver 8081:8080 -n airflow
# neste caso, o Airflow estará acessível através do endereço http://127.0.0.1:8081



