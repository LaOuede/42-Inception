FROM debian:buster

# ---------------------- # Étape 1 : Installation des dépendances de base ----------------------
RUN apt update -y \
    && apt upgrade -y \
    && apt-get install mariadb-server -y\
    && mkdir -p var/run/mysqld\
    && chown -R mysql:mysql var/run/mysqld

# ------------------------------- # Étape 2 : Modification du fichier de configuration -------------------------------
COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/initmysqld.sh /usr/local/bin

RUN chmod +x /usr/local/bin/initmysqld.sh

ENTRYPOINT [ "/usr/local/bin/initmysqld.sh" ]

# ------------------------------- # Étape 3 : Création de la base de donnée -------------------------------