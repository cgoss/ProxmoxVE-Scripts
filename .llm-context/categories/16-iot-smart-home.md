# 16 Iot Smart Home

## Category Information

**Category ID**: 16
**Number of Scripts**: 15

## Description

This category includes scripts for Debian, Alpine, Debian and related services.

## Scripts in This Category (15 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [ESPHome](https://esphome.io/) | `esphome` | 6052 | 2 | 1024 MB | 10 GB | Debian 12 |  |
| [FHEM](https://fhem.de/) | `fhem` | 8083 | 2 | 2048 MB | 8 GB | Debian 12 |  |
| [Home Assistant Container](https://www.home-assistant.io/) | `homeassistant` | 8123 | 2 | 2048 MB | 16 GB | Debian 13 |  |
| [Home Assistant OS](https://www.home-assistant.io/) | `haos-vm` | 8123 | 2 | 4096 MB | 32 GB | N/A |  |
| [Homebridge](https://homebridge.io/) | `homebridge` | 8581 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Jeedom](https://jeedom.com/) | `jeedom` | 80 | 2 | 2048 MB | 16 GB | Debian 12 |  |
| [Node-Red](https://nodered.org/) | `node-red` | 1880 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [PiMox HAOS](https://github.com/jiangcuo/Proxmox-Port) | `pimox-haos-vm` | 8123 | 2 | 4096 MB | 32 GB | N/A |  |
| [Podman Home Assistant Container](https://www.home-assistant.io/) | `podman-homeassistant` | 8123 | 2 | 2048 MB | 16 GB | Debian 13 |  |
| [TasmoAdmin](https://github.com/TasmoAdmin/TasmoAdmin#readme) | `tasmoadmin` | 9999 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [TasmoCompiler](https://github.com/benzino77/tasmocompiler) | `tasmocompiler` | 3000 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [evcc](https://evcc.io/en/) | `evcc` | 7070 | 1 | 1024 MB | 4 GB | Debian 12 |  |
| [ioBroker](https://www.iobroker.net/#en/intro) | `iobroker` | 8081 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [n8n](https://n8n.io/) | `n8n` | 5678 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [openHAB](https://www.openhab.org/) | `openhab` | 8443 | 2 | 2048 MB | 8 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 256 MB | 4096 MB | 2176 MB |
| Disk | 1 GB | 32 GB | 16 GB |

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
- **Port 1880**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 5678**: Default interface port for many scripts
- **Port 6052**: Default interface port for many scripts


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
