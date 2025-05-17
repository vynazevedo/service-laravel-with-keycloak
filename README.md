# service-laravel-with-keycloak

POC simples de autenticação usando Laravel + Keycloak.

Este repositório mostra como integrar um projeto Laravel com o Keycloak, utilizando Docker para facilitar o setup do ambiente.

#### Instalar o laravel via docker usando a imagem do composer oficial no diretório src/
```bash
docker run --rm -v $(pwd)/src:/app -w /app composer create-project --prefer-dist laravel/laravel .
```
