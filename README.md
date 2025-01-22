# service-laravel-with-keycloak

#### Instalar o laravel via docker usando a imagem do composer oficial no diretório src/
docker run --rm -v $(pwd)/src:/app -w /app composer create-project --prefer-dist laravel/laravel .
