#!/bin/sh

echo "Start container (interactive) ..."

docker ps

echo

# docker run -it -v $(pwd)/../src:/app/src httpclient4oe
docker start -i http-client-container
