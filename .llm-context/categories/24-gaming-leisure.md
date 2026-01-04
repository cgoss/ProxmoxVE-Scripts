# 24 Gaming Leisure

## Category Information

**Category ID**: 24
**Number of Scripts**: 27

## Description

This category includes scripts for Debian, Alpine, Debian and related services.

## Scripts in This Category (27 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [AdventureLog](https://adventurelog.app/) | `adventurelog` | 3000 | 2 | 2048 MB | 7 GB | Debian 13 |  |
| [Bar-Assistant](https://barassistant.app/) | `bar-assistant` | 80 | 2 | 2048 MB | 4 GB | Debian 12 |  |
| [Change Detection](https://changedetection.io/) | `changedetection` | 5000 | 4 | 4096 MB | 10 GB | Debian 12 |  |
| [Crafty Controller](https://craftycontrol.com/) | `crafty-controller` | 8443 | 2 | 4096 MB | 16 GB | Debian 12 |  |
| [DiscoPanel](https://discopanel.app/) | `discopanel` | 8080 | 4 | 4096 MB | 15 GB | Debian 13 |  |
| [Endurain](https://github.com/joaovitoriasilva/endurain) | `endurain` | 8080 | 2 | 2048 MB | 5 GB | Debian 13 |  |
| [HomeBox](https://homebox.software/en/) | `homebox` | 7745 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [HortusFox](https://www.hortusfox.com/) | `hortusfox` | 80 | 2 | 2048 MB | 5 GB | Debian 13 |  |
| [InspIRCd 4](https://www.inspircd.org/) | `inspircd` | 6667 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Koillection](https://koillection.github.io/) | `koillection` | 80 | 2 | 1024 MB | 8 GB | Debian 13 |  |
| [LubeLogger](https://lubelogger.com/) | `lubelogger` | 5000 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [MagicMirror Server](https://docs.magicmirror.builders/) | `magicmirror` | 8080 | 1 | 512 MB | 3 GB | Debian 13 |  |
| [Monica](https://www.monicahq.com/) | `monica` | 80 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [OctoPrint](https://octoprint.org/) | `octoprint` | 5000 | 1 | 1024 MB | 4 GB | Debian 13 | ✓ |
| [Pelican Panel](https://pelican.dev/) | `pelican-panel` | 80 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Pelican Wings](https://pelican.dev/) | `pelican-wings` | N/A | 2 | 4096 MB | 8 GB | Debian 13 |  |
| [Pf2eTools](https://pf2etools.com/) | `pf2etools` | 80 | 1 | 512 MB | 6 GB | Debian 13 |  |
| [Plant-it](https://plant-it.org/) | `plant-it` | 3000 | 2 | 2048 MB | 5 GB | Debian 13 |  |
| [Pterodactyl Panel](https://pterodactyl.io) | `pterodactyl-panel` | 80 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Pterodactyl Wings](https://pterodactyl.io) | `pterodactyl-wings` | N/A | 2 | 4096 MB | 8 GB | Debian 13 |  |
| [Spoolman](https://github.com/Donkie/Spoolman) | `spoolman` | 7912 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Tandoor Recipes](https://tandoor.dev/) | `tandoor` | 8002 | 4 | 4096 MB | 10 GB | Debian 13 |  |
| [Teamspeak-Server](https://teamspeak.com/) | `teamspeak-server` | 9987 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Wanderer](https://wanderer.to) | `wanderer` | 3000 | 2 | 4096 MB | 8 GB | Debian 13 |  |
| [Wavelog](https://www.wavelog.org/) | `wavelog` | 80 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [grocy](https://grocy.info/) | `grocy` | 80 | 1 | 512 MB | 2 GB | Debian 12 |  |
| [wger](https://wger.de) | `wger` | 3000 | 1 | 1024 MB | 6 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 4 | 2 |
| RAM | 256 MB | 4096 MB | 2176 MB |
| Disk | 2 GB | 16 GB | 9 GB |

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
- **Port 5000**: Default interface port for many scripts
- **Port 6667**: Default interface port for many scripts
- **Port 7745**: Default interface port for many scripts

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
