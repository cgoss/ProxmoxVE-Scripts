# 03 Containers Docker

## Category Information

**Category ID**: 3
**Number of Scripts**: 6

## Description

This category includes scripts for Debian, Alpine, Debian and related services.

## Scripts in This Category (6 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Coolify](https://coolify.io/) | `coolify` | 8000 | 2 | 4096 MB | 30 GB | Debian 13 |  |
| [Docker](https://www.docker.com/) | `docker` | N/A | 2 | 2048 MB | 4 GB | Debian 12 |  |
| [Dockge](https://github.com/louislam/dockge) | `dockge` | 5001 | 2 | 2048 MB | 18 GB | Debian 12 |  |
| [Dokploy](https://dokploy.com/) | `dokploy` | 3000 | 2 | 2048 MB | 10 GB | Debian 13 | ✓ |
| [Komodo](https://komo.do) | `komodo` | 9120 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [Podman](https://podman.io/) | `podman` | N/A | 2 | 2048 MB | 4 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 1024 MB | 4096 MB | 2560 MB |
| Disk | 2 GB | 30 GB | 16 GB |

**Supported Operating Systems:**
- Debian
- Alpine
- Debian

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 3000**: Default interface port for many scripts
- **Port 5001**: Default interface port for many scripts
- **Port 8000**: Default interface port for many scripts
- **Port 9120**: Default interface port for many scripts

### Special Requirements
- Some scripts require **privileged containers** (see table above)
- Privileged scripts may need USB, FUSE, or other host access


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
