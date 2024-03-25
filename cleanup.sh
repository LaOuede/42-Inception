#!/bin/bash

# Source the .env file to load LOGIN and DOMAIN_NAME variables
source srcs/.env

# Edit the LOGIN variable in server_name
sed "s/${LOGIN}/login/g" srcs/requirements/nginx/conf/nginx.conf >/dev/null 2>&1
sed "s/${LOGIN}/login/g" srcs/requirements/nginx/Dockerfile >/dev/null 2>&1
# To keep for evaluation !!!
#rm -rf srcs/.env .env.make
rm -rf .env.make
