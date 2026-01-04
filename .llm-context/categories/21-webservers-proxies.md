# 21 Webservers Proxies

## Category Information

**Category ID**: 21
**Number of Scripts**: 9

## Description

This category includes scripts for Debian, Alpine, Debian and related services.

## Scripts in This Category (9 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Caddy](https://caddyserver.com/) | `caddy` | 80 | 1 | 512 MB | 6 GB | Debian 12 |  |
| [NPMplus](https://github.com/ZoeyVid/NPMplus) | `npmplus` | 81 | 1 | 512 MB | 3 GB | Alpine 3.22 |  |
| [Nginx Proxy Manager](https://nginxproxymanager.com/) | `nginxproxymanager` | 81 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [Pangolin](https://pangolin.net/) | `pangolin` | 443 | 2 | 4096 MB | 5 GB | Debian 13 |  |
| [Paymenter](https://paymenter.org/) | `paymenter` | 80 | 2 | 1024 MB | 5 GB | Debian 13 |  |
| [Reitti](https://www.dedicatedcode.com/projects/reitti/) | `reitti` | 8080 | 2 | 4096 MB | 15 GB | Debian 13 |  |
| [RustDesk Server](https://rustdesk.com/) | `rustdeskserver` | 21114 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Traefik](https://traefik.io/) | `traefik` | 8080 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Wordpress](https://wordpress.org/) | `wordpress` | 80 | 2 | 2048 MB | 5 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 256 MB | 4096 MB | 2176 MB |
| Disk | 1 GB | 15 GB | 8 GB |

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
- **Port 81**: Default interface port for many scripts
- **Port 443**: Default interface port for many scripts
- **Port 8080**: Default interface port for many scripts
- **Port 21114**: Default interface port for many scripts


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
