FROM		debian:buster

# Update and install MariaDB
RUN			apt-get update -y \
			&& apt-get install mariadb-server -y
RUN			mkdir -p var/run/mysqld \
			&& chown -R mysql:mysql var/run/mysqld

# Copy custom MariaDB configuration and script
COPY		conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY		tools/config_db.sh /usr/local/bin
RUN			chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf
RUN			chmod +x /usr/local/bin/config_db.sh

# Expose port 3306 port
EXPOSE		3306

# Set the entrypoint to start MariaDB
ENTRYPOINT	["/usr/local/bin/config_db.sh"]