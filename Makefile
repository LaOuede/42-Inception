#------------------------------------------------------------------------------#
#                                   COLOR SETTINGS                             #
#------------------------------------------------------------------------------#
W		:= \033[0m
G		:= \033[1;32m
Y		:= \033[1;33m

# Include environment variables
-include .env.make

# Convert .env to Makefile format
.env.make: srcs/.env
	@cat srcs/.env | sed 's/=/?=/g' > .env.make

# Docker tasks
all: setup up

build-nginx:
	docker build -t nginx srcs/requirements/nginx/

build-mariadb:
	docker build -t mariadb srcs/requirements/mariadb/

build-wordpress:
	docker build -t wordpress srcs/requirements/wordpress/

run-nginx:
	docker run -ti --name nginx-test -p 443:443 -d nginx

run-mariadb:
	docker run -ti --name mariadb-test -d mariadb

run-wordpress:
	docker run -ti --name wordpress-test -d wordpress

mysql:
	docker exec -it mariadb mysql -u root -p'${DB_ROOT}'

mysql-test:
	docker exec -it mariadb-test mysql -u root -p'${DB_ROOT}'

bash-mariadb:
	docker exec -it mariadb bash

logs-mariadb:
	docker logs mariadb

list:
	docker ps -a

stop-nginx:
	docker stop nginx-test

stop-mariadb:
	docker stop mariadb-test

setup:
	@echo "\n-------------------- $YConfiguration $W--------------------"
	@echo "Running configuration script :"
	@echo " ...User set as: ${LOGIN}"
	@./env_config.sh 2>/dev/null
	@echo " ...Host configuration is done"
	@mkdir -p ${PATH_DATA}
	@mkdir -p ${PATH_DATA}/mariadb-data
	@mkdir -p ${PATH_DATA}/wordpress-data
	@echo " ...data dir. created for mariadb and wordpress"
	@echo "Configuration is $Gdone$W"
	@echo "------------------------------------------------------\n"

up: setup
	@echo "---------------------- $YBuilding $W-----------------------"
	@docker-compose -f ./srcs/docker-compose.yml up --detach --build --remove-orphans
	@echo "-------------------------------------------------------\n"

stop:
	@echo "---------------------- $YStopping $W-----------------------"
	@docker-compose -f ./srcs/docker-compose.yml stop
	@echo "-------------------------------------------------------\n"

fclean: stop
	@echo "---------------------- $YCleaning$W -----------------------"
	@./cleanup.sh
	@sudo rm -rf ${PATH_DATA}
	@docker-compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans
	@yes | docker container prune
	@yes | docker image prune -a
	@echo "-------------------------------------------------------\n"

re: fclean all

.PHONY: all stop build run list del fclean down up