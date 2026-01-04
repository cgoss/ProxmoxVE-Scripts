# 17 Zigbee Zwave Matter

## Category Information

**Category ID**: 17
**Number of Scripts**: 4

## Description

This category includes scripts for Alpine, Debian and related services.

## Scripts in This Category (4 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Matterbridge](https://github.com/Luligu/matterbridge) | `matterbridge` | 8283 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Z-Wave JS UI](https://github.com/zwave-js/zwave-js-ui#) | `zwave-js-ui` | 8091 | 2 | 1024 MB | 4 GB | Debian 13 | ✓ |
| [Zigbee2MQTT](https://www.zigbee2mqtt.io/) | `zigbee2mqtt` | 9442 | 2 | 1024 MB | 5 GB | Debian 13 | ✓ |
| [deCONZ](https://www.phoscon.de/en/conbee2/software#deconz) | `deconz` | 80 | 2 | 1024 MB | 4 GB | Debian 12 | ✓ |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 256 MB | 1024 MB | 640 MB |
| Disk | 1 GB | 5 GB | 3 GB |

**Supported Operating Systems:**
- Alpine
- Debian

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 8091**: Default interface port for many scripts
- **Port 8283**: Default interface port for many scripts
- **Port 9442**: Default interface port for many scripts

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
