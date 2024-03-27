FROM    debian:buster

# Update and installations
RUN     apt-get update -y \
        && apt-get -y install wget \
        # php to run wordpress, php-fpm to communicate with nginx, php-mysqli to communicate with mariadb 
        php7.3 php-fpm php-mysqli \
        curl mariadb-client


# Wordpress CLI installation
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp-cli.phar