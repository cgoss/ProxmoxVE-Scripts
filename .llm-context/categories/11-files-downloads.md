# 11 Files Downloads

## Category Information

**Category ID**: 11
**Number of Scripts**: 24

## Description

This category includes scripts for Debian, Alpine, Debian and related services.

## Scripts in This Category (24 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Argus](https://release-argus.io/) | `argus` | 8080 | 1 | 256 MB | 3 GB | Debian 12 |  |
| [Aria2](https://aria2.github.io/) | `aria2` | 6880 | 2 | 1024 MB | 8 GB | Debian 12 |  |
| [Bitmagnet](https://bitmagnet.io/) | `bitmagnet` | 3333 | 2 | 1024 MB | 4 GB | Debian 12 |  |
| [Copyparty](https://github.com/9001/copyparty) | `copyparty` | N/A | None | None | None GB | N/A |  |
| [Deluge](https://www.deluge-torrent.org/) | `deluge` | 8112 | 2 | 2048 MB | 4 GB | Debian 12 |  |
| [Gokapi](https://github.com/Forceu/Gokapi) | `gokapi` | 53842 | 1 | 512 MB | 4 GB | Debian 12 |  |
| [Jackett](https://github.com/Jackett/Jackett) | `jackett` | 9117 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [MeTube](https://github.com/alexta69/metube) | `metube` | 8081 | 1 | 2048 MB | 10 GB | Debian 13 |  |
| [NZBGet](https://nzbget.com/) | `nzbget` | 6789 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [PairDrop](https://github.com/schlagmichdoch/PairDrop) | `pairdrop` | 3000 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [Palmr](https://palmr.kyantech.com.br/) | `palmr` | 3000 | 4 | 6144 MB | 6 GB | Debian 13 |  |
| [Rclone](https://rclone.org/) | `rclone` | 3000 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Real-Debrid Torrent Client](https://github.com/rogerfar/rdt-client) | `rdtclient` | 6500 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Resilio Sync](https://www.resilio.com/sync) | `resiliosync` | 8888 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [SABnzbd](https://sabnzbd.org/) | `sabnzbd` | 7777 | 2 | 2048 MB | 5 GB | Debian 13 |  |
| [SFTPGo](https://github.com/drakkan/sftpgo) | `sftpgo` | 8080 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [SnowShare](https://github.com/TuroYT/snowshare) | `snowshare` | 3000 | 1 | 1024 MB | 5 GB | Debian 13 |  |
| [Streamlink WebUI](https://github.com/CrazyWolf13/streamlink-webui) | `streamlink-webui` | 8000 | 2 | 2048 MB | 5 GB | Debian 13 |  |
| [Transmission](https://transmissionbt.com/) | `transmission` | 9091 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [Upgopher](https://github.com/wanetty/upgopher) | `upgopher` | 9090 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [Zipline](https://zipline.diced.sh/) | `zipline` | 3000 | 2 | 2048 MB | 5 GB | Debian 13 |  |
| [qBittorrent](https://www.qbittorrent.org/) | `qbittorrent` | 8090 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [slskd](https://github.com/slskd/slskd) | `slskd` | 5030 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [yt-dlp-webui](https://github.com/marcopiovanello/yt-dlp-web-ui) | `yt-dlp-webui` | 3033 | 2 | 1024 MB | 4 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 4 | 2 |
| RAM | 256 MB | 6144 MB | 3200 MB |
| Disk | 1 GB | 10 GB | 5 GB |

**Supported Operating Systems:**
- Debian
- Alpine
- Debian

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 3000**: Default interface port for many scripts
- **Port 3033**: Default interface port for many scripts
- **Port 3333**: Default interface port for many scripts
- **Port 5030**: Default interface port for many scripts
- **Port 6500**: Default interface port for many scripts


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
