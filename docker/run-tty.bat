@ECHO OFF

set IMAGE=flusso/http-client-pug-image
set CONTAINER=http-client-pug-container

echo "Stop container %CONTAINER% ..."
docker stop %CONTAINER%

echo "Remove container %CONTAINER% ..."
docker rm %CONTAINER%

echo "Run new container (interactive) ..."
docker run -it ^
   --name %CONTAINER% ^
   --network appnet ^
   --platform linux/amd64 ^
   -v %CD%/../license/progress.cfg:/usr/dlc/progress.cfg ^
   -v %CD%/../src:/app/src ^
   -v %CD%/../assemblies:/app/assemblies ^
   -v %CD%/../config:/app/config ^
   %IMAGE% ^
   bash
