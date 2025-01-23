#!/bin/bash

KEYCLOAK_URL="http://localhost:8080"
REALM_NAME="service-laravel-with-keycloak-realm"
CLIENT_ID="service-laravel"

TOKEN=$(curl -X POST "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
    -d "username=admin" \
    -d "password=admin" \
    -d "grant_type=password" \
    -d "client_id=admin-cli" | grep -o '"access_token":"[^"]*' | sed 's/"access_token":"//')

curl -X POST "${KEYCLOAK_URL}/admin/realms" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{
        "realm": "'${REALM_NAME}'",
        "enabled": true,
        "loginWithEmailAllowed": true,
        "registrationAllowed": true
    }'

CLIENT_SECRET=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

curl -X POST "${KEYCLOAK_URL}/admin/realms/${REALM_NAME}/clients" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{
        "clientId": "'${CLIENT_ID}'",
        "secret": "'${CLIENT_SECRET}'",
        "enabled": true,
        "publicClient": false,
        "redirectUris": ["http://localhost:8000/*"],
        "webOrigins": ["*"],
        "protocol": "openid-connect",
        "standardFlowEnabled": true
    }'

curl -X POST "${KEYCLOAK_URL}/admin/realms/${REALM_NAME}/roles" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{"name": "admin"}'

curl -X POST "${KEYCLOAK_URL}/admin/realms/${REALM_NAME}/roles" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{"name": "user"}'

curl -X POST "${KEYCLOAK_URL}/admin/realms/${REALM_NAME}/users" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{
        "username": "admin@local.com",
        "email": "admin@local.com",
        "enabled": true,
        "emailVerified": true,
        "credentials": [{"type": "password", "value": "admin123", "temporary": false}]
    }'

curl -X POST "${KEYCLOAK_URL}/admin/realms/${REALM_NAME}/users" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d '{
        "username": "user@local.com",
        "email": "user@local.com",
        "enabled": true,
        "emailVerified": true,
        "credentials": [{"type": "password", "value": "user123", "temporary": false}]
    }'

REALM_PUBLIC_KEY=$(curl -s -X GET "${KEYCLOAK_URL}/realms/${REALM_NAME}" | grep -o '"public_key":"[^"]*' | sed 's/"public_key":"//')

echo "
====== DADOS PARA CONFIGURAÇÃO DO LARAVEL (.env) ======

KEYCLOAK_BASE_URL=http://localhost:8080
KEYCLOAK_REALM=${REALM_NAME}
KEYCLOAK_CLIENT_ID=${CLIENT_ID}
KEYCLOAK_CLIENT_SECRET=${CLIENT_SECRET}
KEYCLOAK_REALM_PUBLIC_KEY=${REALM_PUBLIC_KEY}

====== USUÁRIOS CRIADOS ======
Admin: admin@local.com / admin123
User:  user@local.com / user123

====== ROLES CRIADAS ======
- admin
- user
"
