#!/bin/sh

echo "** Creating Nginx Proxy Manager DB and user"

source /run/secrets/mysql-secrets


# Using mysql_native_password for compatibility with older client used in Nginx Proxy Manager
mysql -u root --password=$ROOT_PASSWORD --execute \
"CREATE USER IF NOT EXISTS '$NGINX_PROXY_MANAGER_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$NGINX_PROXY_MANAGER_PASSWORD';
CREATE DATABASE IF NOT EXISTS $NGINX_PROXY_MANAGER_DB_NAME;
GRANT ALL PRIVILEGES ON $NGINX_PROXY_MANAGER_DB_NAME.* TO '$NGINX_PROXY_MANAGER_USER'@'%';"

echo "** Finished creating Nginx Proxy Manager DB and user"
