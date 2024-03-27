#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

echo "\n-------------- Database Initialization --------------"
# Check if the database already exists
if [ -d "/var/lib/mysql/${DB_NAME}" ]; then
	echo "Database ${DB_NAME} already exists. Skipping configuration step."
else
	# Start the MariaDB server.
	service mysql start

	# Allow some time for the server to start.
	sleep 7

	# Execute SQL commands to create the database and user.
	echo "\n------------------ Table creation -------------------"
	echo "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" > $DB_NAME.sql
	echo "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'localhost' IDENTIFIED BY '${DB_PASS}';" >> $DB_NAME.sql
	echo "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION;" >> $DB_NAME.sql
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';" >> $DB_NAME.sql
	echo "FLUSH PRIVILEGES;" >> $DB_NAME.sql

	echo "\n---------------- Configuration debug ----------------"
	cat $DB_NAME.sql
	mysql < $DB_NAME.sql

	# Shut down the server.
	echo "\n------------------ Server Shutdown ------------------"
	mysqladmin -u root -p$DB_ROOT -S /var/run/mysqld/mysqld.sock shutdown

	# Pause to ensure the server shutdown is OK.
	sleep 7
	echo "\n-------------- DB Initialization done ---------------"
fi

# Restart the server for normal operations.
echo "\n----------------- Start mysqld_safe ----------------"
exec mysqld_safe