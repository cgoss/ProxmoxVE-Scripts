# Master Index - LLM Context System

## Overview

This index provides multiple ways to locate appropriate script context files for any service.

---

## Navigation Methods

### 1. By Category (26 Categories)

Browse by service category to find relevant scripts:

| ID | Category | Description | Script Count |
|-----|-----------|-------------|---------------|
| 1 | Proxmox & Virtualization | Tools and scripts to manage Proxmox VE | [View Scripts](categories/01-proxmox-virtualization.md) |
| 2 | Operating Systems | Scripts for deploying and managing various operating systems | [View Scripts](categories/02-operating-systems.md) |
| 3 | Containers & Docker | Solutions for containerization using Docker and related technologies | [View Scripts](categories/03-containers-docker.md) |
| 4 | Network & Firewall | Enhance network security and configure firewalls | [View Scripts](categories/04-network-firewall.md) |
| 5 | Adblock & DNS | Optimize your network with DNS and ad-blocking solutions | [View Scripts](categories/05-adblock-dns.md) |
| 6 | Authentication & Security | Secure your infrastructure with authentication and security tools | [View Scripts](categories/06-authentication-security.md) |
| 7 | Backup & Recovery | Reliable backup and recovery scripts to protect your data | [View Scripts](categories/07-backup-recovery.md) |
| 8 | Databases | Deploy and manage robust database systems | [View Scripts](categories/08-databases.md) |
| 9 | Monitoring & Analytics | Monitor system performance and analyze data | [View Scripts](categories/09-monitoring-analytics.md) |
| 10 | Dashboards & Frontends | Create interactive dashboards and user-friendly frontends | [View Scripts](categories/10-dashboards-frontends.md) |
| 11 | Files & Downloads | Manage file sharing and downloading solutions | [View Scripts](categories/11-files-downloads.md) |
| 12 | Documents & Notes | Organize and manage documents and note-taking tools | [View Scripts](categories/12-documents-notes.md) |
| 13 | Media & Streaming | Stream and manage media effortlessly across devices | [View Scripts](categories/13-media-streaming.md) |
| 14 | *Arr Suite | Automated media management with popular *Arr suite tools | [View Scripts](categories/14-arr-suite.md) |
| 15 | NVR & Cameras | Manage network video recorders and camera setups | [View Scripts](categories/15-nvr-cameras.md) |
| 16 | IoT & Smart Home | Control and automate IoT devices and smart home systems | [View Scripts](categories/16-iot-smart-home.md) |
| 17 | ZigBee, Z-Wave & Matter | Solutions for ZigBee, Z-Wave, and Matter-based device management | [View Scripts](categories/17-zigbee-zwave-matter.md) |
| 18 | MQTT & Messaging | Set up reliable messaging and MQTT-based communication systems | [View Scripts](categories/18-mqtt-messaging.md) |
| 19 | Automation & Scheduling | Automate tasks and manage scheduling with powerful tools | [View Scripts](categories/19-automation-scheduling.md) |
| 20 | AI / Coding & Dev-Tools | Leverage AI and developer tools for smarter coding workflows | [View Scripts](categories/20-ai-coding-devtools.md) |
| 21 | Webservers & Proxies | Deploy and configure web servers and proxy solutions | [View Scripts](categories/21-webservers-proxies.md) |
| 22 | Bots & ChatOps | Enhance collaboration with bots and ChatOps integrations | [View Scripts](categories/22-bots-chatops.md) |
| 23 | Finance & Budgeting | Track expenses and manage budgets efficiently | [View Scripts](categories/23-finance-budgeting.md) |
| 24 | Gaming & Leisure | Scripts for gaming servers and leisure-related tools | [View Scripts](categories/24-gaming-leisure.md) |
| 25 | Business & ERP | Streamline business operations with ERP and management tools | [View Scripts](categories/25-business-erp.md) |
| 0 | Miscellaneous | General scripts and tools that don't fit into other categories | [View Scripts](categories/99-miscellaneous.md) |

---

### 2. By Keyword Search Patterns

Use these keywords to find relevant scripts:

| Keywords | Likely Scripts | Category |
|----------|----------------|------------|
| **Database, SQL, NoSQL** | postgresql, mariadb, mysql, mongodb, redis | 8 (Databases) |
| **Docker, Container, Podman** | docker, alpine-docker, podman | 3 (Containers & Docker) |
| **VPN, Tunnel, WireGuard, Tailscale** | wireguard, alpine-wireguard, tailscale | 4 (Network & Firewall) |
| **DNS, AdBlock, Pi-hole, Block** | adguard, pi-hole, unbound, blocky | 5 (Adblock & DNS) |
| **Auth, Security, 2FA, Password** | authelia, vaultwarden, 2fauth, bitwarden | 6 (Authentication & Security) |
| **Backup, Sync, Rclone, Restic** | duplicati, rclone, syncthing, restic, backrest | 7 (Backup & Recovery) |
| **Monitor, Grafana, Prometheus, Zabbix** | grafana, alpine-grafana, prometheus, alpine-prometheus, zabbix | 9 (Monitoring & Analytics) |
| **Plex, Jellyfin, Emby, Media** | plex, jellyfin, emby, immich | 13 (Media & Streaming) |
| **Sonarr, Radarr, Bazarr, Lidarr** | sonarr, radarr, bazarr, lidarr | 14 (*Arr Suite) |
| **Camera, NVR, Frigate, Motion** | frigate, agentdvr, motioneye | 15 (NVR & Cameras) |
| **ZigBee, Z-Wave, Zigbee2MQTT** | zigbee2mqtt, alpine-zigbee2mqtt | 17 (ZigBee, Z-Wave & Matter) |
| **MQTT, Broker, Message Queue** | emqx, rabbitmq, mqtt | 18 (MQTT & Messaging) |
| **AI, Ollama, ComfyUI, Coding** | ollama, comfyui, coder-code-server | 20 (AI / Coding & Dev-Tools) |
| **Nginx, Caddy, Traefik, Proxy** | nginx, caddy, alpine-caddy, traefik, alpine-traefik | 21 (Webservers & Proxies) |
| **Note, Markdown, Docs** | silverbullet, joplin, docsify | 12 (Documents & Notes) |

---

### 3. By Port-Based Lookup

Common service ports and their scripts:

| Port | Protocol | Services | Context File |
|-------|-----------|-----------|--------------|
| 80, 443, 8080 | HTTP/HTTPS | Nginx, Caddy, Apache, Traefik, Home Assistant |
| 3000 | HTTP | Grafana, Node.js apps, OpenWebUI |
| 5432 | TCP | PostgreSQL, alpine-postgresql |
| 3306 | TCP | MySQL, MariaDB, alpine-mariadb |
| 6379 | TCP | Redis, alpine-redis |
| 27017 | TCP | MongoDB |
| 9092 | TCP | Kafka, alpine-kafka |
| 32400 | TCP | Plex |
| 8096 | TCP | Jellyfin |
| 2368 | TCP | Emby |
| 1883 | TCP | MQTT (EMQX, Mosquitto) |
| 8123 | TCP | MongoDB |
| 5672 | TCP | Unbound |
| 53 | UDP/TCP | AdGuard, Pi-hole, Blocky |

---

### 4. Special Requirements Index

Scripts that require specific hardware or features:

#### GPU Passthrough (var_gpu=yes)
**Use for:** AI tools, media servers, video processing, NVR

**Scripts:** agentdvr, channels, comfyui, convertx, dispatcharr, emby, ersatztv, fileflows, frigate, go2rtc, hyperhdr, hyperion, immich, jellyfin, libretranslate, mediamtx, motioneye, nextpvr, nxwitness, ollama, openwebui, owncast, photoprism, plex, shinobi, tdarr, threadfin, tunarr, uhf, unmanic

**Context files:** Each script has dedicated context file in `scripts/` directory

---

#### FUSE Filesystem Support (var_fuse=yes)
**Use for:** Rclone, AppImage, mergerfs, special filesystems

**Scripts:** alpine-rclone, cosmos, kasm, minarca, rclone

---

#### TUN/TAP Device Support (var_tun=yes/1)
**Use for:** VPN, WireGuard, Tailscale, tunneling

**Scripts:** alpine-wireguard, kasm, pangolin, wireguard

---

#### LXC Nesting (Docker-in-LXC)
**Use for:** Running Docker or containers within LXC containers

**Scripts:** docker, alpine-docker (implicit nesting required)

---

### 5. Top 50 Popular Scripts

Most commonly requested and used services:

| Rank | Script | Category | Description | Context File |
|-------|---------|-----------|---------------|
| 1 | Docker | Containers & Docker | [docker.md](scripts/docker.md) |
| 2 | PostgreSQL | Databases | [postgresql.md](scripts/postgresql.md) |
| 3 | Grafana | Monitoring & Analytics | [grafana.md](scripts/grafana.md) |
| 4 | Plex | Media & Streaming | [plex.md](scripts/plex.md) |
| 5 | Jellyfin | Media & Streaming | [jellyfin.md](scripts/jellyfin.md) |
| 6 | Nginx | Webservers & Proxies | [nginx.md](scripts/nginx.md) |
| 7 | Home Assistant | IoT & Smart Home | [homeassistant.md](scripts/homeassistant.md) |
| 8 | Redis | Databases | [redis.md](scripts/redis.md) |
| 9 | MongoDB | Databases | [mongodb.md](scripts/mongodb.md) |
| 10 | AdGuard | Adblock & DNS | [adguard.md](scripts/adguard.md) |
| 11 | Caddy | Webservers & Proxies | [caddy.md](scripts/caddy.md) |
| 12 | MariaDB | Databases | [mariadb.md](scripts/mariadb.md) |
| 13 | Traefik | Webservers & Proxies | [traefik.md](scripts/traefik.md) |
| 14 | Authelia | Authentication & Security | [authelia.md](scripts/authelia.md) |
| 15 | Vaultwarden | Authentication & Security | [vaultwarden.md](scripts/vaultwarden.md) |
| 16 | WireGuard | Network & Firewall | [wireguard.md](scripts/wireguard.md) |
| 17 | Pi-hole | Adblock & DNS | [pi-hole.md](scripts/pi-hole.md) |
| 18 | Frigate | NVR & Cameras | [frigate.md](scripts/frigate.md) |
| 19 | Immich | Media & Streaming | [immich.md](scripts/immich.md) |
| 20 | Uptime Kuma | Monitoring & Analytics | [uptime-kuma.md](scripts/uptime-kuma.md) |
| 21 | Zabbix | Monitoring & Analytics | [zabbix.md](scripts/zabbix.md) |
| 22 | Portainer | Containers & Docker | [portainer.md](scripts/portainer.md) |
| 23 | Nextcloud | Files & Downloads | [nextcloud.md](scripts/nextcloud.md) |
| 24 | NocoDB | Databases | [nocodb.md](scripts/nocodb.md) |
| 25 | InfluxDB | Databases | [influxdb.md](scripts/influxdb.md) |
| 26 | Prometheus | Monitoring & Analytics | [prometheus.md](scripts/prometheus.md) |
| 27 | Sonarr | *Arr Suite | [sonarr.md](scripts/sonarr.md) |
| 28 | Radarr | *Arr Suite | [radarr.md](scripts/radarr.md) |
| 29 | Bazarr | *Arr Suite | [bazarr.md](scripts/bazarr.md) |
| 30 | Lidarr | *Arr Suite | [lidarr.md](scripts/lidarr.md) |
| 31 | Tailscale | Network & Firewall | [tailscale.md](scripts/tailscale.md) |
| 32 | OpenSpeedTest | Monitoring & Analytics | [openspeedtest.md](scripts/openspeedtest.md) |
| 33 | Netdata | Monitoring & Analytics | [netdata.md](scripts/netdata.md) |
| 34 | Paperless-ngx | Documents & Notes | [paperless-ngx.md](scripts/paperless-ngx.md) |
| 35 | Jellyseerr | *Arr Suite | [jellyseerr.md](scripts/jellyseerr.md) |
| 36 | Audiobookshelf | Files & Downloads | [audiobookshelf.md](scripts/audiobookshelf.md) |
| 37 | Zigbee2MQTT | ZigBee, Z-Wave & Matter | [zigbee2mqtt.md](scripts/zigbee2mqtt.md) |
| 38 | CrowdSec | Network & Firewall | [crowdsec.md](scripts/crowdsec.md) |
| 39 | Syncthing | Backup & Recovery | [syncthing.md](scripts/syncthing.md) |
| 40 | Rclone | Backup & Recovery | [rclone.md](scripts/rclone.md) |
| 41 | Apache Guacamole | Dashboards & Frontends | [apache-guacamole.md](scripts/apache-guacamole.md) |
| 42 | FileBrowser | Files & Downloads | [filebrowser.md](scripts/filebrowser.md) |
| 43 | Nginx Proxy Manager | Webservers & Proxies | [nginx-proxy-manager.md](scripts/nginx-proxy-manager.md) |
| 44 | Duplicati | Backup & Recovery | [duplicati.md](scripts/duplicati.md) |
| 45 | SFTPGo | Files & Downloads | [sftpgo.md](scripts/sftpgo.md) |
| 46 | Whisparr | *Arr Suite | [whisparr.md](scripts/whisparr.md) |
| 47 | Blocky | Adblock & DNS | [blocky.md](scripts/blocky.md) |
| 48 | Unbound | Adblock & DNS | [unbound.md](scripts/unbound.md) |
| 49 | FileFlows | Automation & Scheduling | [fileflows.md](scripts/fileflows.md) |
| 50 | MotionEye | NVR & Cameras | [motioneye.md](scripts/motioneye.md) |

---

### 6. By Script Section (41 Sections)

Scripts are organized into 41 sections of ~10 files each for maintainability:

| Section | Script Range | Status | Context Location |
|----------|---------------|--------|------------------|
| Section-01 | Scripts 1-10 | [Pending] | [scripts/section-01/](scripts/section-01/) |
| Section-02 | Scripts 11-20 | [Pending] | [scripts/section-02/](scripts/section-02/) |
| Section-03 | Scripts 21-30 | [Pending] | [scripts/section-03/](scripts/section-03/) |
| Section-04 | Scripts 31-40 | [Pending] | [scripts/section-04/](scripts/section-04/) |
| Section-05 | Scripts 41-50 | [Pending] | [scripts/section-05/](scripts/section-05/) |
| Section-06 | Scripts 51-60 | [Pending] | [scripts/section-06/](scripts/section-06/) |
| Section-07 | Scripts 61-70 | [Pending] | [scripts/section-07/](scripts/section-07/) |
| Section-08 | Scripts 71-80 | [Pending] | [scripts/section-08/](scripts/section-08/) |
| Section-09 | Scripts 81-90 | [Pending] | [scripts/section-09/](scripts/section-09/) |
| Section-10 | Scripts 91-100 | [Pending] | [scripts/section-10/](scripts/section-10/) |
| Section-11 | Scripts 101-110 | [Pending] | [scripts/section-11/](scripts/section-11/) |
| ... | ... | ... | ... |
| Section-41 | Scripts 401-408 | [Pending] | [scripts/section-41/](scripts/section-41/) |

**Note:** See [CHANGELOG.md](CHANGELOG.md) for detailed progress on each section.

---

## Quick Reference

### How to Use This Index

1. **To find a script by name**: Look up in "Top 50 Popular Scripts" or use script name in file system
2. **To find by category**: Browse "By Category" section and click category link
3. **To search by keywords**: Use "By Keyword Search Patterns" section
4. **To find by port**: Use "By Port-Based Lookup" section
5. **To find by special requirement**: Use "Special Requirements Index" section

### After Finding Script Context

1. Read the script's context file for details
2. If executing, read `execution/` documentation for non-interactive mode
3. If creating new service, read `script-creation/` guides

### When Script Not Found

1. Script may be in development or recently added
2. Run `automation/scan-new-scripts.sh` to check for unmapped scripts
3. Use `script-creation/` guides to create new script if needed

---

## Statistics

- **Total Scripts**: 408
- **Categories**: 26
- **Special Requirement Categories**: 4 (GPU, FUSE, TUN, Nesting)
- **Organized Sections**: 41
- **Context Files Created**: 0/408 (Phase 5 in progress)

---

## Maintenance

- **Update Index**: Run `automation/update-index.sh` when new scripts added
- **Scan for New**: Run `automation/scan-new-scripts.sh` periodically
- **Check Progress**: Review [CHANGELOG.md](CHANGELOG.md) for latest updates
