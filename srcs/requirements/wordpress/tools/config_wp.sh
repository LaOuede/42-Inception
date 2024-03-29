#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

main() {
    initialize_wordpress
}

initialize_wordpress() {
    echo "-------------- Wordpress Initialization -------------"

    wait_for_db

    # Check if the WordPress configuration file exists.
    if [ -f "${WP_PATH}/wp-config.php" ]; then
        echo "Config file already exists. Skipping the configuration step."
    else
        configure_conf_file
        configure_wordpress
        create_site
        create_default_user
        install_theme
        create_post
    fi

    echo "-------------- WP Initialization DONE ---------------"
    start_php_fpm
}

wait_for_db() {
    echo "--------------- Waiting for MariaDB... --------------"
    for i in {1..30}; do
        if mariadb -h"${DB_HOST}" -u"${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" &>/dev/null; then
            echo "MariaDB is ready."
            return
        fi
        sleep 1
    done
    echo "MariaDB connection failed."
    exit 1
}

configure_conf_file() {
    if ! grep -q "listen = 0.0.0.0:9000" /etc/php/7.3/fpm/pool.d/www.conf; then
        echo "listen = 0.0.0.0:9000" >> /etc/php/7.3/fpm/pool.d/www.conf
    fi

    if ! grep -q "clear_env = no" /etc/php/7.3/fpm/pool.d/www.conf; then
        echo "clear_env = no" >> /etc/php/7.3/fpm/pool.d/www.conf
    fi
}

configure_wordpress() {
    echo "----------------- 1.Wordpress config ----------------"
    wp-cli.phar config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --path="$WP_PATH"
}

create_site() {
    echo "------------------ 2.Site creation ------------------"
    wp-cli.phar core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WP_NAME" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="$WP_PATH"
}

create_default_user() {
    echo "-------------- 3.Default user creation --------------"
    wp-cli.phar user create --allow-root \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=contributor \
        --display_name="$WP_USER" \
        --user_pass="$WP_USER_PASS" \
        --path="$WP_PATH"
}

install_theme() {
    echo "----------------- 4.Wordpress theme -----------------"
    # agama bravada zakra
    wp-cli.phar theme install zakra --activate --allow-root --path="$WP_PATH"
    wp-cli.phar theme status zakra --allow-root --path="$WP_PATH"
}

create_post() {
    echo "------------------ 5.Post creation ------------------"
    wp-cli.phar post create --allow-root \
        --post_author="$WP_ADMIN" \
        --post_title='Fun fact about Inception!' \
        --post_content='A unique aspect of INCEPTION is its musical score composed by Hans Zimmer. The song "Non, Je Ne Regrette Rien" by Edith Piaf, used as a plot device in the film, is actually integrated into the design. Zimmer slowed down its elements to create the iconic, slow, and reverberating sounds that pervade the movie, particularly in dream sequences. This creative approach adds depth to the exploration of time and memory, blurring the lines between different levels of consciousness.' \
        --post_status=publish \
        --comment_status=open \
        --path="$WP_PATH"
}

start_php_fpm() {
    echo "------------------- Start php-fpm -------------------"
    /usr/sbin/php-fpm7.3 -F
}

main
