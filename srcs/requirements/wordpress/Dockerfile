FROM debian:buster

# Update and installations
RUN apt-get update -y \
    && apt-get -y install wget \
    # php to run wordpress, php-fpm to communicate with nginx, php-mysqli to communicate with mariadb 
    php7.3 php-fpm php-mysqli \
    mariadb-client \
	sendmail sendmail-cf m4

# Wordpress installation
RUN wget https://fr.wordpress.org/wordpress-6.3.1-fr_FR.tar.gz -P /var/www \
    && cd /var/www \
    && tar -xzf wordpress-6.3.1-fr_FR.tar.gz \
    && rm wordpress-6.3.1-fr_FR.tar.gz \
    && chown -R root:root /var/www/wordpress

# Wordpress CLI installation
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp-cli.phar

# Copy custom php-fpm and wordpress configuration and script
COPY tools/config_wp.sh /usr/local/bin/config_wp.sh
RUN chmod +x /usr/local/bin/config_wp.sh

# Ensure the /run/php directory exists for PHP-FPM runtime files.
RUN mkdir -p /run/php

# Expose port 9000 port
EXPOSE 9000

# Set the entrypoint to start Wordpress
ENTRYPOINT [ "/usr/local/bin/config_wp.sh" ]