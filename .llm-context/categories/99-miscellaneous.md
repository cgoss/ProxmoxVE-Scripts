# 99 Miscellaneous

## Category Information

**Category ID**: 0
**Number of Scripts**: 12

## Description

This category includes scripts for Debian, Debian and related services.

## Scripts in This Category (12 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Apache Guacamole](https://guacamole.apache.org/) | `apache-guacamole` | 8080 | 1 | 2048 MB | 4 GB | Debian 13 |  |
| [Asterisk](https://asterisk.org/) | `asterisk` | N/A | 2 | 2048 MB | 4 GB | Debian 12 |  |
| [Baïkal](https://sabre.io/baikal/) | `baikal` | 80 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [FreePBX](https://www.freepbx.org/) | `freepbx` | 80 | 2 | 2048 MB | 10 GB | Debian 12 |  |
| [GlobaLeaks](https://www.globaleaks.org/) | `globaleaks` | 443 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [LibreTranslate](https://libretranslate.com/) | `libretranslate` | 5000 | 2 | 2048 MB | 20 GB | Debian 13 |  |
| [Manage My Damn Life](https://github.com/intri-in/manage-my-damn-life-nextjs) | `managemydamnlife` | 3000 | 2 | 2048 MB | 6 GB | Debian 13 |  |
| [Radicale](https://radicale.org/) | `radicale` | 5232 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [SearXNG](https://github.com/searxng/searxng) | `searxng` | 8888 | 2 | 2048 MB | 7 GB | Debian 13 |  |
| [Traccar](https://www.traccar.org/) | `traccar` | 8082 | 1 | 1024 MB | 2 GB | Debian 13 |  |
| [Unmanic](https://docs.unmanic.app/) | `unmanic` | 8888 | 2 | 2048 MB | 4 GB | Debian 13 | ✓ |
| [listmonk](https://listmonk.app/) | `listmonk` | 9000 | 1 | 512 MB | 4 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 512 MB | 2048 MB | 1280 MB |
| Disk | 2 GB | 20 GB | 11 GB |

**Supported Operating Systems:**
- Debian
- Debian

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 443**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 5000**: Default interface port for many scripts
- **Port 5232**: Default interface port for many scripts

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
