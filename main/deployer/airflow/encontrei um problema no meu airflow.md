encontrei um problema no meu airflow

quando inicio 

# Airflow log dag

## Problema

Os logs da execução da DAG não ficam persistidos após a execução da DAG.

## Cenario de uso

1. Executar uma DAG

- DAG: dummy_dag_with_success_json
  - Task: print_json_task_success
  - Task: print_json_task_fail

Ao executar a DAG a task print_json_task_success meu cluster kubernetes sobe um pod e executa a task com sucesso

__POD:__ `dummy-dag-with-success-json-print-json-task-success-3ujpfq6i`

os logs da execução da task print_json_task_success são exibidos no airflow, pois os mesmos estão sendo persistidos em:

`airflow@dummy-dag-with-success-json-print-json-task-success-3ujpfq6i:/opt/airflow$ cat logs/dag_id\=dummy_dag_with_success_json/run_id\=manual__2024-09-19T15\:55\:43.096508+00\:00/task_id\=print_json_task_success/attempt\=1.log`

Acontece que após a execução da DAG os logs são apagados pois o pod é deletado.

Como posso persistir os logs da execução da DAG?

## Solução

Para persistir os logs da execução da DAG é necessário configurar o `airflow` para armazenar os logs em um volume persistente.

## Configuração

1. Configurar o `airflow` para armazenar os logs em um volume persistente.

```yaml
# Criando um volume persistente
apiVersion: v1
kind: PersistentVolume
metadata:
  name: airflow-logs
spec:
    capacity:
        storage: 1Gi
    accessModes:
        - ReadWriteOnce
    hostPath:
        /opt/airflow/logs
    
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: airflow-logs
spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
        storage: 1Gi
```

2. Configurar o `airflow` para usar o volume persistente

```yaml
# Configuração do volume persistente
env:
  - name: AIRFLOW__CORE__DAGS_FOLDER
    value: /opt/airflow/dags
  - name: AIRFLOW__CORE__LOGGING_CONFIG_CLASS
    value: 'airflow.utils.log.file_task_handler.FileTaskHandler'
  - name: AIRFLOW__CORE__LOGGING_CONFIG_DICT
    value: '{"handlers": {"task": {"class": "airflow.utils.log.file_task_handler.FileTaskHandler", "formatter": "airflow", "base_log_folder": "/opt/airflow/logs", "filename_template": "{{ ti.dag_id }}/{{ ti.task_id }}/{{ ts }}/{{ try_number }}.log", "base_log_folder": "/opt/airflow/logs"}}}'
```

3. Aplique as configurações

```bash
kubectl apply -f airflow-logs.yaml
```
