from airflow import DAG

dag = DAG(
    dag_id='dummy_dag',
    schedule_interval='@daily'
)