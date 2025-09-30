# HttpClientForOpenEdge
Http client for OpenEdge with ABL and Dotnet implementations.

# Install / Get started

Build image (in `docker` dir)
`build-image.sh`
This creates a symbolic link in `/etc/ssl/certs` to `/usr/bin/certs/84736cea.0`, so also .NET has access to this certificate after the container has run (see below)

Start Caddy webservice with petstore (in `petstore-local` dir)
`start-caddy.sh`
This also extracts the caddy ssl certificate and stores it as: `src/certs/84736cea.0`
Creates the `appnet` network
Swagger is now available on: http://localhost:8080/

Run docker container for the first time (in `docker` dir)
`run-tty.sh`
This copies the certificates to the `/usr/dlc/certs` dir which is also linked to `/etc/ssl/certs` dir for .NET
It attaches to the `appnet` network

Or when the container already exits (in `docker` dir)
`start-tty.sh`
