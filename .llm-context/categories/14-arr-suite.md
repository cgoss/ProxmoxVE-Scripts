# 14 Arr Suite

## Category Information

**Category ID**: 14
**Number of Scripts**: 24

## Description

This category includes scripts for Debian, Debian and related services.

## Scripts in This Category (24 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Autobrr](https://autobrr.com/) | `autobrr` | 7474 | 2 | 2048 MB | 8 GB | Debian 12 |  |
| [Bazarr](https://www.bazarr.media/) | `bazarr` | 6767 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Cleanuparr](https://github.com/Cleanuparr/Cleanuparr) | `cleanuparr` | 11011 | 2 | 1024 MB | 4 GB | Debian 12 |  |
| [Configarr](https://configarr.raydak.de/) | `configarr` | 8989 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr) | `dispatcharr` | 9191 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr) | `flaresolverr` | 8191 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [Huntarr](https://github.com/plexguide/Huntarr.io) | `huntarr` | 9705 | 2 | 1024 MB | 4 GB | Debian 12 |  |
| [Jellyseerr](https://github.com/Fallenbagel/jellyseerr) | `jellyseerr` | 5055 | 4 | 4096 MB | 8 GB | Debian 12 |  |
| [Kapowarr](https://casvt.github.io/Kapowarr/) | `kapowarr` | 5656 | 1 | 256 MB | 2 GB | Debian 13 |  |
| [Lidarr](https://lidarr.audio/) | `lidarr` | 8686 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [MediaManager](https://github.com/maxdorninger/MediaManager) | `mediamanager` | 8000 | 2 | 3072 MB | 4 GB | Debian 13 |  |
| [Mylar3](https://mylarcomics.com/) | `mylar3` | 8090 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [Notifiarr](https://notifiarr.com/) | `notifiarr` | 5454 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Overseerr](https://overseerr.dev/) | `overseerr` | 5055 | 2 | 4096 MB | 8 GB | Debian 13 |  |
| [Prowlarr](https://github.com/Prowlarr/Prowlarr) | `prowlarr` | 9696 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Radarr](https://radarr.video/) | `radarr` | 7878 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Recyclarr](https://recyclarr.dev/) | `recyclarr` | N/A | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Scraparr](https://github.com/thecfu/scraparr) | `scraparr` | 7100 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Sonarr](https://sonarr.tv/) | `sonarr` | 8989 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Tdarr](https://tdarr.io/) | `tdarr` | 8265 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [UmlautAdaptarr](https://github.com/PCJones/UmlautAdaptarr) | `umlautadaptarr` | 5005 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Whisparr](https://github.com/Whisparr/Whisparr) | `whisparr` | 6969 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Wizarr](https://docs.wizarr.dev/) | `wizarr` | 5690 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [cross-seed](https://www.cross-seed.org/) | `cross-seed` | 2468 | 1 | 1024 MB | 2 GB | Debian 12 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 4 | 2 |
| RAM | 256 MB | 4096 MB | 2176 MB |
| Disk | 2 GB | 8 GB | 5 GB |

**Supported Operating Systems:**
- Debian
- Debian

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 2468**: Default interface port for many scripts
- **Port 5005**: Default interface port for many scripts
- **Port 5055**: Default interface port for many scripts
- **Port 5454**: Default interface port for many scripts
- **Port 5656**: Default interface port for many scripts


## Special Considerations

### Security
- Review script descriptions for specific security requirements
- Check if scripts expose ports to your network
- Consider firewall rules for services accessible from outside

### Performance
- Adjust CPU and RAM based on expected load
- Databases and media servers may need more resources
- Alpine variants are lighter but may have fewer features

### Storage
- Some scripts grow disk usage over time (databases, media)
- Consider using fast storage for I/O intensive applications
- Backup important data regularly

### Networking
- Most scripts use DHCP by default
- Consider static IPs for critical services
- VLANs can isolate services for security

## Related Categories

*This section will be populated during Phase 5*

---

## Status

- [x] Category stub created
- [x] Scripts listed
- [x] Patterns documented
- [x] Resources documented
- [x] Special considerations documented

**Last Updated**: 2025-01-04
