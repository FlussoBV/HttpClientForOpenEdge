#!/bin/sh
echo "Run image ..."

# docker run -it -v $(pwd)/../src:/app/src httpclient4oe
docker run -it -v $(pwd)/progress_lnx_2026-03-19.cfg:/usr/dlc/progress.cfg  -v $(pwd)/../src:/app/src devbfvio/openedge-compiler:12.8.6.1-dotnet8 bash
