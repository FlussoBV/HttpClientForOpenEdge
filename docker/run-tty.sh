#!/bin/sh

image=flusso/http-client-pug-image
container=http-client-pug-container

echo "Stop container ${container} ..."
docker stop ${container}

echo "Remove container ${container} ..."
docker rm ${container}

echo "Run new container (interactive) ..."
docker run -it \
  --name ${container} \
  --network appnet \
  --platform linux/amd64 \
  -v $(pwd)/../license/progress.cfg:/usr/dlc/progress.cfg \
  -v $(pwd)/../src:/app/src \
  -v $(pwd)/../assemblies:/app/assemblies \
  -v $(pwd)/../config:/app/config \
  ${image} \
  bash -c "cp -p /app/src/certs/* /usr/dlc/certs/ && exec bash"
