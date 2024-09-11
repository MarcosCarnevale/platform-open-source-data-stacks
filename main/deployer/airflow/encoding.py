import os
import base64

def encode_credentials(username, password):
    encoded_username = base64.b64encode(username.encode()).decode()
    encoded_password = base64.b64encode(password.encode()).decode()

    return encoded_username, encoded_password

def create_yaml(encoded_username, encoded_password):
    secret_yaml = f"""
    apiVersion: v1
    kind: Secret
    metadata:
    name: git-credentials
    data:
        GIT_SYNC_USERNAME: {encoded_username}
        GIT_SYNC_PASSWORD: {encoded_password}
    """
    # Saida na mesma pasta que o script ./pasta_do_script/credentials/git-credentials.yaml
    out = os.path.join(os.path.dirname(__file__), 'credentials/')
    file_name = 'git-credentials.yaml'

    # cria pasta se não existir
    os.makedirs(os.path.dirname(out), exist_ok=True)

    with open(f"{out}{file_name}", 'w') as f:
        f.write(secret_yaml)

create_yaml(*encode_credentials(os.environ['GIT_SYNC_USERNAME'], os.environ['GIT_SYNC_PASSWORD']))

