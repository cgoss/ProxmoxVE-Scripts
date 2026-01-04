# Syncthing Context

## Basic Information

- **Name**: Syncthing
- **Slug**: syncthing
- **Categories**: 12

## Description

Syncthing is an open-source file syncing tool that allows users to keep their files in sync across multiple devices by using peer-to-peer synchronization. It doesn't rely on any central server, so all data transfers are directly between devices.

## Resources by Install Method

### Default Install
- **CPU**: 2 cores
- **RAM**: 2048 MB (2 GB)
- **Disk**: 8 GB
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

- **Interface Port**: 8384
- **Web URL**: https://syncthing.net/
- **Documentation**: https://docs.syncthing.net/
- **Configuration Path**: /root/.local/state/syncthing/config.xml - Alpine: /var/lib/syncthing/.local/state/syncthing/config.xml

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
