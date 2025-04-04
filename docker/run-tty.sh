#!/bin/sh

echo "Run new container (interactive) ..."

docker run -it --name http-client-container \
  --platform linux/amd64 \
  -v $(pwd)/progress_lnx_2026-03-19.cfg:/usr/dlc/progress.cfg \
  -v $(pwd)/../src:/app/src devbfvio/openedge-compiler:12.8.6.1-dotnet8 \
  bash
