# Base image
FROM alpine:latest

# install required packages for our script
RUN apk add --no-cache git bash

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh


# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]