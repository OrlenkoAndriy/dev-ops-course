FROM ubuntu:20.04

RUN adduser wp-app

RUN apt update
RUN apt install -y unzip wget php-fpm nginx supervisor

RUN wget https://uk.wordpress.org/latest-uk.zip
RUN unzip latest-uk.zip

RUN mkdir -p /var/www/wordpress && cp -r wordpress/ /var/www/wordpress && chown -R wp-app:wp-app /var/www/wordpress

COPY ./configs/wp-config.php /var/www/wordpress/wp-config.php
COPY ./configs/wp-app.conf /etc/php/7.4/fpm/pool.d/wp-app.conf
COPY ./configs/nginx /etc/nginx/sites-available/default
COPY ./configs/supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
EXPOSE 80