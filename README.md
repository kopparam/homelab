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

## Grafana

Configure Application Instrumentation
After the Helm chart is deployed, you will need to configure your application instrumentation to send telemetry data to Grafana Alloy using one of these addresses:

OTLP/gRPC endpoint: http://grafana-k8s-monitoring-grafana-agent.lgtm.svc.cluster.local:4317

OTLP/HTTP endpoint: http://grafana-k8s-monitoring-grafana-agent.lgtm.svc.cluster.local:4318

Zipkin endpoint: grafana-k8s-monitoring-grafana-agent.lgtm.svc.cluster.local:9411

## Rook + Ceph: Cloud Native Storage

This creates a Cepf Object and FileSystem Storageclasses in Kubernetes using Rook. Block devices are explicitly disabled as the required modules are not included in the kernel od RaspberryPi OS.

It uses a single replica for all the object pools as I plan to use this for CloudnativePG, which has replication built in.
This is the reason this POC needs a single thumb drive and a single partition on it.

### Hardware Setup

1 x 64 GB USB 3 thumb drive inserted in rpi5-02's blue USB ports

### Prerequisite setup

Caution: These steps destroy all data on the drive, execute by making sure the device being wiped with step 1

1. Note the device name, for me it was `/dev/sda`
   `sudo fdisk -l`
2. Clear the drive, by zero'ing out first 100MB of the drive
   `sudo dd if=/dev/zero of=/dev/sda bs=1M count=100 oflag=direct,dsync`
3. Create a single empty partition on the drive, this is because [ceph does not like removable drives](https://tracker.ceph.com/issues/38833) and [a bug which thinks the drive is less than 5 GB](https://tracker.ceph.com/issues/58591)
   1. `sudo fdisk /dev/sda`
   2. `g # Create a new partition table`
   3. `n # Create a new partition`
   4. Press enter for partition number, start and end sectors
   5. `w # Save and exit`
4. `sudo partprobe /dev/sda`

### Add label to the node that has the drive

Run `ansible/rook-ceph.yaml`

### Run the rook helmfile

`helmfile apply --skip-diff-on-install`
