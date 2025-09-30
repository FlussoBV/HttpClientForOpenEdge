@echo off

set image=flusso/http-client-pug-image
set container=http-client-pug-container

echo "Stop container %container% ..."
docker stop %container%

echo "Remove container %container% ..."
docker rm %container%

echo "Run new container (interactive) ..."
docker run -it ^
   --name %container% ^
   --network appnet ^
   --platform linux/amd64 ^
   -v %cd%/../license/progress.cfg:/usr/dlc/progress.cfg ^
   -v %cd%/../src:/app/src ^
   -v %cd%/../assemblies:/app/assemblies ^
   -v %cd%/../config:/app/config ^
   %image% ^
   bash -c "cp -p /app/src/certs/* /usr/dlc/certs/ && exec bash"
