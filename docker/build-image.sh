#!/bin/sh

image=flusso/http-client-pug-image

docker build --rm --platform linux/amd64 -t ${image} .
