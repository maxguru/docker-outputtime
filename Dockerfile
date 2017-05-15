FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
&& apt-get upgrade -yq --no-install-recommends --no-install-suggests \
&& apt-get install -yq --no-install-recommends --no-install-suggests ca-certificates curl unzip cron apache2 apache2-mpm-prefork libapache2-mod-php5 php5-common php5 php5-mysql php5-curl php-pclzip php5-json \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& a2enmod mpm_prefork rewrite headers \
&& ln -sf /dev/stdout /var/log/apache2/access.log \
&& ln -sf /dev/stderr /var/log/apache2/error.log

ADD "http://outputtime.com/releases/index.php?installer=webapp" /var/www/html/outputtime.zip

WORKDIR /var/www/html/

RUN rm index.html \
&& unzip outputtime.zip \
&& rm outputtime.zip \
&& chown -R www-data:www-data /var/www/html/

RUN cp /var/www/html/installer/extensions/otime_5.6_64bit.so /usr/lib/php5/otime.so \
&& echo "extension=/usr/lib/php5/otime.so" >> /etc/php5/mods-available/otime.ini \
&& php5enmod otime

EXPOSE 80

ADD init.sh /init.sh

CMD ["/bin/sh", "/init.sh"]
