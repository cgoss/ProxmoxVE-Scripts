# 05 Adblock Dns

## Category Information

**Category ID**: 5
**Number of Scripts**: 7

## Description

This category includes scripts for Debian, Alpine, Debian and related services.

## Scripts in This Category (7 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [AdGuard Home](https://adguard.com/en/adguard-home/overview.html) | `adguard` | 3000 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [AdGuardHome-Sync](https://github.com/bakito/adguardhome-sync) | `adguardhome-sync` | 8080 | None | None | None GB | N/A |  |
| [Blocky](https://0xerr0r.github.io/blocky/) | `blocky` | 4000 | 1 | 512 MB | 2 GB | Debian 12 |  |
| [GoAway](https://github.com/pommee/goaway) | `goaway` | 8080 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Pi-Hole](https://pi-hole.net/) | `pihole` | 80 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Technitium DNS](https://technitium.com/dns/) | `technitiumdns` | 5380 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Unbound](https://www.nlnetlabs.nl/projects/unbound/about/) | `unbound` | 5335 | 1 | 512 MB | 2 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 1 | 1 |
| RAM | 256 MB | 1024 MB | 640 MB |
| Disk | 1 GB | 4 GB | 2 GB |

**Supported Operating Systems:**
- Debian
- Alpine
- Debian

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 4000**: Default interface port for many scripts
- **Port 5335**: Default interface port for many scripts
- **Port 5380**: Default interface port for many scripts


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
