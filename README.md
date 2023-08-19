# My Homelab

This projects contains the configuration of my home lab setup.
It is mainly a single docker compose file which configures all the applications

<!-- , exposed with a traefik reverse proxy exposing it to the web. -->

The docker workload is run on my Lenovo Windows Laptop

## Design

![](component-diagram.drawio.svg)

## Setup

1. Create a docker network. This will be used for all containers running in the docker host related to homelab.
   ```
   docker network create homelab-network
   ```
1. Create a volume for mysql so that the data is persistent across compose up's and down's.
   ```
   docker volume create homelab-mysql-volume
   ```

## Nginx Proxy Manager

Nginx Proxy Manager is the gateway to homelab, providing a nice UI to manage routing, SSL, and other configurations.
It uses a MySQL database to store all the configurations.

### Setup MySQL

1. Change the secrets of MySQL by replacing `changeme` with a strong password in the following files
   1. mysql/secrets/root-password.txt
   2. mysql/secrets/nginx-proxy-manager-password.txt
   3. mysql/secrets/secrets.env

## [Softserve](https://github.com/charmbracelet/soft-serve) - Git Server

A minimal and beautiful SSH based application to host git repositories.
