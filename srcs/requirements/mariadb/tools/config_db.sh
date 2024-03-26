#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.


echo "-------------- Database Initialization --------------"
# Start the MariaDB server in the background.
echo "***** Starting MariaDB database server : mysqld *****"
mysqld &

# Wait for the server to start up.
sleep 10

# Execute SQL statements to set up the database and user.
echo "------------------ Table creation -------------------"
mysql -u root -p$DB_ROOT -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
mysql -u root -p$DB_ROOT -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -p$DB_ROOT -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -p$DB_ROOT -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';"
mysql -u root -p$DB_ROOT -e "FLUSH PRIVILEGES;"

# Shut down the server.
echo "------------------ Server Shutdown ------------------"
mysqladmin -u root -p$DB_ROOT -S /var/run/mysqld/mysqld.sock shutdown

# Sleep to ensure the shutdown process is OK.
sleep 7
echo "-------------- DB Initialization done ---------------"

# Start the server.
echo "----------------- Start mysqld_safe -----------------"
exec mysqld_safe