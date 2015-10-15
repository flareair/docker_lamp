FROM ubuntu:trusty

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-gd

# ssmtp install and config
RUN apt-get install -y ssmtp
RUN sed -i 's,^\(mailhub=\).*,\1'172.17.42.1',' /etc/ssmtp/ssmtp.conf
RUN echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf

#custom apache conf
COPY config/httpd.conf /etc/apache2/conf-available/custom.conf
RUN a2enconf custom

# disable default security apache conf
RUN a2disconf security

# custom deflate
ADD config/deflate.conf /etc/apache2/mods-available/deflate.conf

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD config/my.cnf /etc/mysql/conf.d/my.cnf
ADD config/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD config/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# config to enable .htaccess
ADD config/virtualhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Add php.ini
ADD config/php.ini /etc/php5/apache2/php.ini

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80 3306
CMD ["/run.sh"]
