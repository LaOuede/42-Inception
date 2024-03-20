#tests NGINX
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

.PHONY: stop build run list del