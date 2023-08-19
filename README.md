# My Homelab

This projects contains the configuration of my home lab setup.
It is mainly a single docker compose file which configures all the applications

<!-- , exposed with a traefik reverse proxy exposing it to the web. -->

The docker workload is run on my Lenovo Windows Laptop

## Design

![](component-diagram.drawio.svg)

<!-- ## [Traefik](https://doc.traefik.io/traefik/) reverse proxy

Traefik allows the applications in my home lab to be exposed to the intenet as a reverse proxy. It is also used for SSL termination. -->

## Setup

1. Create a docker network. This will be used for all containers running in the docker host related to homelab.
   ```
   docker network create homelab-network
   ```
1. Create a volume for mariadb so that the data is persistent across compose up's and down's.
   ```
   docker volume create homelab-mariadb-volume
   ```

## [Softserve](https://github.com/charmbracelet/soft-serve) - Git Server

A minimal and beautiful SSH based application to host git repositories.
