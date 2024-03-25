#------------------------------------------------------------------------------#
#                                   COLOR SETTINGS                             #
#------------------------------------------------------------------------------#
W		:= \033[0m
R		:= \033[1;31m
G		:= \033[1;32m
Y		:= \033[1;33m
C 		:= \033[1;36m

# Include environment variables
-include .env.make

# Convert .env to Makefile format
.env.make: srcs/.env
	@cat srcs/.env | sed 's/=/?=/g' > .env.make

# Docker tasks
all: setup

build:
	docker build -t nginx srcs/requirements/nginx/

run:
	docker run -ti --name nginx-test -p 443:443 -d nginx

list:
	docker ps -a

stop:
	docker stop nginx-test

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
	@rm -rf ${PATH_DATA}
	@echo "---------------------------------------------------\n"

.PHONY: all stop build run list del fclean down up