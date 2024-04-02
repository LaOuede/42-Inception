#!/bin/sh
# ./srcs/requirements/tools/set_permissions.sh 2>/dev/null

# Set owner
sudo chown -R gle-roux:gle-roux ../42-Inception/

# Set file permissions
sudo chmod 664 Makefile
sudo chmod 664 srcs/docker-compose.yml
sudo chmod 664 srcs/.env
sudo chmod 664 srcs/requirements/mariadb/Dockerfile
sudo chmod 664 srcs/requirements/nginx/Dockerfile
sudo chmod 664 srcs/requirements/wordpress/Dockerfile

# Set executable permissions for scripts
sudo chmod 775 srcs/requirements/mariadb/tools/config_db.sh
sudo chmod 775 srcs/requirements/nginx/conf/nginx.conf
sudo chmod 775 srcs/requirements/wordpress/tools/config_wp.sh
sudo chmod 775 srcs/requirements/tools/cleanup.sh
sudo chmod 775 srcs/requirements/tools/setup.sh

# Set directory permissions
sudo chmod 775 srcs/
sudo chmod 775 srcs/requirements/
sudo chmod 775 srcs/requirements/mariadb/
sudo chmod 775 srcs/requirements/nginx/
sudo chmod 775 srcs/requirements/wordpress/
sudo chmod 775 srcs/requirements/tools/
sudo chmod 775 srcs/requirements/mariadb/tools/
sudo chmod 775 srcs/requirements/nginx/conf/
sudo chmod 775 srcs/requirements/wordpress/tools/