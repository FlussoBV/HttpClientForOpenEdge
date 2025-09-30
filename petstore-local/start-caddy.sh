#!/bin/sh

docker compose up -d

# download the certificate
docker exec caddy sh -c 'cat /data/caddy/pki/authorities/local/root.crt' > ../src/certs/caddy-root.crt

ls -l ../src/certs/caddy-root.crt
