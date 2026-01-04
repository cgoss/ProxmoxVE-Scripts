# 19 Automation Scheduling

## Category Information

**Category ID**: 19
**Number of Scripts**: 8

## Description

This category includes scripts for Debian, Debian and related services.

## Scripts in This Category (8 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Cronicle Primary](https://github.com/jhuckaby/Cronicle) | `cronicle` | 3012 | 1 | 512 MB | 2 GB | Debian 12 |  |
| [Daemon Sync Server](https://daemonsync.me/) | `daemonsync` | 8084 | 1 | 512 MB | 8 GB | Debian 12 |  |
| [Donetick](https://donetick.com) | `donetick` | 2021 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Fluid-Calendar](https://github.com/dotnetfactory/fluid-calendar) | `fluid-calendar` | 3000 | 3 | 4096 MB | 7 GB | Debian 12 |  |
| [Gotify](https://gotify.net/) | `gotify` | 80 | 1 | 512 MB | 2 GB | Debian 12 |  |
| [Salt](https://saltproject.io/) | `salt` | N/A | 1 | 1024 MB | 3 GB | Debian 13 |  |
| [Semaphore](https://semaphoreui.com/) | `semaphore` | 3000 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [ntfy](https://ntfy.sh/) | `ntfy` | 80 | 1 | 512 MB | 2 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 3 | 2 |
| RAM | 512 MB | 4096 MB | 2304 MB |
| Disk | 2 GB | 8 GB | 5 GB |

**Supported Operating Systems:**
- Debian
- Debian

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 2021**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 3012**: Default interface port for many scripts
- **Port 8084**: Default interface port for many scripts


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
