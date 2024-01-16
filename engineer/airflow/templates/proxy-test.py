from airflow import DAG
# import PythonOperator class from operators.python_operator module
# import PostgresHook class from hooks.postgres_hook module
from datetime import datetime

def test():
    pg_hook = PostgresHook(postgres_conn_id='postgres_default')
    select_sql = f'SELECT * FROM branches'
    connection = pg_hook.get_conn()
    cursor = connection.cursor()
    cursor.execute(select_sql)

default_args = {
    'owner': 'sbcl',
    'depends_on_past': False,
    'start_date': datetime(2022, 1, 1),
    'retries': 0,
}

dag = DAG(
    #dag name,
    default_args=#dag args,
    description='Make sure Cloud Proxy works',
    schedule_interval=None,
)

test = #python operator(
    task_id=f'test',
    python_callable=test,
    dag=dag
)

test