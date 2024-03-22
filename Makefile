# Include environment variables
-include .env.make

# Convert .env to Makefile format
.env.make: srcs/.env
	@cat srcs/.env | sed 's/=/?=/g' > .env.make

# Docker tasks
build:
	docker build -t nginx srcs/requirements/nginx/

run:
	docker run -ti --name nginx-test -p 443:443 -d nginx

list:
	docker ps -a

stop:
	docker stop nginx-test

del:
	docker container prune && docker image prune -a

setup:
	./env_config.sh
	mkdir -p ${PATH_DATA}
	mkdir -p ${PATH_DATA}/mariadb-data
	mkdir -p ${PATH_DATA}/wordpress-data

up: setup
	docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker-compose -f ./srcs/docker-compose.yml down

fclean: del
	./cleanup.sh
	rm -rf ${PATH_DATA}

.PHONY: stop build run list del fclean down up