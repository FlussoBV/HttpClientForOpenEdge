@ECHO OFF

set CONTAINER=http-client-pug-container

echo "Start container (interactive) ..."

docker ps

echo

docker start -i %CONTAINER%
