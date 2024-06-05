# My Homelab

This projects contains the configuration of my home lab setup.
It is a collection of docker compose files which configures all the applications

<!-- , exposed with a traefik reverse proxy exposing it to the web. -->

The docker workload is run on my Lenovo Windows Laptop

## Design

![](component-diagram.drawio.svg)

## Setup

1. Create a docker network. This will be used for all containers running in the docker host related to homelab.
   ```
   docker network create homelab-network
   ```
1. Create a volume for portainer so that the data is persistent across compose up's and down's.
   ```
   docker volume create portainer-data
   ```

## Gateway

This is the gateway to the homelab, which is exposed to the internet.

It used Cloudflare Tunnel to establish a reverse tunnel to the cloudflare's network.

Set the following environment variables in the `.env` file

```env
CLOUDFLARE_TUNNEL_TOKEN=<token>
```

Then start the gateway using the following command

```
docker compose -f compose.gateway.yaml up -d
```

### Traefik - Reverse Proxy

Traefik is the reverse proxt to homelab, to manage routing, SSL, and other configurations for HTTP trafic management within the Docker instance.

## Keycloak - Identity Provider

1. Create a self-signed cert
   `openssl req -newkey rsa:4096 -nodes -keyout ./keycloak/secrets/key.pem -x509 -days 365 -out ./keycloak/secrets/certificate.pem`
2. Create volume for postgres
   `docker volume create homelab-postgres-data`

## Portainer

https://homelab.kopparam.com/portainer

Portainer is a nice UI to manage the Docker Desktop instance.

## [Softserve](https://github.com/charmbracelet/soft-serve) - Git Server

A minimal and beautiful SSH based application to host git repositories.


## Kupi

3 node Kubernetes cluster on RaspberryPis 

### SOPS

Add this to the rc file

```
# SOPS + AGE
export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt
export HELM_SECRETS_BACKEND=sops
```

Add the private key to the `.sops/key.txt`

Add secrets using sops
```
sops -e plainsecrets.yaml
```