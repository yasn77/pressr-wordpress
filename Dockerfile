FROM wordpress:4.6.1

RUN apt-get update && apt-get -y install mysql-client

ADD pressr_start.sh /usr/local/bin/apache2-pressr_start.sh
CMD ["apache2-pressr_start.sh"]
