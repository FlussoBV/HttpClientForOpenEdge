Valideer je compose-bestand vóór je start:
  docker compose config

Docker draaien (detached mode):
  docker compose up -d

Met recreate:
  docker-compose up -d --force-recreate caddy

Docker kijken of alles draait:
  docker compose ps

Docker down brengen:
  docker compose down --remove-orphans

Testen:
  Swagger interface:
    http://localhost:8080/

  HTTP GET:
    curl -X 'GET' http://localhost:8080/api/store/inventory

  HTTPS GET:
    Server certificate ophalen:
      docker exec caddy sh -c 'cat /data/caddy/pki/authorities/local/root.crt' > caddy-root.crt
    Certificate meegeven (of anders in cert store opslaan)
      curl -X 'GET' --cacert caddy-root.crt https://localhost:8443/api/store/inventory

==============

Meer over certificaten, zie mail d.d. 17-04-2025: OpenEdge HttpClient certificates
