FROM apache/airflow:2.9.3

# Install additional packages
COPY requirements.txt .

# Install vim and nano
USER root
RUN apt-get update && apt-get install -y vim nano

# Install Python packages
USER airflow
RUN pip install -r requirements.txt