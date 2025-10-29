#!/bin/sh

docker compose up -d

# download the certificate
docker exec caddy sh -c 'cat /data/caddy/pki/authorities/local/root.crt' > ../src/certs/84736cea.0

ls -l ../src/certs/84736cea.0
