FROM debian:buster

# ---------------------- # Étape 1 : Installation des dépendances de base ----------------------
RUN apt update -y \
    && apt upgrade -y \
    && apt-get -y install \
        # wget est une commande en ligne de commande utilisée pour récupérer des fichiers à partir d'Internet. 
        wget\
        # 7.3 car c'est derniere version de php disponible pour debian buster
        php7.3\
        # Gestionnaire de processus pour PHP
        php-fpm\
        # php-mysql est un module pour le langage de programmation PHP qui permet aux applications PHP d'interagir avec des bases de données MySQL. 
        php-mysql\
        mariadb-client

# ---------------------- # Étape 2 : Installation de wordpress ----------------------
RUN wget https://fr.wordpress.org/wordpress-6.3.1-fr_FR.tar.gz -P /var/www \
    && cd /var/www\
    && tar -xzf wordpress-6.3.1-fr_FR.tar.gz\
    && rm wordpress-6.3.1-fr_FR.tar.gz\
    # La commande chown -R est utilisée pour modifier le propriétaire et le groupe d'un fichier ou d'un répertoire
    && chown -R root:root /var/www/wordpress

# Modification du fichier de configuration de php-fpm 
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

#instalattion du CLI de wordpress pour configurer wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar\
    # Je rend le fichier executable
    && chmod +x wp-cli.phar\
    # Je deplace le fichier dans les binaires
    && mv wp-cli.phar /usr/local/bin/wp-cli.phar

# Configuration de wordpress
COPY conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN mkdir -p /run/php
RUN chmod +x /usr/local/bin/auto_config.sh

ENTRYPOINT ["/bin/sh", "/usr/local/bin/auto_config.sh"]

EXPOSE 9000
