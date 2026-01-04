# 18 Mqtt Messaging

## Category Information

**Category ID**: 18
**Number of Scripts**: 5

## Description

This category includes scripts for Debian and related services.

## Scripts in This Category (5 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [EMQX](https://www.emqx.io/) | `emqx` | 18083 | 2 | 1024 MB | 4 GB | Debian 12 |  |
| [HiveMQ CE](https://www.hivemq.com/) | `hivemq` | 1883 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [MQTT](https://mosquitto.org/) | `mqtt` | N/A | 1 | 512 MB | 2 GB | Debian 13 |  |
| [PS5-MQTT](https://github.com/FunkeyFlo/) | `ps5-mqtt` | 8645 | 1 | 512 MB | 3 GB | Debian 13 |  |
| [RabbitMQ](https://www.rabbitmq.com/) | `rabbitmq` | 15672 | 1 | 1024 MB | 4 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 512 MB | 1024 MB | 768 MB |
| Disk | 2 GB | 4 GB | 3 GB |

**Supported Operating Systems:**
- Debian

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 1883**: Default interface port for many scripts
- **Port 8645**: Default interface port for many scripts
- **Port 15672**: Default interface port for many scripts
- **Port 18083**: Default interface port for many scripts


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
