#!/bin/sh

echo "Run new container (interactive) ..."

docker run -it --name http-client-container \
  --platform linux/amd64 \
  -v $(pwd)/../license/progress.cfg:/usr/dlc/progress.cfg \
  -v $(pwd)/../src:/app/src \
  devbfvio/openedge-compiler:12.8.9-dotnet8 \
  bash
