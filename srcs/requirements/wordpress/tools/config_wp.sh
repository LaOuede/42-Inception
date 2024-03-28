#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "-------------- Wordpress Initialization -------------"

# Connect to MariaDB.
echo "--------------- Waiting for MariaDB... --------------"
sleep 20

# Check if the WordPress configuration file exists.
if [ -f ${WP_PATH}/wp-config.php ]; then
	echo "${WP_PATH}/wp-config.php already exists. Skipping the configuration step."
else
    echo "----------------- 1.Wordpress config ----------------"
    wp-cli.phar config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --path="$WP_PATH"
	
    echo "------------------ 2.Site creation ------------------"
    wp-cli.phar core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WP_NAME" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="$WP_PATH"

    echo "-------------- 3.Default user creation --------------"
    wp-cli.phar user create --allow-root \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=contributor \
        --display_name="$WP_USER" \
        --user_pass="$WP_USER_PASS" \
        --path="$WP_PATH"
	
    echo "----------------- 4.Wordpress theme -----------------"
    # sydney
    wp-cli.phar theme install agama --activate \
        --allow-root \
        --path="$WP_PATH"
    wp-cli.phar theme status agama --allow-root \
        --path="$WP_PATH"
    
    echo "------------------- 5.Post creation -------------------"
    wp-cli.phar post create --allow-root \
        --post_author="$WP_ADMIN" \
        --post_title='Fun fact about Inception!' \
        --post_content='A unique aspect of INCEPTION is its musical score composed by Hans Zimmer. The song "Non, Je Ne Regrette Rien" by Edith Piaf, used as a plot device in the film, is actually integrated into the design. Zimmer slowed down its elements to create the iconic, slow, and reverberating sounds that pervade the movie, particularly in dream sequences. This creative approach adds depth to the exploration of time and memory, blurring the lines between different levels of consciousness.' \
        --post_status=publish \
        --comment_status=open \
        --path="$WP_PATH"

	echo "--------------- WP Initialization DONE ----------------"
fi

# Execute php-fpm.
echo "-------------------- Start php-fpm --------------------"
/usr/sbin/php-fpm7.3 -F