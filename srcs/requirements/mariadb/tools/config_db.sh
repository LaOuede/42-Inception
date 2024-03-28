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
        start_mariadb
        create_database_and_user
        shutdown_mariadb
    fi
	echo "-------------- DB Initialization DONE ---------------"
    start_mariadb_safe
}

start_mariadb() {
	echo "----------------- Starting MariaDB ------------------"
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
