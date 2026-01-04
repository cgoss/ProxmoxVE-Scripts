# Dependency Analysis - Finding and Analyzing Dependencies

## Overview

This document provides generic patterns for identifying and analyzing service dependencies without referencing specific services.

---

## Dependency Categories

### 1. Web Server Dependencies

**Common Patterns:**
- **Nginx**: Static file serving, reverse proxy, load balancer
- **Apache**: Dynamic content, .htaccess support, PHP integration
- **Caddy**: Automatic HTTPS, modern configuration
- **Traefik**: Cloud-native reverse proxy, auto-discovery

**Indicators Service Needs:**
- Web interface required
- Serves HTTP/HTTPS
- Needs SSL/TLS support

**Typical Dependencies:**
```bash
# For Nginx-based services
nginx
libnginx-mod-http-*  # Additional modules

# For Apache-based services
apache2
libapache2-mod-php*
libapache2-mod-ssl

# For Caddy-based services
caddy

# For Traefik-based services
traefik
```

---

### 2. Database Dependencies

**Relational Databases (SQL):**
- **PostgreSQL**: ACID-compliant, JSON support, advanced features
- **MySQL/MariaDB**: Most widely used, WordPress compatibility
- **SQLite**: Lightweight, embedded use

**NoSQL Databases:**
- **MongoDB**: Document-oriented, JSON native
- **Redis**: Key-value store, caching, pub/sub
- **InfluxDB**: Time-series data, monitoring

**Indicators Service Needs:**
- Stores structured data
- Uses database queries
- May require web UI (phpMyAdmin, etc.)

**Helper Functions:**
```bash
# Use ProxmoxVE helper functions
setup_postgresql    # PostgreSQL
setup_mariadb       # MariaDB
setup_mysql         # MySQL
setup_mongodb        # MongoDB
setup_redis          # Redis
setup_influxdb      # InfluxDB
```

**Typical Installation:**
```bash
# PostgreSQL
PG_VERSION=16 setup_postgresql

# MariaDB
setup_mariadb

# MongoDB
setup_mongodb

# Redis
setup_redis
```

---

### 3. Language Runtime Dependencies

**Python Applications:**
- **Indicators**: .py files, requirements.txt, pyproject.toml
- **Versions**: Python 3.10+, 3.11+, 3.12+
- **Package Managers**: pip, poetry, uv (recommended)
- **Framework Requirements**: Django, Flask, FastAPI

**Helper Functions:**
```bash
setup_uv            # Recommended modern Python setup
# Or traditional:
apt-get install -y python3 python3-pip
```

**Node.js Applications:**
- **Indicators**: package.json, npm scripts
- **Versions**: Node.js 18 LTS, 20, 22
- **Package Managers**: npm, yarn, pnpm
- **Framework Requirements**: Express, React, Next.js, NestJS

**Helper Functions:**
```bash
setup_nodejs  # Install Node.js 18 and 20
# No specific helper for npm/yarn
curl -fsSL https://nodejs.org/setup_20.x | bash
```

**PHP Applications:**
- **Indicators**: composer.json, .php files
- **Versions**: PHP 8.1, 8.2, 8.3
- **Frameworks**: Laravel, WordPress, Drupal
- **Helper Functions**: `setup_php`, `setup_composer`

**Go Applications:**
- **Indicators**: go.mod, go.sum, main.go
- **Versions**: Go 1.20+, 1.21+
- **Helper Functions**: `setup_go` (if not in base repo)

**Rust Applications:**
- **Indicators**: Cargo.toml, main.rs
- **Versions**: Rust 1.70+
- **Helper Functions**: `setup_rust` (if not in base repo)

**Java Applications:**
- **Indicators**: pom.xml, .jar files
- **Versions**: JDK 17, 21
- **Helper Functions**: `setup_java`

---

### 4. Media Processing Dependencies

**Video Transcoding:**
- **FFmpeg**: Core transcoding engine
- **Indicators**: Media servers, video processing
- **GPU Acceleration**: CUDA for NVIDIA, ROCm for AMD

**Helper Functions:**
```bash
# FFmpeg is often pre-installed or needs install
apt-get install -y ffmpeg

# For GPU-accelerated transcoding
var_gpu=yes  # CT script variable
```

**Media Codecs:**
- **Indicators**: Support for h.264, h.265, VP9, AV1
- **Typical Dependencies**: libavcodec-extra, intel-media-va-driver

---

### 5. Containerization Dependencies

**Docker Support:**
- **Indicators**: Dockerfile, docker-compose.yml, container registry
- **Nesting Required**: LXC nesting (var_nesting=1)
- **Helper Function**: `setup_docker`

**Docker Compose:**
- **Indicators**: docker-compose.yml, multiple services
- **Typical Use**: Multi-tier applications (web + database + cache)

**Helper Functions:**
```bash
setup_docker       # Install Docker Engine

# Then create docker-compose.yml in install script
```

---

### 6. Monitoring & Analytics Dependencies

**Time-Series Databases:**
- **InfluxDB**: For metrics storage
- **Prometheus**: For metrics collection
- **VictoriaMetrics**: Alternative to Prometheus

**Visualization Tools:**
- **Grafana**: Dashboards, alerting
- **Kibana**: For Elasticsearch stack
- **Chronograf**: For InfluxDB stack

**Alerting:**
- **AlertManager**: For Prometheus
- **Uptime Kuma**: For uptime monitoring

---

### 7. Caching Dependencies

**In-Memory Caches:**
- **Redis**: Most common, pub/sub, data structures
- **Memcached**: Simple key-value store, older
- **KeyDB**: Advanced Redis alternative

**CDN/Proxy Caching:**
- **Cloudflare**: DNS-only, web acceleration
- **Fastly**: Full CDN, image optimization

---

### 8. Networking & Proxy Dependencies

**Reverse Proxies:**
- **Nginx**: Simple, high performance
- **Traefik**: Cloud-native, auto-config, TLS automation
- **Caddy**: Automatic HTTPS, modern
- **HAProxy**: Advanced load balancing, high availability

**VPN/Tunneling:**
- **WireGuard**: Modern, fast, kernel module
- **OpenVPN**: Widely supported, many clients
- **Tailscale**: WireGuard-based, NAT traversal
- **ZeroTier**: SD-WAN, mesh networking

---

### 9. Backup & Recovery Dependencies

**Backup Tools:**
- **Rclone**: Multi-cloud support, sync
- **Restic**: Deduplication, encryption
- **Duplicati**: Fast, client-side encryption
- **Borg**: Deduplication, compression

**Backup Destinations:**
- **Cloud**: AWS S3, Backblaze, Wasabi
- **Local**: Additional storage, NAS
- **Network**: SMB, NFS, SSH

**Helper Functions:**
```bash
# FUSE support required for rclone
var_fuse=yes
```

---

### 10. Security & Authentication Dependencies

**2FA/MFA:**
- **Authelia**: 2FA for web services
- **2FAuth**: Google Authenticator, OIDC
- **Bitwarden**: Password manager with 2FA

**Single Sign-On (SSO):**
- **Authentik**: Open-source SSO provider
- **Keycloak**: Identity and access management

---

### 11. Message Queues & Messaging

**Message Brokers:**
- **Kafka**: Distributed streaming platform
- **RabbitMQ**: Traditional, flexible routing
- **EMQX**: MQTT broker (also supports WebSockets)
- **NATS**: Lightweight, high performance

**Dependencies:**
```bash
# Java for Kafka/RabbitMQ
apt-get install -y openjdk-17-jre

# Zookeeper for Kafka clustering (often needed)
apt-get install -y zookeeperd
```

---

### 12. IoT & Home Automation Dependencies

**Protocols:**
- **MQTT**: Message queue for IoT
- **Zigbee**: Device communication
- **Z-Wave**: Alternative device protocol
- **Matter**: Unified protocol

**Bridges:**
- **Zigbee2MQTT**: Zigbee to MQTT bridge
- **Home Assistant**: Central hub, integrates everything

---

### 13. Development & CI/CD Dependencies

**Version Control:**
- **Git**: Essential, widely used
- **Mercurial**: Alternative

**CI/CD:**
- **GitLab Runner**: Self-hosted CI/CD
- **Gitea**: Lightweight, self-hosted
- **Woodpecker**: Docker-based CI/CD

**Package Registries:**
- **Docker Hub**: Default registry
- **GHCR**: GitHub Container Registry
- **Harbor**: Private registry

---

## Identifying Dependencies

### Method 1: Documentation Review

**What to Look For:**
- Requirements sections in README
- Installation guides
- Configuration documentation
- Dockerfiles (if containerized)
- composer.json / package.json (for language apps)

**LLM Action:**
```bash
# Check official documentation
gh repo view user/service

# Look for requirements sections
cat README.md | grep -i "requirement"
```

### Method 2: Source Code Analysis

**What to Look For:**
- Imports in main application files
- Dockerfile or docker-compose.yml
- Requirements.txt or pyproject.toml
- Package manager configuration files

**LLM Action:**
```bash
# Clone repository (if public)
gh repo clone user/service

# Or check specific files
curl -s https://raw.githubusercontent.com/user/service/main/package.json
curl -s https://raw.githubusercontent.com/user/service/main/requirements.txt
```

### Method 3: Docker Hub Images

**What to Look For:**
- Official Docker images
- Image tags and versions
- Layer details (docker inspect)

**LLM Action:**
```bash
# Get image information
docker pull user/service
docker inspect user/service

# Check layers and dependencies
docker history user/service
```

### Method 4: Running Examples

**What to Look For:**
- docker-compose.yml examples
- Environment variable documentation
- Common patterns from community

**LLM Action:**
```bash
# Search for examples
gh search "user/service docker-compose" --filename:docker-compose.yml

# Check community forums and discussions
```

---

## Dependency Installation Patterns

### Pattern 1: APT Repository (Native)

**When to Use:**
- Service provides APT repository
- Packages available in Debian/Ubuntu repos
- Most common for server-type applications

**Implementation:**
```bash
# Add APT repository
echo "deb [signed-by=/path/to/key.gpg] http://repo.example.com/debian stable main" > /etc/apt/sources.list.d/service.list

# Update and install
$STD apt-get update
$STD apt-get install -y service-package
```

### Pattern 2: GitHub Release Binary

**When to Use:**
- Official GitHub releases provide compiled binaries
- No compilation required
- Simple installation

**Implementation:**
```bash
# Get latest version
LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/user/service/releases/latest | grep '"tag_name":' | cut -d'"' -f4)

# Download binary
curl -fsSL "https://github.com/user/service/releases/download/${LATEST_RELEASE}/service-linux-amd64" -o /usr/local/bin/service

# Make executable
chmod +x /usr/local/bin/service

# Verify version
/usr/local/bin/service --version
```

### Pattern 3: Docker Compose

**When to Use:**
- Multi-tier applications
- Service defines docker-compose.yml
- Multiple services (app, database, cache, etc.)

**Implementation:**
```bash
# Install Docker Compose
setup_docker  # Uses helper function
$STD apt-get install -y docker-compose-plugin

# Copy docker-compose.yml
mkdir -p /opt/service
cp docker-compose.yml /opt/service/docker-compose.yml

# Run Docker Compose
docker-compose -f /opt/service/docker-compose.yml up -d
```

### Pattern 4: Source Build

**When to Use:**
- No pre-compiled binary available
- Source code available
- Requires compilation tools

**Implementation:**
```bash
# Install build dependencies
$STD apt-get install -y build-essential git

# Clone and build
cd /opt
git clone https://github.com/user/service.git
cd service
make
make install

# Or for Python with pip:
$STD apt-get install -y python3-pip build-essential
pip3 install /opt/service
```

---

## Common Dependency Conflicts

### Port Conflicts
**Check ports before installation:**
- 80/443: Web servers (Nginx, Apache, Caddy)
- 5432: PostgreSQL
- 3306: MySQL/MariaDB
- 6379: Redis
- 27017: MongoDB
- 9200: Grafana
- 3000: Common Node.js apps

**LLM Action:**
```bash
# Check if port is in use
netstat -tulpn | grep :PORT

# Warn user before installation
echo "Port 5432 is already in use. This may conflict with PostgreSQL installation."
```

### Database Conflicts

**Consider:**
- Multiple databases on same container (unnecessary)
- Database version compatibility
- Backup requirements

---

## Best Practices

1. **Use helper functions** - Always prefer `setup_postgresql` over manual install
2. **Check for existing installations** - Don't install duplicate services
3. **Use package managers** - npm, pip, poetry over manual installations
4. **Pin versions** - Use specific versions in requirements.txt when stability is critical
5. **Document alternatives** - If primary tool isn't available, provide backup options
6. **Consider dependencies** - Web servers need runtimes, apps need databases
7. **Test in isolation** - Install service alone first, verify before adding complexity
8. **Check Alpine compatibility** - Alpine uses musl libc, some packages may have issues
9. **Use official sources** - Prefer APT repos over random PPAs
10. **Document all dependencies** - Even optional ones, so users understand requirements

---

## Next Steps

1. **Research service thoroughly** using methods in this document
2. **Analyze all dependency categories** - server, runtime, database, etc.
3. **Check ProxmoxVE helper functions** - Use available helpers before manual installation
4. **Document complete dependency tree** - Include versions, purposes
5. **Test installation patterns** - Choose APT vs Docker vs Binary
6. **Note resource implications** - Dependencies affect CPU/RAM requirements
7. **Consider update mechanisms** - How will updates be handled?
8. **See `installation-patterns.md`** For implementation patterns
