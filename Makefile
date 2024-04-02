#------------------------------------------------------------------------------#
#                                COLOR SETTINGS                                #
#------------------------------------------------------------------------------#
W		:= \033[0m
G		:= \033[1;32m
Y		:= \033[1;33m


#------------------------------------------------------------------------------#
#                                     RULES                                    #
#------------------------------------------------------------------------------#
all: set_permissions setup up

set_permissions:
	@echo "\n----------------- $YSetting permissions $W-----------------"
	./srcs/requirements/tools/set_permissions.sh 2>/dev/null
	@echo "-------------------------------------------------------\n"

setup:
	@echo "\n-------------------- $YConfiguration $W--------------------"
	@echo "Running configuration script :"
	@echo " ...User set as: ${LOGIN}"
	@./srcs/requirements/tools/setup.sh 2>/dev/null
	@echo " ...Host configuration is done"
	@mkdir -p ${PATH_DATA}
	@mkdir -p ${PATH_DATA}/mariadb-data
	@mkdir -p ${PATH_DATA}/wordpress-data
	@echo " ...data dir. created for mariadb and wordpress"
	@echo "Configuration is $Gdone$W"
	@echo "-------------------------------------------------------\n"

up: setup
	@echo "---------------------- $YBuilding $W-----------------------"
	docker-compose -f ${DC_FILE} up --detach --build --remove-orphans
	@echo "-------------------------------------------------------\n"

start:
	@docker-compose -f ${DC_FILE} up --detach --no-build

stop:
	@echo "---------------------- $YStopping $W-----------------------"
	@docker-compose -f ${DC_FILE} stop
	@echo "-------------------------------------------------------\n"

fclean: stop
	@echo "---------------------- $YCleaning$W -----------------------"
	@./srcs/requirements/tools/cleanup.sh
	@sudo rm -rf ${PATH_DATA}
	@docker-compose -f ${DC_FILE} down --volumes --remove-orphans
	@yes | docker container prune
	@yes | docker image prune -a
	@echo "-------------------------------------------------------\n"

re: fclean all


#------------------------------------------------------------------------------#
#                                   SETTINGS                                   #
#------------------------------------------------------------------------------#
# Include environment variables
-include .env.make

# Docker Compose file
DC_FILE := ./srcs/docker-compose.yml

# Convert .env to Makefile format
.env.make: srcs/.env
	@sudo cat srcs/.env | sed 's/=/?=/g' > .env.make


#------------------------------------------------------------------------------#
#                                     TOOLS                                    #
#------------------------------------------------------------------------------#
# Docker build targets
build: build-nginx build-mariadb build-wordpress

build-nginx:
	docker build -t nginx srcs/requirements/nginx/

build-mariadb:
	docker build -t mariadb srcs/requirements/mariadb/

build-wordpress:
	docker build -t wordpress srcs/requirements/wordpress/

# Docker run targets for testing
run: run-nginx run-mariadb run-wordpress

run-nginx:
	docker run -ti --name nginx-test -p 443:443 -d nginx

run-mariadb:
	docker run -ti --name mariadb-test -d mariadb

run-wordpress:
	docker run -ti --name wordpress-test -d wordpress

# Docker exec shortcuts
mysql:
	docker exec -it mariadb mysql -u root -p'${DB_ROOT}'

mysql-test:
	docker exec -it mariadb-test mysql -u root -p'${DB_ROOT}'

bash-mariadb:
	docker exec -it mariadb bash

bash-wordpress:
	docker exec -it wordpress bash

# Docker logs targets
logs: logs-mariadb logs-wordpress

logs-mariadb:
	docker logs -f mariadb

logs-wordpress:
	docker logs -f wordpress

# List running containers
list:
	cd srcs && docker-compose ps
# docker ps -a

# Volumes list and inspect
volume:
	docker volume ls

inspect-mariadb:
	docker volume inspect 'srcs_mariadb-vol'

inspect-wordpress:
	docker volume inspect 'srcs_wordpress-vol'

# list networks
network:
	docker network ls

# Stop test containers
stop-test: stop-nginx stop-mariadb

stop-nginx:
	docker stop nginx-test

stop-mariadb:
	docker stop mariadb-test

stop-wordpress:
	docker stop wordpress-test


#------------------------------------------------------------------------------#
#                                   HELP MENU                                  #
#------------------------------------------------------------------------------#
help:
	@echo "Usage: make [command]"
	@echo "Commands:"
	@echo "  all               $(G)Build all images and launch the containers$(W)"
	@echo "  bash-mariadb      $(G)Access bash shell in the MariaDB container$(W)"
	@echo "  bash-wordpress    $(G)Access bash shell in the WordPress container$(W)"
	@echo "  build             $(G)Build all Docker images (Nginx, MariaDB, WordPress)$(W)"
	@echo "  build-mariadb     $(G)Build the MariaDB Docker image$(W)"
	@echo "  build-nginx       $(G)Build the Nginx Docker image$(W)"
	@echo "  build-wordpress   $(G)Build the WordPress Docker image$(W)"
	@echo "  fclean            $(G)Remove all containers, images, volumes, and custom networks$(W)"
	@echo "  inspect-mariadb   $(G)Inspect the MariaDB volume$(W)"
	@echo "  inspect-wordpress $(G)Inspect the WordPress volume$(W)"
	@echo "  list              $(G)List all running containers using docker-compose ps$(W)"
	@echo "  logs-mariadb      $(G)Tail logs from the MariaDB container$(W)"
	@echo "  logs-wordpress    $(G)Tail logs from the WordPress container$(W)"
	@echo "  mysql             $(G)Access MariaDB MySQL prompt$(W)"
	@echo "  mysql-test        $(G)Access MariaDB MySQL prompt in a test container$(W)"
	@echo "  network           $(G)List all Docker networks$(W)"
	@echo "  re                $(G)Rebuild and restart the containers$(W)"
	@echo "  run-mariadb       $(G)Run MariaDB container in detached mode$(W)"
	@echo "  run-nginx         $(G)Run Nginx container in detached mode$(W)"
	@echo "  run-wordpress     $(G)Run WordPress container in detached mode$(W)"
	@echo "  setup             $(G)Prepare environment, directories for data$(W)"
	@echo "  start             $(G)Alias for 'up', start services in background without rebuild$(W)"
	@echo "  stop              $(G)Stop services defined in docker-compose.yml$(W)"
	@echo "  stop-mariadb      $(G)Stop the MariaDB test container$(W)"
	@echo "  stop-nginx        $(G)Stop the Nginx test container$(W)"
	@echo "  up                $(G)Start services defined in docker-compose.yml in background$(W)"
	@echo "  volume            $(G)List all Docker volumes$(W)"

.PHONY: all stop build run list del fclean down up start setup build-nginx build-mariadb build-wordpress run-nginx run-mariadb run-wordpress logs-mariadb logs-wordpress stop-test stop-nginx stop-mariadb re
