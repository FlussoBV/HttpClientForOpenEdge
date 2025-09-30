@echo off

docker compose up -d

# download the certificate
docker exec caddy sh -c 'cat /data/caddy/pki/authorities/local/root.crt' > ..\src\certs\84736cea.0

dir ..\src\certs\84736cea.0
