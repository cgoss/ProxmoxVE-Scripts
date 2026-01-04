# 10 Dashboards Frontends

## Category Information

**Category ID**: 10
**Number of Scripts**: 12

## Description

This category includes scripts for Debian, Ubuntu, Alpine and related services.

## Scripts in This Category (12 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Apache Tomcat](https://tomcat.apache.org/) | `apache-tomcat` | 8080 | 1 | 1024 MB | 5 GB | Debian 12 |  |
| [Cockpit](https://cockpit-project.org/) | `cockpit` | 9090 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Fumadocs](https://fumadocs.vercel.app/) | `fumadocs` | 3000 | 2 | 2048 MB | 5 GB | Debian 12 |  |
| [Glance](https://github.com/glanceapp/glance) | `glance` | 8080 | 1 | 512 MB | 2 GB | Debian 12 |  |
| [Heimdall Dashboard](https://heimdall.site/) | `heimdall-dashboard` | 7990 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Homarr](https://homarr.dev/) | `homarr` | 7575 | 2 | 1024 MB | 8 GB | Debian 13 |  |
| [Homepage](https://gethomepage.dev) | `homepage` | 3000 | 2 | 4096 MB | 6 GB | Debian 12 |  |
| [Homer](https://github.com/bastienwirtz/homer) | `homer` | 8010 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Mafl](https://mafl.hywax.space/) | `mafl` | 3000 | 2 | 2048 MB | 6 GB | Debian 13 |  |
| [NodeBB](https://nodebb.org/) | `nodebb` | 4567 | 4 | 2048 MB | 10 GB | Ubuntu 24.04 |  |
| [OliveTin](https://www.olivetin.app/) | `olivetin` | 1337 | None | None | None GB | N/A |  |
| [Redlib](https://github.com/redlib-org/redlib) | `alpine-redlib` | 5252 | 1 | 512 MB | 1 GB | Alpine 3.22 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 4 | 2 |
| RAM | 512 MB | 4096 MB | 2304 MB |
| Disk | 1 GB | 10 GB | 5 GB |

**Supported Operating Systems:**
- Debian
- Ubuntu
- Alpine
- Debian

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 1337**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 4567**: Default interface port for many scripts
- **Port 5252**: Default interface port for many scripts
- **Port 7575**: Default interface port for many scripts


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
