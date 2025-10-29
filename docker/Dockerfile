FROM devbfvio/openedge-compiler:12.8.9-dotnet8

USER root

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && update-ca-certificates

# also install 'curl' to test network connections
RUN apt-get update && apt-get install -y curl

# already create a symbolic link for the caddy certificate
RUN ln -s /usr/dlc/certs/84736cea.0 /etc/ssl/certs/84736cea.0

USER openedge
