#!/bin/bash

docker network create wp-net
docker run -d mysql:8 --name wp-mysql --restart=unless-stopped --network=wp-net -e MYSQL_ROOT_PASSWORD=pass1234 -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress
docker run -d wp-app --name wp-app  --restart=unless-stopped --network=wp-net -p 8888:80