# Contrutor de Arquivos para o Airbyte

Este arquivo define a configuração de um Pod, um Serviço e um Ingress no Kubernetes para a aplicação Airbyte.

## Estrutura do Arquivo

### Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: airbyte-ingestion
  namespace: airbyte-ingestion
spec:
  containers:
    - name: airbyte
      image: airbyte/airbyte:0.26.0
      ports:
      - containerPort: 8000
      resources:
        limits:
          cpu: "1"
          memory: "1Gi"
      volumeMounts:
      - name: airbyte-storage
        mountPath: /data
  volumes:
    - name: airbyte-storage
      persistentVolumeClaim:
        claimName: airbyte-pvc
```

#### Explicação do Pod

- __apiVersion__: Define a versão da API Kubernetes utilizada.
- __kind__: Especifica o tipo de recurso, neste caso, um Pod.
- __metadata__: Metadados do Pod, incluindo o nome e namespace.
- __spec__: Especificações do Pod.
  - __containers__: Lista de containers no Pod.
    - __name__: Nome do container.
    - __image__: Imagem Docker utilizada.
    - __ports__: Portas expostas pelo container.
    - __resources__: Limites de recursos (CPU e memória).
    - __volumeMounts__: Montagem de volumes no container.
  - __volumes__: Volumes utilizados pelo Pod.
    - __persistentVolumeClaim__: Reivindicação de volume persistente.

### Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: airbyte-service
  namespace: airbyte-ingestion
spec:
  selector:
    app: airbyte
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
  type: NodePort
```

#### Explicação

- __apiVersion__: Define a versão da API Kubernetes utilizada.
- __kind__: Especifica o tipo de recurso, neste caso, um Serviço.
- __metadata__: Metadados do Serviço, incluindo o nome e namespace.
- __spec__: Especificações do Serviço.
  - __selector__: Seleciona os Pods que serão gerenciados por este Serviço.
  - __ports__: Portas expostas pelo Serviço.
    - __protocol__: Protocolo utilizado (TCP).
    - __port__: Porta exposta pelo Serviço.
    - __targetPort__: Porta no container que o Serviço irá direcionar.
  - __type__: Tipo de Serviço (NodePort).

### Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: airbyte-ingress
  namespace: airbyte-ingestion
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: airbyte.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: airbyte-service
            port:
              number: 80
```

#### Explicação do Ingress

- __apiVersion__: Define a versão da API Kubernetes utilizada.
- __kind__: Especifica o tipo de recurso, neste caso, um Ingress.
- __metadata__: Metadados do Ingress, incluindo o nome e namespace.
- __annotations__: Anotações adicionais para o Ingress.
  - __nginx.ingress.kubernetes.io/rewrite-target__: Reescreve o caminho da URL.
- __spec__: Especificações do Ingress.
  - __rules__: Regras de roteamento.
    - __host__: Nome do host.
    - __http__: Configurações HTTP.
      - __paths__: Caminhos HTTP.
        - __path__: Caminho da URL.
        - __pathType__: Tipo de caminho (Prefix).
        - __backend__: Backend para onde o tráfego será roteado.
          - __service__: Serviço de backend.
            - __name__: Nome do Serviço.
            - __port__: Porta do Serviço.

## Aplicação dos Recursos

Para aplicar os recursos definidos neste arquivo, utilize o comando:

```sh
kubectl apply -f ./pod.yaml
```

Este comando criará o Pod, o Serviço e o Ingress conforme especificado no arquivo.
