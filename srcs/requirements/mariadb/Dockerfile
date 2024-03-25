FROM		debian:buster

# Update and install MariaDB
RUN			apt update \
			&& apt install mariadb-server -y

# Copy configuration file
COPY		./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
RUN			chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy custom MariaDB configuration and script
COPY		./tools/config_db.sh /usr/local/bin/config_db.sh
RUN			chmod +x /usr/local/bin/config_db.sh

# Expose port 3306 port
EXPOSE		3306

# Set the entrypoint to start MaraiDB
ENTRYPOINT	["config_db.sh"]