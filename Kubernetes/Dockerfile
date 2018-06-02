FROM php:5.6-apache
MAINTAINER = Elias Neves

RUN docker-php-ext-install mysqli
COPY ./Projeto/loja /var/www/html
EXPOSE 80
