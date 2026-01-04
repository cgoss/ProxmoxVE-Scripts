# 07 Backup Recovery

## Category Information

**Category ID**: 7
**Number of Scripts**: 6

## Description

This category includes scripts for Debian, Debian and related services.

## Scripts in This Category (6 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Backrest](https://garethgeorge.github.io/backrest) | `backrest` | 9898 | 1 | 512 MB | 8 GB | Debian 12 |  |
| [Duplicati](https://duplicati.com/) | `duplicati` | 8200 | 1 | 1048 MB | 10 GB | Debian 12 |  |
| [Gitea-Mirror](https://github.com/RayLabsHQ/gitea-mirror/) | `gitea-mirror` | 4321 | 2 | 2048 MB | 6 GB | Debian 12 |  |
| [Minarca](https://minarca.org/en_CA) | `minarca` | 8080 | 2 | 4096 MB | 10 GB | Debian 13 |  |
| [Open-Archiver](https://openarchiver.com/) | `open-archiver` | 3000 | 2 | 3072 MB | 8 GB | Debian 13 |  |
| [UrBackup Server](https://www.urbackup.org/) | `urbackupserver` | 55414 | 1 | 1024 MB | 16 GB | Debian 13 | ✓ |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 512 MB | 4096 MB | 2304 MB |
| Disk | 6 GB | 16 GB | 11 GB |

**Supported Operating Systems:**
- Debian
- Debian

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 3000**: Default interface port for many scripts
- **Port 4321**: Default interface port for many scripts
- **Port 8080**: Default interface port for many scripts
- **Port 8200**: Default interface port for many scripts
- **Port 9898**: Default interface port for many scripts

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
