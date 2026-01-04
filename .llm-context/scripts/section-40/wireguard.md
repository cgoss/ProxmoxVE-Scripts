# WireGuard Context

## Basic Information

- **Name**: WireGuard
- **Slug**: wireguard
- **Categories**: 4

## Description

WireGuard is a free and open-source virtual private network (VPN) software that uses modern cryptography to secure the data transmitted over a network. It is designed to be fast, secure, and easy to use. WireGuard supports various operating systems, including Linux, Windows, macOS, Android, and iOS.

## Resources by Install Method

### Default Install
- **CPU**: 1 cores
- **RAM**: 512 MB (0.5 GB)
- **Disk**: 4 GB
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

- **Interface Port**: 10086
- **Web URL**: https://www.wireguard.com/
- **Documentation**: https://www.wireguard.com/quickstart/
- **Configuration Path**: /etc/wireguard/wg0.conf


## Special Requirements

- **TUN/TAP Support**: Required for this service

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
