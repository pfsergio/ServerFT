FROM debian:buster
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget vim nginx mariadb-server php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring
COPY ./srcs/default /etc/nginx/sites-available/
WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
COPY ./srcs/wp-config.php /var/www/html
COPY ./srcs/index.html .
COPY ./srcs/init.sh ./
RUN openssl req -x509 -nodes -days 365 -subj "/C=RU/ST=Kazan/L=KAZAN/O=pruthann/OU=school21/CN=kukuku" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;
RUN cp -R /etc/nginx .
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*
CMD bash init.sh
