# Criando cluster kind
kind create cluster --name jupyter-cluster

# O comando acima cria um cluster kind com o nome jupyter-cluster
# Para verificar se o cluster foi criado com sucesso, execute o comando abaixo
kubectl cluster-info --context kind-jupyter-cluster

# O comando acima deve retornar algo parecido com isso:
# Kubernetes master is running at https://
# KubeDNS is running at https://
# To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

# Criando namespace jupyter
kubectl apply -f ./main/deployer/jupyter/jupyter-namespace.yaml

# O comando acima cria um namespace chamado jupyter
# Para verificar se o namespace foi criado com sucesso, execute o comando abaixo
kubectl get namespaces

# O comando acima deve retornar algo parecido com isso:
# NAME              STATUS   AGE
# default           Active   2m
# jupyter           Active   1m

# Criando deployment jupyter
kubectl apply -f ./main/deployer/jupyter/jupyter-deployment.yaml

# O comando acima cria um deployment chamado jupyter
# Para verificar se o deployment foi criado com sucesso, execute o comando abaixo
kubectl get deployments -n jupyter

# O comando acima deve retornar algo parecido com isso:
# NAME      READY   UP-TO-DATE   AVAILABLE   AGE
# jupyter   1/1     1            1           1m

# Fazer port-forward para acessar o jupyter
echo "Acesse o jupyter em http://localhost:8888"
kubectl port-forward deployment/jupyter -n jupyter 8888:8888

# O comando acima faz um port-forward do deployment jupyter para a porta 8888
# Para acessar o jupyter, abra o navegador e acesse http://localhost:8888
# Será solicitado um token, copie e cole o token gerado no terminal

# Para recuperar o token do jupyter, execute o comando abaixo
# Captura o token do Jupyter Notebook
JUPYTER_TOKEN=$(kubectl exec -it $(kubectl get pods -n jupyter -o name | cut -d/ -f2) -n jupyter -- bash -c "jupyter notebook list" | grep http | cut -d' ' -f1 | cut -d'=' -f2)

# Exibe o token
# echo "Jupyter Notebook Token: $JUPYTER_TOKEN"

echo "Para acessar o jupyter, abra o navegador e acesse http://localhost:8888?token=$JUPYTER_TOKEN"
