#!/bin/bash

# Source the .env file to load LOGIN and DOMAIN_NAME variables
source srcs/.env

# Edit the LOGIN variable in server_name
sed "s/${LOGIN}/login/g" srcs/requirements/nginx/conf/nginx.conf
sed "s/${LOGIN}/login/g" srcs/requirements/nginx/Dockerfile
rm -rf srcs/.env .env.make
