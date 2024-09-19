from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime
import json
import time

# Definir a função de tarefa de sucesso
def print_success_json():
    for i in range(180):
        print(f"Task is running for {i} seconds")
        time.sleep(1)
    success_message = {
        "status": "success",
        "message": "DAG executed successfully"
    }
    print(json.dumps(success_message))

# Definir a função de tarefa de falha
def print_failure_json():
    failure_message = {
        "status": "failure",
        "message": "DAG execution failed"
    }
    print(json.dumps(failure_message))

# Criar o DAG
dag = DAG(
    dag_id='dummy_dag_with_success_json',
    default_args={
        'owner': 'airflow',
        'start_date': datetime(2023, 1, 1),
    },
    schedule_interval=None
)

# Adicionar as tarefas ao DAG
print_json_task_success = PythonOperator(
    task_id='print_json_task_success',
    python_callable=print_success_json,
    dag=dag
)

print_json_task_failure = PythonOperator(
    task_id='print_json_task_failure',
    python_callable=print_failure_json,
    dag=dag
)

# Definir a ordem das tarefas
print_json_task_success >> print_json_task_failure