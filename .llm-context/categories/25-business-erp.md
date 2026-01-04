# 25 Business Erp

## Category Information

**Category ID**: 25
**Number of Scripts**: 15

## Description

This category includes scripts for Debian, Debian, Ubuntu and related services.

## Scripts in This Category (15 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Dolibarr](https://www.dolibarr.org/) | `dolibarr` | 80 | 1 | 2048 MB | 6 GB | Debian 12 |  |
| [GLPI](https://glpi-project.org/) | `glpi` | 80 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [Ghost](https://ghost.org) | `ghost` | 2368 | 2 | 1024 MB | 5 GB | Debian 12 |  |
| [ITSM-NG](https://itsm-ng.com) | `itsm-ng` | 80 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [InvenTree](https://inventree.org) | `inventree` | 80 | 2 | 2048 MB | 6 GB | Ubuntu 24.04 |  |
| [InvoiceNinja](https://invoiceninja.com/) | `invoiceninja` | 8080 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [Kimai](https://www.kimai.org/) | `kimai` | N/A | 2 | 2048 MB | 7 GB | Debian 13 |  |
| [LimeSurvey](https://community.limesurvey.org/) | `limesurvey` | 80 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Mattermost](https://mattermost.com/) | `mattermost` | 8065 | 1 | 2048 MB | 8 GB | Ubuntu 24.04 |  |
| [NocoDB](https://www.nocodb.com/) | `nocodb` | 8080 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Odoo](https://www.odoo.com/) | `odoo` | 8069 | 2 | 2048 MB | 6 GB | Debian 12 |  |
| [OpenProject](https://www.openproject.org) | `openproject` | 80 | 2 | 4096 MB | 8 GB | Debian 13 |  |
| [Part-DB](https://github.com/Part-DB/Part-DB-server) | `part-db` | 80 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [SnipeIT](https://snipeitapp.com/) | `snipeit` | 80 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [Zammad](https://zammad.org/) | `zammad` | N/A | 2 | 4096 MB | 8 GB | Debian 12 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 512 MB | 4096 MB | 2304 MB |
| Disk | 2 GB | 10 GB | 6 GB |

**Supported Operating Systems:**
- Debian
- Debian
- Ubuntu

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 2368**: Default interface port for many scripts
- **Port 8065**: Default interface port for many scripts
- **Port 8069**: Default interface port for many scripts
- **Port 8080**: Default interface port for many scripts


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
