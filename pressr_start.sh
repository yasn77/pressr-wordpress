#!/bin/bash

set -e
set -o pipefail

MYSQL_OPTS="--connect-timeout=10 -w -u root --password=${WORDPRESS_DB_PASSWORD} -h ${WORDPRESS_DB_HOST}"
TABLE_COUNT_QUERY="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '${WORDPRESS_DB_NAME}'"


if [[ $(mysql -N -s $MYSQL_OPTS -e "${TABLE_COUNT_QUERY}") -eq 0 ]]
then
  mysql $MYSQL_OPTS -D ${WORDPRESS_DB_NAME} < /pressr.sql
fi

apache2-foreground
