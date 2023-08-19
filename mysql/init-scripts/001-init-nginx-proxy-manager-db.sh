#!/bin/sh

echo "** Creating Nginx Proxy Manager DB and user"

source /run/secrets/mysql-secrets

mysql -u root --password=$ROOT_PASSWORD --execute \
"CREATE USER IF NOT EXISTS '$NGINX_PROXY_MANAGER_USER'@'%' IDENTIFIED BY '$NGINX_PROXY_MANAGER_PASSWORD';
CREATE DATABASE IF NOT EXISTS $NGINX_PROXY_MANAGER_DB_NAME;
GRANT ALL PRIVILEGES ON $NGINX_PROXY_MANAGER_DB_NAME.* TO '$NGINX_PROXY_MANAGER_USER'@'%';"

echo "** Finished creating Nginx Proxy Manager DB and user"
