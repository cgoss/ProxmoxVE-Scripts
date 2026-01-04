# Research Methodology - Service Research Guide

## Overview

This document provides a step-by-step methodology for LLMs to research new services for script creation.

---

## Research Process Flow

```
User Request: "Create a [service]"
    ↓
1. Understand Service Type
    ↓
2. Find Official Documentation
    ↓
3. Analyze Deployment Methods
    ↓
4. Identify Dependencies
    ↓
5. Determine Resource Requirements
    ↓
6. Check Security Considerations
    ↓
7. Document Findings
    ↓
8. Create Scripts (CT + Install)
```

---

## Step 1: Understand Service Type

### Categorize the Service

Before researching, determine which category the service belongs to:

| Category | Typical Services | Key Indicators |
|----------|-----------------|-----------------|
| Database | PostgreSQL, MySQL, MongoDB, Redis | Database queries, storage, ACID compliance |
| Web Application | WordPress, Nextcloud, Drupal | Web server, CMS, PHP/Python/Node.js |
| Media Server | Plex, Jellyfin, Emby | Video transcoding, media library management |
| Monitoring | Grafana, Prometheus, Zabbix | Time-series data, dashboards, alerts |
| Message Queue | Kafka, RabbitMQ, EMQX | Event streaming, pub/sub, brokers |
| Development | GitLab, Gitea, Portainer | Code hosting, CI/CD, version control |
| Backup/Recovery | Rclone, Restic, Duplicati | Encryption, deduplication, cloud storage |
| Security/Auth | Authelia, Vaultwarden, 2FAuth | MFA, SSO, password management |
| Home Automation | Home Assistant, Zigbee2MQTT | IoT protocols, automation |
| AI/ML | ComfyUI, Ollama, Stable Diffusion | GPU, machine learning models |

**Questions to Answer:**
- What does the service do?
- What is its primary use case?
- Does it store data (database, media, files)?
- Does it provide a web interface or CLI only?
- Is it stateful (needs persistence) or stateless?

---

## Step 2: Find Official Documentation

### Primary Sources

1. **Official Website**
   - GitHub repository (most common)
   - Official documentation site
   - README.md in repository

2. **Package Manager Documentation**
   - APT repositories (for Debian/Ubuntu)
   - Alpine packages
   - Docker Hub (for containerized apps)
   - npm packages (for Node.js apps)

3. **Community Resources**
   - Arch Wiki (for general Linux software)
   - Proxmox VE forums
   - Reddit (r/selfhosted, r/homelab)

### Research Checkist

- [ ] Is there a GitHub repository?
- [ ] What is the latest release version?
- [ ] What are the installation instructions?
- [ ] Are there Docker images available?
- [ ] Are there APT repositories/deb822 sources?
- [ ] What ports does the service use?
- [ ] What are the configuration file locations?
- [ ] Are there systemd service files?
- [ ] What are the dependencies (system packages, languages)?
- [ ] What are the recommended system resources?
- [ ] Is there an update mechanism?
- [ ] Are there Alpine-specific instructions?

### Documentation Analysis

**GitHub Repository Analysis:**
```bash
# Check repository structure
gh repo view user/service

# Look for installation documentation
cat README.md | grep -i install

# Check releases
gh release view user/service

# Look for Docker support
# Check if org has Docker Hub org
```

**Docker Hub Analysis:**
```bash
# Check if official Docker image exists
curl -s https://hub.docker.com/v2/repositories/user/service/

# Look at image tags and documentation
curl -s https://hub.docker.com/v2/repositories/user/service/tags/
```

---

## Step 3: Analyze Deployment Methods

### Common Installation Patterns

| Pattern | Description | When to Use |
|----------|-------------|--------------|
| **APT Repository** | Native packages from official APT repo | Debian/Ubuntu native apps |
| **Docker Compose** | Multi-container apps defined in docker-compose.yml | Complex applications |
| **Single Binary** | Compiled executable downloaded from GitHub | Go/Rust/rust/Python tools |
| **Source Build** | Build from source using make/cmake | When no pre-built packages |
| **External Installer** | Third-party installation script (e.g., Kasm) | When official provides installer |
| **Package Manager** | npm/yarn (Node.js), pip (Python) | Language-specific package managers |

### Identifying the Pattern

**Check for Indicators:**

1. **Docker Compose**: Look for `docker-compose.yml` in repository root
2. **Single Binary**: Check for pre-built binaries in releases (linux-amd64)
3. **Source Build**: Look for `Makefile`, `CMakeLists.txt`, configure scripts
4. **External Installer**: Look for `install.sh` or `setup.sh` in repository
5. **APT Repository**: Search for `*.list`, `*.sources` files

---

## Step 4: Identify Dependencies

### System Dependencies

#### Web Applications
**Typical needs:**
- Web server (Nginx, Apache, Caddy, Traefik)
- Runtime (PHP, Python, Node.js, Java, Go, Ruby)
- Database (PostgreSQL, MySQL, MariaDB, SQLite)
- Caching (Redis, Memcached)
- Proxy (optional)

**How to Identify:**
- Check requirements.txt or pyproject.toml (Python)
- Check composer.json or package.json (Node.js)
- Check Gemfile (Ruby)
- Check go.mod (Go)
- Check Dockerfile or docker-compose.yml

#### Database Servers
**Typical needs:**
- Minimal (usually standalone)
- Web interface (optional, often PHP or web-based)
- Backup tools (optional)

**How to Identify:**
- Check official documentation for dependencies
- Look for optional web UI installation
- Check if additional tools (pgAdmin, adminer) are recommended

#### Media Servers
**Typical needs:**
- FFmpeg (video transcoding)
- Media codecs
- GPU acceleration (optional but recommended)
- Database (SQLite or external)

**How to Identify:**
- Check for hardware acceleration recommendations
- Look for GPU requirements
- Check storage requirements (media libraries grow large)

#### AI/ML Tools
**Typical needs:**
- Python with ML frameworks (PyTorch, TensorFlow)
- GPU support (CUDA, ROCm)
- Large RAM for model loading
- Model download capability

**How to Identify:**
- Check for CUDA/ROCm requirements
- Look for model size requirements
- Check if GPU is mandatory or optional

#### Development Tools
**Typical needs:**
- Web server (Nginx, Apache)
- Database (PostgreSQL, MySQL)
- Git repository storage
- Build tools (make, gcc, etc.)

**How to Identify:**
- Check repository storage requirements
- Look for database backend options
- Check if external database is supported

#### Backup/Recovery Tools
**Typical needs:**
- FUSE support (for rclone, mergerfs)
- Cloud provider tools
- Encryption libraries
- Large storage space

**How to Identify:**
- Check for FUSE requirements in documentation
- Look for cloud storage provider SDKs
- Check for deduplication requirements

#### Message Queues
**Typical needs:**
- Java runtime (Kafka, RabbitMQ)
- Minimal dependencies
- Zookeeper (for Kafka clustering)
- Network configuration

**How to Identify:**
- Check Java version requirements
- Look for clustering needs (Zookeeper)
- Check network configuration requirements

### Language Runtime Dependencies

| Language | Typical Dependencies | Setup Commands |
|----------|-------------------|-----------------|
| PHP | PHP-FPM, extensions, Composer | `setup_php`, `setup_composer` |
| Python | Python 3, pip/uv, virtual env | `setup_uv` (recommended) |
| Node.js | Node.js, npm/yarn | No helper (install directly) |
| Go | Go binary (usually compiled) | `setup_go` (if needed) |
| Rust | Cargo (usually compiled) | `setup_rust` (if needed) |
| Java | JRE/JDK, Maven/Gradle | `setup_java` |
| Ruby | Ruby, Bundler | No helper (install directly) |

---

## Step 5: Determine Resource Requirements

### CPU Guidelines by Service Type

| Service Type | Minimum | Recommended | High Performance |
|--------------|---------|------------|-----------------|
| Database (PostgreSQL, MySQL) | 1 | 2 | 4 |
| Web Server (Nginx, Apache) | 1 | 2 | 4 |
| Monitoring (Grafana, Prometheus) | 1 | 2 | 4 |
| Development (GitLab, Gitea) | 2 | 4 | 8 |
| Media Server (Plex, Jellyfin) | 2 | 4 | 8 |
| AI/ML Tools | 4 | 8+ | 16 |
| Message Queue (Kafka) | 2 | 4 | 8 |
| Backup Tools | 1 | 2 | 4 |
| Home Automation | 1 | 2 | 4 |

### RAM Guidelines by Service Type

| Service Type | Minimal | Standard | Large |
|--------------|---------|---------|--------|
| Database (Redis, SQLite) | 512MB | 1GB | 2-4GB |
| Database (PostgreSQL, MySQL, MongoDB) | 1GB | 2-4GB | 8-16GB |
| Web Application | 512MB | 2GB | 4-8GB |
| Media Server | 2GB | 4GB | 8-16GB |
| Monitoring | 512MB | 1GB | 2-4GB |
| Development (GitLab) | 2GB | 4GB | 8GB |
| AI/ML Tools | 4GB | 8GB | 16-32GB |
| Backup Tools | 512MB | 1GB | 2-4GB |

### Disk Guidelines by Service Type

| Service Type | Minimal | Standard | Large |
|--------------|---------|---------|--------|
| Database (SQLite) | 2GB | 4GB | 8GB |
| Database (PostgreSQL, MySQL, MongoDB) | 8GB | 20GB | 50-100GB |
| Web Application | 2GB | 4-8GB | 10-20GB |
| Media Server | 8GB | 20GB | 50-200GB |
| Monitoring | 2GB | 4-8GB | 20-50GB |
| Development | 8GB | 20GB | 50-100GB |
| AI/ML Tools (models) | 10GB | 20GB | 50-200GB |
| Backup Tools | 20GB | 50GB | 100-500GB |

---

## Step 6: Check Security Considerations

### Authentication & Access

**Questions to Research:**
- Does the service have default credentials?
- Can credentials be changed after installation?
- Does it support LDAP/SSO integration?
- Does it require admin account creation?
- Are there default ports that should be changed?

**LLM Action:**
- Document default credentials in JSON metadata
- Include instructions for changing credentials
- Consider exposing ports carefully in documentation

### Data Encryption

**Questions to Research:**
- Does the service support encryption at rest?
- Does it support TLS/SSL for communication?
- Are there encryption key requirements?
- Does it use databases that support encryption?

**LLM Action:**
- Note if TLS/SSL is required or recommended
- Document how to configure certificates
- Consider Alpine vs Debian for OpenSSL compatibility

### Network Security

**Questions to Research:**
- What ports does the service use?
- Does it need inbound firewall rules?
- Does it expose any administrative ports?
- Are there any network security best practices?

**LLM Action:**
- Document required ports in script context
- Note if service should run behind reverse proxy
- Include firewall configuration recommendations if needed

### Container Security

**Considerations:**
- Privileged vs Unprivileged (default to unprivileged)
- Should the service run as root or drop privileges?
- Are there any special capabilities needed (FUSE, TUN)?

**LLM Action:**
- Set var_unprivileged=1 unless service requires privileged mode
- Only use privileged mode when absolutely necessary (Docker, GPU passthrough)
- Document security implications when using privileged mode

---

## Step 7: Document Findings

### Research Documentation Template

Create a structured summary for each service:

```markdown
# [Service Name] Research Summary

## Service Type
- Category: [Category Name]
- Primary Use: [Description]
- Deployment Method: [APT/Docker/Binary/etc.]

## Official Resources
- Website: [URL]
- GitHub: [URL]
- Documentation: [URL]
- Latest Version: [Version]

## Dependencies
### System Packages
- Web server: [Nginx/Apache/etc.]
- Runtime: [PHP/Python/Node.js/etc.]
- Database: [PostgreSQL/MySQL/etc.]

### Language Runtimes
- PHP: [Version]
- Python: [Version]
- Node.js: [Version]

## Resource Requirements
### Recommended Resources
- CPU: [1-2-4 cores]
- RAM: [512MB-1GB-2-4GB-etc.]
- Disk: [2GB-4GB-8GB-etc.]

### Special Requirements
- GPU: [Yes/No]
- FUSE: [Yes/No]
- TUN/TAP: [Yes/No]
- Nesting: [Yes/No]
- Other: [Any special requirements]

## Installation Notes
- Port: [Port number]
- Configuration: [Config file path]
- Data Directory: [Data storage path]
- Service Name: [systemd service name]
- Update Mechanism: [Update script/automatic/manual]

## Security Considerations
- Default Credentials: [user/password]
- TLS/SSL: [Yes/No/requirements]
- Privileged Mode: [Yes/No/recommended]
```

---

## Best Practices for Research

1. **Always use official sources** - GitHub repositories, official docs
2. **Check for existing scripts** - Don't duplicate work
3. **Prefer native packages** - APT over source builds when available
4. **Verify latest versions** - Check GitHub releases, not just documentation
5. **Consider multiple installation methods** - APT, Docker, binary options
6. **Document clearly** - All dependencies, resources, and special requirements
7. **Test installation methods** - Prefer simplest working method
8. **Note security implications** - Privileged containers, exposed ports, default credentials
9. **Consider resource scaling** - How will requirements change over time?
10. **Identify update mechanisms** - Built-in update scripts or manual updates

---

## Research Checklist

For any new service, ensure you've researched:

**Basic Information:**
- [ ] Service purpose and use case
- [ ] Official website and documentation
- [ ] GitHub repository and latest version
- [ ] Deployment method (APT/Docker/Binary/Source)

**Dependencies:**
- [ ] System packages required
- [ ] Language runtimes required
- [ ] Database requirements
- [ ] Optional dependencies (caching, proxy, etc.)

**Resources:**
- [ ] Recommended CPU cores
- [ ] Recommended RAM allocation
- [ ] Recommended disk size
- [ ] Special hardware requirements (GPU, FUSE, TUN)

**Configuration:**
- [ ] Default port(s)
- [ ] Configuration file location
- [ ] Data directory location
- [ ] Service name for systemd

**Security:**
- [ ] Default credentials
- [ ] TLS/SSL requirements
- [ ] Authentication options
- [ ] Container security requirements (privileged/unprivileged)

**Installation:**
- [ ] Installation commands
- [ ] Service configuration steps
- [ ] Update mechanism availability

---

## Next Steps

1. **Use this research** to create CT and install scripts
2. **See `dependency-analysis.md`** for detailed dependency patterns
3. **See `resource-planning.md`** for resource guidelines
4. **See `installation-patterns.md`** for implementation patterns
5. **See `template-guide.md`** for script structure
6. **See `os-selection.md`** for choosing base OS
