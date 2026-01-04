# 09 Monitoring Analytics

## Category Information

**Category ID**: 9
**Number of Scripts**: 33

## Description

This category includes scripts for Debian, Ubuntu, Alpine and related services.

## Scripts in This Category (33 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Beszel](https://beszel.dev/) | `beszel` | 8090 | 1 | 512 MB | 5 GB | Debian 12 |  |
| [Checkmk](https://checkmk.com/) | `checkmk` | 80 | 2 | 2048 MB | 4 GB | N/A |  |
| [ConvertX](https://github.com/C4illin/ConvertX) | `convertx` | 3000 | 2 | 4096 MB | 20 GB | Debian 12 |  |
| [Domain Locker](https://github.com/Lissy93/domain-locker) | `domain-locker` | 3000 | 2 | 4096 MB | 8 GB | Debian 13 |  |
| [Domain Monitor](https://github.com/Hosteroid/domain-monitor) | `domain-monitor` | 80 | 2 | 512 MB | 2 GB | Debian 13 |  |
| [Glances](https://nicolargo.github.io/glances/) | `glances` | 61208 | None | None | None GB | N/A |  |
| [Grafana](https://grafana.com/) | `grafana` | 3000 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Graylog](https://graylog.org/) | `graylog` | 9000 | 2 | 8192 MB | 30 GB | Debian 13 |  |
| [Healthchecks](https://healthchecks.io/) | `healthchecks` | 3000 | 2 | 2048 MB | 5 GB | Debian 13 |  |
| [Kasm](https://www.kasmweb.com/) | `kasm` | 443 | 2 | 8192 MB | 50 GB | Debian 13 | ✓ |
| [LibreNMS](https://librenms.org/) | `librenms` | 80 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [LinkStack](https://linkstack.org/) | `linkstack` | 80 | 1 | 1024 MB | 5 GB | Debian 13 |  |
| [Metabase](https://www.metabase.com/) | `metabase` | 3000 | 2 | 2048 MB | 6 GB | Debian 13 |  |
| [OpenObserve](https://openobserve.ai/) | `openobserve` | 5080 | 1 | 512 MB | 3 GB | Debian 13 |  |
| [PatchMon](https://patchmon.net) | `patchmon` | 3399 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [Pi-Hole Exporter](https://github.com/eko/pihole-exporter) | `pihole-exporter` | 9617 | None | None | None GB | N/A |  |
| [Prometheus](https://prometheus.io/) | `prometheus` | 9090 | 1 | 2048 MB | 4 GB | Debian 13 |  |
| [Prometheus Alertmanager](https://prometheus.io/) | `prometheus-alertmanager` | 9093 | 1 | 1024 MB | 2 GB | Debian 13 |  |
| [Prometheus Paperless NGX Exporter](https://github.com/hansmi/prometheus-paperless-exporter) | `prometheus-paperless-ngx-exporter` | 8081 | 1 | 256 MB | 2 GB | Debian 13 |  |
| [Pulse](https://github.com/rcourtman/Pulse) | `pulse` | 7655 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Scanopy](https://scanopy.net) | `scanopy` | 60072 | 2 | 3072 MB | 6 GB | Debian 13 |  |
| [SigNoz](https://signoz.io/) | `signoz` | 8080 | 2 | 4096 MB | 20 GB | Debian 13 |  |
| [Splunk Enterprise](https://www.splunk.com/en_us/download/splunk-enterprise.html) | `splunk-enterprise` | 8000 | 4 | 8192 MB | 40 GB | Ubuntu 24.04 |  |
| [Telegraf](https://github.com/influxdata/telegraf) | `telegraf` | N/A | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Tianji](https://tianji.msgbyte.com/) | `tianji` | 12345 | 4 | 4096 MB | 12 GB | Debian 13 |  |
| [Tracktor](https://github.com/javedh-dev/tracktor) | `tracktor` | 3000 | 1 | 1024 MB | 6 GB | Debian 13 |  |
| [Umami](https://umami.is/) | `umami` | 3000 | 2 | 2048 MB | 12 GB | Debian 13 |  |
| [Uptime Kuma](https://github.com/louislam/uptime-kuma#uptime-kuma) | `uptimekuma` | 3001 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Valkey](https://valkey.io/) | `valkey` | 6379 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Wazuh](https://wazuh.com/) | `wazuh` | 443 | 4 | 4096 MB | 25 GB | Debian 12 |  |
| [Zabbix](https://www.zabbix.com/) | `zabbix` | N/A | 2 | 4096 MB | 6 GB | Debian 13 |  |
| [gatus](https://gatus.io/) | `gatus` | 8080 | 1 | 512 MB | 4 GB | Debian 12 |  |
| [qbittorrent Exporter](https://github.com/martabal/qbittorrent-exporter) | `qbittorrent-exporter` | 8090 | None | None | None GB | N/A |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 4 | 2 |
| RAM | 256 MB | 8192 MB | 4224 MB |
| Disk | 1 GB | 50 GB | 25 GB |

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
- **Port 80**: Default interface port for many scripts
- **Port 443**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 3001**: Default interface port for many scripts
- **Port 3399**: Default interface port for many scripts

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
