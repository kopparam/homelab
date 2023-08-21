#!/bin/bash

export KEYCLOAK_DB_PASSWORD=`cat /run/secrets/keycloak-db-password`
export PGPASSWORD=`cat /run/secrets/postgres-db-password`

# Create keycloak user and database and grant user all permissions to the database using postgres user login
psql -U postgres -c "CREATE USER $KEYCLOAK_DB_USER WITH PASSWORD '$KEYCLOAK_DB_PASSWORD';" \
    -c "CREATE DATABASE $KEYCLOAK_DB_NAME WITH OWNER $KEYCLOAK_DB_USER;"

echo "Created Keycloak user and DB, finished initialization."
