#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

main() {
	initialize_database
}

initialize_database() {
    echo "-------------- Database Initialization --------------"
	# Check if the database already exists.
    if [ -d "/var/lib/mysql/${DB_NAME}" ]; then
        echo "Database ${DB_NAME} already exists. Skipping configuration step."
    else
        configure_conf_file
        start_mariadb
        create_database_and_user
        shutdown_mariadb
    fi
	echo "-------------- DB Initialization DONE ---------------"
    start_mariadb_safe
}

configure_conf_file() {
    if ! grep -q "^port\s*=\s*3306" /etc/mysql/mariadb.conf.d/50-server.cnf; then
        echo "port = 3306" >> /etc/mysql/mariadb.conf.d/50-server.cnf
    fi

    if ! grep -q "bind-address = 0.0.0.0" /etc/mysql/mariadb.conf.d/50-server.cnf; then
        sed -i 's/bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    fi
}

start_mariadb() {
	echo "----------------- Starting MariaDB ------------------"
    mkdir -p /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld
    service mysql start
    sleep 7
}

create_database_and_user() {
    echo "------------------ Table creation -------------------"
    SQL_COMMANDS="${DB_NAME}.sql"
    echo "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" > "$SQL_COMMANDS"
    echo "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'localhost' IDENTIFIED BY '${DB_PASS}';" >> "$SQL_COMMANDS"
    echo "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION;" >> "$SQL_COMMANDS"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';" >> "$SQL_COMMANDS"
    echo "FLUSH PRIVILEGES;" >> "$SQL_COMMANDS"
    cat "$SQL_COMMANDS"
    mysql < "$SQL_COMMANDS" || { echo "Failed to initialize database"; exit 1; }
}

shutdown_mariadb() {
    echo "------------------ Server Shutdown ------------------"
    mysqladmin -u root -p"$DB_ROOT" -S /var/run/mysqld/mysqld.sock shutdown
    sleep 7
}

start_mariadb_safe() {
    echo "----------------- Start mysqld_safe -----------------"
    exec mysqld_safe
}

main
