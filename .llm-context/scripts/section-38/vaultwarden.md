# Vaultwarden Context

## Basic Information

- **Name**: Vaultwarden
- **Slug**: vaultwarden
- **Categories**: 6

## Description

Vaultwarden is a self-hosted password manager which provides secure and encrypted password storage. It uses client-side encryption and provides access to passwords through a web interface and mobile apps.

## Resources by Install Method

### Default Install
- **CPU**: 4 cores
- **RAM**: 6144 MB (6 GB)
- **Disk**: 20 GB
- **OS**: Debian 13
- **Privileged**: true
- **Updateable**: Yes

### Alpine Install
- **CPU**: 1 core (typical for Alpine)
- **RAM**: 512 MB (3072 MB = 3 GB) - Alpine typically uses ~50% less RAM
- **Disk**: 2 GB (typical for Alpine)
- **OS**: Alpine 13
- **Privileged**: true
- **Updateable**: Yes

## Access Information

- **Interface Port**: 8000
- **Web URL**: https://github.com/dani-garcia/vaultwarden/
- **Documentation**: https://github.com/dani-garcia/vaultwarden/wiki
- **Configuration Path**: /opt/vaultwarden/.env

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
