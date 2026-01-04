# 15 Nvr Cameras

## Category Information

**Category ID**: 15
**Number of Scripts**: 5

## Description

This category includes scripts for Debian, Ubuntu and related services.

## Scripts in This Category (5 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [AgentDVR](https://www.ispyconnect.com/) | `agentdvr` | 8090 | 2 | 2048 MB | 8 GB | Ubuntu 24.04 | ✓ |
| [MotionEye NVR](https://github.com/motioneye-project/motioneye) | `motioneye` | 8765 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [Nx Witness](https://www.networkoptix.com/nx-witness) | `nxwitness` | 7001 | 2 | 2048 MB | 8 GB | Ubuntu 24.04 | ✓ |
| [Shinobi NVR](https://shinobi.video/) | `shinobi` | 8080 | 2 | 2048 MB | 8 GB | Ubuntu 24.04 |  |
| [go2rtc](https://github.com/AlexxIT/go2rtc) | `go2rtc` | 1984 | 2 | 2048 MB | 4 GB | Debian 12 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 2 | 2 | 2 |
| RAM | 2048 MB | 2048 MB | 2048 MB |
| Disk | 4 GB | 8 GB | 6 GB |

**Supported Operating Systems:**
- Debian
- Ubuntu

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 1984**: Default interface port for many scripts
- **Port 7001**: Default interface port for many scripts
- **Port 8080**: Default interface port for many scripts
- **Port 8090**: Default interface port for many scripts
- **Port 8765**: Default interface port for many scripts

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
