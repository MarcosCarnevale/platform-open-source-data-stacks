from airflow import DAG
from airflow.operators.python_operator import ShortCircuitOperator
from datetime import datetime
import json

# Definir a função de tarefa
def print_success_json():
    success_message = {
        "status": "success",
        "message": "DAG executed successfully"
    }
    print(json.dumps(success_message))

def print_failure_json():
    failure_message = {
        "status": "failure",
        "message": "DAG failed to execute"
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

# Adicionar a tarefa ao DAG
print_json_task_success = ShortCircuitOperator(
    task_id='print_json_task_success',
    python_callable=print_success_json,
    dag=dag
)

print_json_task_failure = ShortCircuitOperator(
    task_id='print_json_task_failure',
    python_callable=print_failure_json,
    dag=dag
)

print_json_task_success >> print_json_task_failure