# Garage Context

## Basic Information

- **Name**: Garage
- **Slug**: garage
- **Categories**: 8

## Description

Garage is a lightweight, self-hosted, S3-compatible object storage service built for distributed environments. It is designed to be simple, efficient, and easy to deploy across multiple nodes.

## Resources by Install Method

### Default Install
- **CPU**: 1 cores
- **RAM**: 1024 MB (1 GB)
- **Disk**: 5 GB
- **OS**: Debian 13
- **Privileged**: true
- **Updateable**: Yes

### Alpine Install
- **CPU**: 1 core (typical for Alpine)
- **RAM**: 512 MB (512 MB = 0 GB) - Alpine typically uses ~50% less RAM
- **Disk**: 2 GB (typical for Alpine)
- **OS**: Alpine 13
- **Privileged**: true
- **Updateable**: Yes

## Access Information

- **Interface Port**: 3900
- **Web URL**: https://garagehq.deuxfleurs.fr/
- **Documentation**: https://garagehq.deuxfleurs.fr/documentation/quick-start/
- **Configuration Path**: /etc/garage.toml

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
