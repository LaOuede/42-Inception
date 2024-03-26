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
all: setup

build-nginx:
	docker build -t nginx srcs/requirements/nginx/

build-mariadb:
	docker build -t mariadb srcs/requirements/mariadb/

run-nginx:
	docker run -ti --name nginx-test -p 443:443 -d nginx

run-mariadb:
	docker run -ti --name mariadb-test -d mariadb

db:
	docker exec -it mariadb-test mysql -u root -p'${DB_ROOT}'

list:
	docker ps -a

stop-nginx:
	docker stop nginx-test

stop-mariadb:
	docker stop mariadb-test

del:
	@echo "-------------------- $YCleaning $W---------------------"
	@yes | docker container prune
	@yes | docker image prune -a

setup:
	@echo "\n------------------ $YConfiguration $W------------------"
	@echo "Running configuration script :"
	@echo " ...User set as: ${LOGIN}"
	@echo " ...Host configuration is done"
	@./env_config.sh 2>/dev/null
	@mkdir -p ${PATH_DATA}
	@mkdir -p ${PATH_DATA}/mariadb-data
	@mkdir -p ${PATH_DATA}/wordpress-data
	@echo " ... data files created for mariadb and wordpress"
	@echo "Configuration is $Gdone$W"
	@echo "---------------------------------------------------\n"

up: setup
	@echo "-------------------- $YBuilding $W---------------------"
	@docker-compose -f ./srcs/docker-compose.yml up --detach --build
	@echo "---------------------------------------------------\n"

down:
	@echo "-------------------- $YStopping $W---------------------"
	@docker-compose -f ./srcs/docker-compose.yml down
	@echo "---------------------------------------------------\n"

fclean: del
	@./cleanup.sh
	@sudo rm -rf ${PATH_DATA}
	@echo "---------------------------------------------------\n"

.PHONY: all stop build run list del fclean down up