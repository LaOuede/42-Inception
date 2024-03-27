#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.

echo "\n-------------- Database Initialization --------------"
# Start the MariaDB server.
service mysql start

# Wait for the server to start up.
sleep 7

# Check if the WordPress database directory does not exist
if [ -d "/var/lib/mysql/${DB_NAME}" ]; then
	echo "Database ${DB_NAME} already exists. Skipping configuration step."
else
	# Execute SQL statements to set up the database and user.
	echo "\n------------------ Table creation -------------------"
	echo "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" > $DB_NAME.sql
	echo "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'localhost' IDENTIFIED BY '${DB_PASS}';" >> $DB_NAME.sql
	echo "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASS}';" >> $DB_NAME.sql
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';" >> $DB_NAME.sql
	echo "FLUSH PRIVILEGES;" >> $DB_NAME.sql

	echo "\n---------------- Configuration debug ----------------"
	cat $DB_NAME.sql
	mysql < $DB_NAME.sql

	# Shut down the server.
	echo "\n------------------ Server Shutdown ------------------"
	mysqladmin -u root -p$DB_ROOT -S /var/run/mysqld/mysqld.sock shutdown

	# Sleep to ensure the shutdown process is OK.
	sleep 7
	echo "\n-------------- DB Initialization done ---------------"
fi

# Start the server.
echo "\n----------------- Start mysqld_safe -----------------"
exec mysqld_safe