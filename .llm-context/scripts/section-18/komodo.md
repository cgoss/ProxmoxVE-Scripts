# Komodo Context

## Basic Information

- **Name**: Komodo
- **Slug**: komodo
- **Categories**: 3

## Description

Komodo is a build and deployment system that automates the creation of versioned Docker images from Git repositories and facilitates the deployment of Docker containers and Docker Compose setups. It provides features such as build automation triggered by Git pushes, deployment management, and monito

## Resources by Install Method

### Default Install
- **CPU**: 2 cores
- **RAM**: 2048 MB (2 GB)
- **Disk**: 10 GB
- **OS**: Debian 13
- **Privileged**: true
- **Updateable**: Yes

### Alpine Install
- **CPU**: 1 core (typical for Alpine)
- **RAM**: 512 MB (1024 MB = 1 GB) - Alpine typically uses ~50% less RAM
- **Disk**: 2 GB (typical for Alpine)
- **OS**: Alpine 13
- **Privileged**: true
- **Updateable**: Yes

## Access Information

- **Interface Port**: 9120
- **Web URL**: https://komo.do
- **Documentation**: https://komo.do/docs/intro
- **Configuration Path**: /opt/komodo/compose.env

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
