#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

echo "\n-------------- Wordpress Initialization -------------"

# Connect to MariaDB.
echo "\n--------------- Waiting for MariaDB... --------------"
for i in {1..30}
do
    if mariadb -h${DB_HOST} -u${DB_USER} -p${DB_PASS} ${DB_NAME} &>/dev/null; then
		break
	fi
	sleep 1
done

if [ $i = 30 ]; then
	echo "\n----------------- Connection failed -----------------" $i
fi
echo "\n---------------- Connection succeeded ---------------"

sleep 10

# Check if the WordPress configuration file exists.
if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "${WP_PATH} file already exists. Skipping the configuration step."
else
    echo "\n----------------- 1.Wordpress config ----------------"
    wp-cli.phar config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --path="$WP_PATH"
	
    echo "\n------------------ 2.Site creation ------------------"
    wp-cli.phar core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WP_NAME" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="$WP_PATH"

    echo "\n-------------- 3.Default user creation --------------"
    wp-cli.phar user create --allow-root \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=contributor \
        --display_name="$WP_USER" \
        --user_pass="$WP_USER_PASS" \
        --path="$WP_PATH"
	
    echo "\n----------------- 4.Wordpress theme -----------------"
    wp-cli.phar theme install agama --activate \
        --allow-root \
        --path="$WP_PATH"
    wp-cli.phar theme status agama --allow-root \
        --path="$WP_PATH"
    
    echo "\n------------------- 5.Post creation -------------------"
    wp-cli.phar post create --allow-root \
        --post_author="$WP_ADMIN" \
        --post_title='Your Post Title' \
        --post_content='Your post content here.' \
        --post_status=publish \
        --comment_status=open \
        --path="$WP_PATH"

	echo "\n--------------- WP Initialization DONE ----------------"
fi

# Execute php-fpm.
echo "\n-------------------- Start php-fpm --------------------"
/usr/sbin/php-fpm7.3 -F 