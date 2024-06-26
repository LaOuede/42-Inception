#!/bin/bash

# Source the .env file to load LOGIN and DOMAIN_NAME variables
source srcs/.env

# Edit the LOGIN variable in server_name
sed "s/login/${LOGIN}/g" srcs/requirements/nginx/conf/nginx.conf >/dev/null 2>&1
sed "s/login/${LOGIN}/g" srcs/requirements/nginx/Dockerfile >/dev/null 2>&1

# Configure hosts
if ! grep -q ${DOMAIN_NAME} "/etc/hosts"; then
	echo "127.0.0.1 ${DOMAIN_NAME}" | sudo tee -a /etc/hosts
fi
