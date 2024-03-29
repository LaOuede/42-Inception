FROM debian:buster

# Update and install MariaDB
RUN apt-get update -y \
	&& apt-get install mariadb-server -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy custom MariaDB configuration script
COPY tools/config_db.sh /usr/local/bin
RUN chmod +x /usr/local/bin/config_db.sh

# Expose port 3306 port
EXPOSE 3306

# Define volume for data persistence
VOLUME ["/var/lib/mysql"]

# Set the entrypoint to start MariaDB
ENTRYPOINT ["/usr/local/bin/config_db.sh"]