# Traefik Context

## Basic Information

- **Name**: Traefik
- **Slug**: traefik
- **Categories**: 21

## Description

Traefik (pronounced traffic) is an open-source edge router and reverse proxy that simplifies managing microservices. It automatically discovers services, dynamically updates routing rules without downtime, provides load balancing, handles SSL termination, and supports various middleware for added fu

## Resources by Install Method

### Default Install
- **CPU**: 1 cores
- **RAM**: 512 MB (0.5 GB)
- **Disk**: 2 GB
- **OS**: Debian 13
- **Privileged**: true
- **Updateable**: Yes

### Alpine Install
- **CPU**: 1 core (typical for Alpine)
- **RAM**: 512 MB (256 MB = 0.2 GB) - Alpine typically uses ~50% less RAM
- **Disk**: 2 GB (typical for Alpine)
- **OS**: Alpine 13
- **Privileged**: true
- **Updateable**: Yes

## Access Information

- **Interface Port**: 8080
- **Web URL**: https://traefik.io/
- **Documentation**: https://doc.traefik.io/
- **Configuration Path**: /etc/traefik/traefik.yaml

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
