#!/bin/sh

echo "----------------- Database Config -----------------"

# Step 1: Create /run/mysqld and /run/mysql repos
if [ ! -d "/run/mysql" ]; then
	mkdir /run/mysql
	chown -R mysql:mysql /run/mysql
fi

if [ ! -d "/run/mysqld" ]; then
	mkdir /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi


# Step 2: Create DB
if [ ! -f "/var/lib/mysql/inception.sql" ]; then
	echo "---------------- Database Creation ----------------"
	service mysql start

	echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DB ;" > inception.sql
	echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> inception.sql
	echo "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'%';" >> inception.sql
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" >> inception.sql
	echo "FLUSH PRIVILEGES;" >> inception.sql

	# For tests purpose
	# echo "CREATE DATABASE IF NOT EXISTS inception_db ;" > inception.sql
	# echo "CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'userpass';" >> inception.sql
	# echo "GRANT ALL PRIVILEGES ON inception_db.* TO 'user'@'%';" >> inception.sql
	# echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';" >> inception.sql
	# echo "FLUSH PRIVILEGES;" >> inception.sql

	mysql -u root < inception.sql
	cp inception.sql /var/lib/mysql/
	kill $(cat /var/run/mysqld/mysqld.pid)
fi
echo "------------------ Config is done -----------------"
echo "------ Starting mariadb on port 3306 is done ------"
# Keeps the container alive
mysqld