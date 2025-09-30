@echo off

set container=http-client-pug-container

echo "Start container (interactive) ..."

docker ps

echo

docker start -i %container%
