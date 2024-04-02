#!/bin/sh
# Set file permissions
sudo chmod 664 Makefile
sudo chmod 664 srcs/docker-compose.yml
sudo chmod 664 srcs/.env
sudo chmod 664 requirements/mariadb/Dockerfile
sudo chmod 664 requirements/nginx/Dockerfile
sudo chmod 664 requirements/wordpress/Dockerfile

# Set executable permissions for scripts
sudo chmod 775 requirements/mariadb/tools/config_db.sh
sudo chmod 775 requirements/nginx/conf/nginx.conf
sudo chmod 775 requirements/wordpress/tools/config_wp.sh
sudo chmod 775 requirements/tools/cleanup.sh
sudo chmod 775 requirements/tools/setup.sh

# Set directory permissions
sudo chmod 775 srcs/
sudo chmod 775 requirements/
sudo chmod 775 requirements/mariadb/
sudo chmod 775 requirements/nginx/
sudo chmod 775 requirements/wordpress/
sudo chmod 775 requirements/tools/
sudo chmod 775 requirements/mariadb/tools/
sudo chmod 775 requirements/nginx/conf/
sudo chmod 775 requirements/wordpress/tools/