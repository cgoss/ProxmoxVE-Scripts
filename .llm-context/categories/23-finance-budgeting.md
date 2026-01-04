# 23 Finance Budgeting

## Category Information

**Category ID**: 23
**Number of Scripts**: 5

## Description

This category includes scripts for Debian and related services.

## Scripts in This Category (5 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Actual Budget](https://actualbudget.org/) | `actualbudget` | 5006 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [Baby Buddy](https://github.com/babybuddy/babybuddy) | `babybuddy` | 80 | 2 | 2048 MB | 5 GB | Debian 12 |  |
| [Firefly III](https://firefly-iii.org/) | `firefly` | 80 | 1 | 1024 MB | 2 GB | Debian 12 |  |
| [Ghostfolio](https://ghostfol.io/) | `ghostfolio` | 3333 | 2 | 4096 MB | 8 GB | Debian 13 |  |
| [Wallos](https://wallosapp.com/) | `wallos` | 80 | 1 | 1024 MB | 5 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 1024 MB | 4096 MB | 2560 MB |
| Disk | 2 GB | 8 GB | 5 GB |

**Supported Operating Systems:**
- Debian

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 3333**: Default interface port for many scripts
- **Port 5006**: Default interface port for many scripts


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
