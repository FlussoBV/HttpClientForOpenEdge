@ECHO OFF

IMAGE=flusso/http-client-pug-image

docker build --rm --platform linux/amd64 -t %IMAGE% .
