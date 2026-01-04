# 02 Operating Systems

## Category Information

**Category ID**: 2
**Number of Scripts**: 22

## Description

This category includes scripts for Alpine, Debian, Ubuntu and related services.

## Scripts in This Category (22 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Alpine](https://www.alpinelinux.org/) | `alpine` | N/A | 1 | 512 MB | 1 GB | Alpine 3.22 |  |
| [Arch Linux](https://archlinux.org/) | `archlinux-vm` | N/A | 1 | 1024 MB | 4 GB | N/A |  |
| [CasaOS](https://www.casaos.io/) | `casaos` | 80 | 2 | 2048 MB | 8 GB | Debian 12 |  |
| [Cosmos](https://cosmos-cloud.io/) | `cosmos` | 80 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [Debian](https://www.debian.org/) | `debian` | N/A | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Debian 12](https://www.debian.org/) | `debian-vm` | N/A | 2 | 2048 MB | 4 GB | N/A |  |
| [Debian 13](https://www.debian.org/) | `debian-13-vm` | N/A | 2 | 2048 MB | 4 GB | N/A |  |
| [Docker](https://www.docker.com/) | `docker-vm` | N/A | 2 | 4096 MB | 10 GB | Debian 12 |  |
| [Mikrotik RouterOS CHR](https://mikrotik.com) | `mikrotik-routeros` | N/A | 2 | 512 MB | None GB | N/A |  |
| [Nextcloud](https://www.turnkeylinux.org/nextcloud) | `nextcloud-vm` | 80 | 2 | 2048 MB | 12 GB | Debian 13 |  |
| [NextcloudPi](https://github.com/nextcloud/nextcloudpi) | `nextcloudpi` | 4443 | 2 | 2048 MB | 8 GB | Debian 12 |  |
| [OpenMediaVault](https://www.openmediavault.org/) | `omv` | 80 | 2 | 1024 MB | 4 GB | Debian 12 |  |
| [Runtipi](https://runtipi.io/) | `runtipi` | 80 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [TurnKey](https://www.turnkeylinux.org/) | `turnkey` | N/A | None | None | None GB | N/A |  |
| [Ubuntu](https://ubuntu.com/) | `ubuntu` | N/A | 1 | 512 MB | 2 GB | Ubuntu 24.04 |  |
| [Ubuntu 22.04](https://ubuntu.com/) | `ubuntu2204-vm` | N/A | 2 | 2048 MB | 5 GB | N/A |  |
| [Ubuntu 24.04](https://ubuntu.com/) | `ubuntu2404-vm` | N/A | 2 | 2048 MB | 7 GB | N/A |  |
| [Ubuntu 25.04](https://ubuntu.com/) | `ubuntu2504-vm` | N/A | 2 | 2048 MB | 8 GB | N/A |  |
| [Umbrel OS](https://umbrel.com/) | `umbrel-os-vm` | 80 | 2 | 4096 MB | 32 GB | Debian 12 |  |
| [YunoHost](https://yunohost.org/) | `yunohost` | 80 | 2 | 2048 MB | 20 GB | Debian 12 |  |
| [iVentoy](https://www.iventoy.com/) | `iventoy` | 26000 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [ownCloud](https://www.turnkeylinux.org/owncloud) | `owncloud-vm` | 80 | 2 | 2048 MB | 12 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 512 MB | 4096 MB | 2304 MB |
| Disk | 1 GB | 32 GB | 16 GB |

**Supported Operating Systems:**
- Alpine
- Debian
- Ubuntu

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 4443**: Default interface port for many scripts
- **Port 26000**: Default interface port for many scripts


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
