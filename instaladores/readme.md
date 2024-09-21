# Instalação Básica
Scripts para instalar programas básicos do projeto.

Antes de instalar o que está contido nessa pasta instale o WSL e configure no Docker, qualquer dúvida veja a documentação de como habilitar funcionalidade no Docker [**Link Docker**](https://docs.docker.com/desktop/wsl/)

Feito isso e com o WSL rodando no Visual Studio execute o seguinte comando para ajustar a sed do arquivo de execução.
```sh
sed -i -e 's/\r$//' instaladores/install_all.sh
```

Em seguida basta executar o script **install_all.sh**
```sh
./instaladores/install_all.sh
```