FROM devbfvio/openedge-compiler:12.8.9-dotnet8

USER root

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && update-ca-certificates

USER openedge
