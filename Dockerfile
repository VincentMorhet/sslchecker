FROM debian:latest

MAINTAINER Vincent MORHET <vincent.morhet@gmail.com>

# disable interactive functions. 
ENV DEBIAN_FRONTEND noninteractive

# Install apache, php and supplimentary programs. also remove the list from the apt-get update at the end ;-)
RUN apt-get update && apt-get install -y apache2 \
	libapache2-mod-php \
	php-json \
	php-curl \
	curl \
    git \
    unzip \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean -y
# Install composer for PHP dependencies
RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Enable apache mods.
RUN a2enmod rewrite && a2enmod ssl

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80
EXPOSE 443

ADD ca-bundle.crt /etc/apache2/ssl.crt/ca-bundle.crt

# Copy site into place.
ADD www /var/www/site

RUN cd /var/www/site && composer install 

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND

# expose container at port 80
EXPOSE 80