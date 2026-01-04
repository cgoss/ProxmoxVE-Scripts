# 01 Proxmox Virtualization

## Category Information

**Category ID**: 1
**Number of Scripts**: 36

## Description

This category includes scripts for Debian, Debian and related services.

## Scripts in This Category (36 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [All Templates](None) | `all-templates` | N/A | None | None | None GB | N/A |  |
| [Coder Code Server](https://coder.com/) | `coder-code-server` | 8680 | None | None | None GB | N/A |  |
| [File Browser](https://filebrowser.org/index.html#features) | `filebrowser` | 8080 | None | None | None GB | N/A |  |
| [FileBrowser Quantum](https://github.com/gtsteffaniak/filebrowser) | `filebrowser-quantum` | 8080 | None | None | None GB | N/A |  |
| [Intel e1000e NIC Offloading Fix](None) | `nic-offloading-fix` | N/A | None | None | None GB | N/A |  |
| [NetBird](https://netbird.io/) | `add-netbird-lxc` | N/A | None | None | None GB | N/A |  |
| [PBS 4 Upgrade](https://www.proxmox.com/en/proxmox-backup-server) | `pbs4-upgrade` | N/A | None | None | None GB | N/A |  |
| [PBS Post Install](None) | `post-pbs-install` | N/A | None | None | None GB | N/A |  |
| [PBS Processor Microcode](None) | `pbs-microcode` | N/A | None | None | None GB | N/A |  |
| [PMG Post Install](None) | `post-pmg-install` | N/A | None | None | None GB | N/A |  |
| [PVE CPU Scaling Governor](None) | `scaling-governor` | N/A | None | None | None GB | N/A |  |
| [PVE Clean Orphaned LVM](None) | `clean-orphaned-lvm` | N/A | None | None | None GB | N/A |  |
| [PVE Cron LXC Updater](None) | `cron-update-lxcs` | N/A | None | None | None GB | N/A |  |
| [PVE Host Backup](None) | `host-backup` | N/A | None | None | None GB | N/A |  |
| [PVE Kernel Clean](None) | `kernel-clean` | N/A | None | None | None GB | N/A |  |
| [PVE Kernel Pin](None) | `kernel-pin` | N/A | None | None | None GB | N/A |  |
| [PVE LXC Cleaner](None) | `clean-lxcs` | N/A | None | None | None GB | N/A |  |
| [PVE LXC Deletion](None) | `lxc-delete` | N/A | None | None | None GB | N/A |  |
| [PVE LXC Execute Command](None) | `lxc-execute` | N/A | None | None | None GB | N/A |  |
| [PVE LXC Filesystem Trim](None) | `fstrim` | N/A | None | None | None GB | N/A |  |
| [PVE LXC Tag](None) | `add-iptag` | N/A | None | None | None GB | N/A |  |
| [PVE LXC Updater](None) | `update-lxcs` | N/A | None | None | None GB | N/A |  |
| [PVE Monitor-All](None) | `monitor-all` | N/A | None | None | None GB | N/A |  |
| [PVE Netdata](https://www.netdata.cloud/) | `netdata` | 19999 | None | None | None GB | N/A |  |
| [PVE Post Install](None) | `post-pve-install` | N/A | None | None | None GB | N/A |  |
| [PVE Privilege Converter](None) | `pve-privilege-converter` | N/A | None | None | None GB | N/A |  |
| [PVE Processor Microcode](None) | `microcode` | N/A | None | None | None GB | N/A |  |
| [PVE Update Repositories](None) | `update-repo` | N/A | None | None | None GB | N/A |  |
| [PVEScriptsLocal](https://community-scripts.github.io/ProxmoxVE) | `pve-scripts-local` | 3000 | 2 | 4096 MB | 4 GB | Debian 13 |  |
| [Prometheus Blackbox Exporter](https://github.com/prometheus/blackbox_exporter) | `prometheus-blackbox-exporter` | 9115 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [Prometheus Proxmox VE Exporter](https://github.com/prometheus-pve/prometheus-pve-exporter) | `prometheus-pve-exporter` | 9221 | 1 | 512 MB | 2 GB | Debian 13 |  |
| [Proxmox Backup Server (PBS)](https://www.proxmox.com/en/proxmox-backup-server/overview) | `proxmox-backup-server` | 8007 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [Proxmox Datacenter Manager (PDM)](https://pve.proxmox.com/wiki/Proxmox_Datacenter_Manager_Roadmap) | `proxmox-datacenter-manager` | 8443 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [Proxmox Mail Gateway (PMG)](https://www.proxmox.com/en/products/proxmox-mail-gateway/overview) | `proxmox-mail-gateway` | 8006 | 2 | 4096 MB | 10 GB | Debian 13 |  |
| [Tailscale](https://tailscale.com/) | `add-tailscale-lxc` | N/A | None | None | None GB | N/A |  |
| [Webmin System Administration](https://webmin.com/) | `webmin` | 10000 | None | None | None GB | N/A |  |


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

## Common Patterns

### Installation Patterns
- Most scripts use **Debian** as the base operating system

### Common Ports
- **Port 3000**: Default interface port for many scripts
- **Port 8006**: Default interface port for many scripts
- **Port 8007**: Default interface port for many scripts
- **Port 8080**: Default interface port for many scripts
- **Port 8443**: Default interface port for many scripts


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
