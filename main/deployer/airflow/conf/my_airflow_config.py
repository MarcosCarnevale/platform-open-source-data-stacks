import os
from logging.config import dictConfig

LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'airflow': {
            'format': '[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s',
            'datefmt': '%Y-%m-%d %H:%M:%S',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'airflow',
            'stream': 'ext://sys.stdout',
        },
        'task': {
            'class': 'logging.handlers.RotatingFileHandler',
            'formatter': 'airflow',
            'filename': os.path.join(os.getenv('AIRFLOW_HOME', '/opt/airflow'), 'logs/task.log'),
            'maxBytes': 10485760,  # 10MB
            'backupCount': 5,
            'encoding': 'utf-8',
        },
    },
    'loggers': {
        'airflow': {
            'handlers': ['console', 'task'],
            'level': 'INFO',
            'propagate': False,
        },
    }
}

dictConfig(LOGGING_CONFIG)