# 06 Authentication Security

## Category Information

**Category ID**: 6
**Number of Scripts**: 13

## Description

This category includes scripts for Debian, Alpine, Debian and related services.

## Scripts in This Category (13 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [2FAuth](https://2fauth.app/) | `2fauth` | 80 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Alpine-Tinyauth](https://tinyauth.app) | `alpine-tinyauth` | 3000 | 1 | 256 MB | 2 GB | Alpine 3.22 |  |
| [Authelia](https://www.authelia.com/) | `authelia` | 443 | 1 | 512 MB | 2 GB | Debian 12 |  |
| [BunkerWeb](https://www.bunkerweb.io/) | `bunkerweb` | N/A | 2 | 8192 MB | 4 GB | Debian 12 |  |
| [CrowdSec](https://crowdsec.net/) | `crowdsec` | N/A | None | None | None GB | N/A |  |
| [Infisical](https://infisical.com/) | `infisical` | 8080 | 2 | 2048 MB | 6 GB | Debian 13 |  |
| [Keycloak](https://www.keycloak.org/) | `keycloak` | 8080 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [OTS](https://github.com/Luzifer/ots) | `ots` | 443 | 1 | 512 MB | 3 GB | Debian 13 |  |
| [Passbolt](https://www.passbolt.com/) | `passbolt` | 443 | 2 | 2048 MB | 2 GB | Debian 13 |  |
| [Pocket ID](https://github.com/pocket-id/pocket-id) | `pocketid` | 1411 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [Vaultwarden](https://github.com/dani-garcia/vaultwarden/) | `vaultwarden` | 8000 | 4 | 6144 MB | 20 GB | Debian 13 |  |
| [Zitadel](https://zitadel.com) | `zitadel` | 8080 | 1 | 1024 MB | 8 GB | Debian 13 |  |
| [lldap](https://github.com/lldap/lldap) | `lldap` | 17170 | 1 | 512 MB | 4 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 4 | 2 |
| RAM | 256 MB | 8192 MB | 4224 MB |
| Disk | 1 GB | 20 GB | 10 GB |

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
- **Port 443**: Default interface port for many scripts
- **Port 1411**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 8000**: Default interface port for many scripts


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
