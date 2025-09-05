@ECHO OFF
set CONTAINER=http-client-container
set IMAGE=devbfvio/openedge-compiler:12.8.9-dotnet8

echo "Stop container %CONTAINER%cat "
docker stop %CONTAINER%
pause

echo "Remove container %CONTAINER%"
docker rm %CONTAINER%
pause

echo "Remove image %IMAGE%"
docker rmi %IMAGE%
pause

echo "Run new container (interactive) ..."
docker run -it ^
   --name %CONTAINER% ^
   --platform linux/amd64 ^
   -v %CD%/../license/progress.cfg:/usr/dlc/progress.cfg ^
   -v %CD%/../src:/app/src ^
   -v %CD%/../assemblies:/app/assemblies ^
   -v %CD%/../config:/app/config ^
   %IMAGE% ^
   bash

pause

