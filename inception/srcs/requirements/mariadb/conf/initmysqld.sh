#!/bin/sh

#Demarrage de mysql in background (&)
mysqld &

sleep 10

#Creation de la table
mysql -u root -p$SQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
#Creation d'un utilisateurs
mysql -u root -p$SQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
#Je donne tout les droits a l'utilisateur
mysql -u root -p$SQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
#Changement du mot de passe de l'utilisateur root 
mysql -u root -p$SQL_ROOT_PASSWORD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
#Refresh des droits
mysql -u root -p$SQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p$SQL_ROOT_PASSWORD -S /var/run/mysqld/mysqld.sock shutdown

sleep 5

#Je relance le serveur mysql pour appliquer les changements
exec mysqld_safe