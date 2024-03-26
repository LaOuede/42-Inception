#------------------------------------------------------------------------------#
#								   GENERAL									   #
#------------------------------------------------------------------------------#

RM = rm -rf
DC = docker compose

IMAGES = $(shell for image in srcs-mariadb srcs-wordpress srcs-nginx; do docker images -q $$image; done)

CONTAINERS = $(shell for container in mariadb wordpress nginx; do docker ps -aq --filter "name=$$container"; done)

VOLUMES = $(shell for volume in srcs_mariadb srcs_wordpress; do docker volume ls --quiet --filter "name=volume"; done)

NETWORK = inception

RM_IMAGES = docker image rm $(IMAGES)
RM_VOL = docker volume rm -f $(VOLUMES)

DIR_MDB = /home/gle-roux/data/mariadb
DIR_WP = /home/gle-roux/data/wordpress

SRCS =	srcs/docker-compose.yml

#----------------------------------- COLORS -----------------------------------#
LRED = \033[91m
RED = \033[91m
LGREEN = \033[92m
LYELLOW = \033[93m
LMAGENTA = \033[95m
LCYAN = \033[96m
NC = \033[0;39m

#------------------------------------------------------------------------------#
#									 RULES									   #
#------------------------------------------------------------------------------#

all:	docker

docker:	$(SRCS)
	@mkdir -p $(DIR_MDB)
	@mkdir -p $(DIR_WP)
	@echo "$(LGREEN)Directories Creation Completed.$(NC)"
	@$(DC) -f $(SRCS) up --build --remove-orphans -d
	@echo "$(LGREEN)All the services are ready.$(NC)"
	@echo "$(LYELLOW)Go to https://gle-roux.42.fr to see the website"
	@echo "If you land on a nginx error, be sure to check if the wordpress container is ready."
	@echo "Use 'mysql -u db_user -p db_name' inside the mariadb container to connect to the CLI database."
	@echo "Don't forget to add '127.0.0.1 gle-roux.42.fr' at the end of the etc/hosts file."
	@echo "To use the terminal of a container you can use 'docker exec -it <nom_du_conteneur> /bin/sh' $(NC)"

clean:
	@$(DC) -f $(SRCS) stop
	@echo "$(LGREEN)Docker Containers Stopped.$(NC)"

fclean:	clean
	@$(RM) $(DIR_MDB)
	@$(RM) $(DIR_WP)
	@echo "$(LGREEN)Directories Removal Completed.$(NC)"
	@$(DC) -f $(SRCS) down
	@echo "$(LGREEN)Docker Containers and Network Removed.$(NC)"
	@if [ -n "$(IMAGES)" ]; then $(RM_IMAGES); echo "$(LGREEN)Docker Images Removed.$(NC)"; fi
	@if [ -n "$(VOLUMES)" ]; then $(RM_VOL); echo "$(LGREEN)Docker Volumes Removed.$(NC)"; fi

re:	fclean all

.PHONY: all clean fclean re  

