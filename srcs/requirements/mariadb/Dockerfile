FROM    debian:buster

# Update and install MariaDB
RUN     apt update \
        && apt install mariadb mariadb-client

# Copy custom MaraiDB configuration and script
COPY    ./tools/config_db.sh /tmp/config_db.sh
RUN     chmod +x /tmp/configure-mariadb.sh

# Set the entrypoint to start MaraiDB
ENTRYPOINT  ["./config_db.sh"]
