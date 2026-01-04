# Resource Planning - CPU, RAM, Disk Guidelines

## Overview

This document provides generic guidelines for determining appropriate resource allocations (CPU, RAM, disk) for services.

---

## CPU Allocation Guidelines

### CPU Requirements by Service Type

| Service Type | Minimal | Standard | High Performance |
|--------------|---------|----------|-------------------|
| **Databases** | 1 core | 2 cores | 4 cores |
| **Web Applications** | 1 core | 2 cores | 4 cores |
| **Media Servers** | 2 cores | 4 cores | 6-8 cores |
| **Monitoring Tools** | 1 core | 2 cores | 4 cores |
| **Development Tools** | 2 cores | 4 cores | 6-8 cores |
| **AI/ML Tools** | 2-4 cores | 4-8 cores | 8+ cores |
| **Backup/Recovery** | 1 core | 2 cores | 4 cores |
| **Message Queues** | 2 cores | 4 cores | 6-8 cores |
| **VPN/Tunneling** | 1 core | 2 cores | 4 cores |

### CPU Considerations

**When to Allocate More:**
- **Video Transcoding**: Media servers (Plex, Jellyfin) need 2-4 cores for 1080p
- **AI/ML Inference**: GPU-accelerated AI tools need 2-4 cores alongside GPU
- **Large Databases**: MongoDB with large datasets needs 4+ cores
- **High-Traffic Web**: Nginx reverse proxy handling many connections
- **Development**: IDEs, build tools benefit from 4+ cores

**When to Allocate Minimal:**
- **Lightweight Databases**: Redis, SQLite only need 1 core
- **Simple Web Apps**: Static sites, basic APIs
- **Monitoring Agents**: Node exporters, lightweight dashboards
- **Small Tools**: rclone, file browsers

---

## RAM Allocation Guidelines

### RAM Requirements by Service Type

| Service Type | Minimal | Standard | Large | Very Large |
|--------------|---------|----------|--------|-----------|
| **Databases** | 512MB | 1-2GB | 2-4GB | 4-8GB |
| **Web Applications** | 512MB | 1-2GB | 2-4GB | 4-8GB |
| **Media Servers** | 1GB | 2-4GB | 4-8GB | 8-16GB |
| **Monitoring Tools** | 512MB | 1-2GB | 2-4GB | 4-8GB |
| **AI/ML Tools** | 2GB | 4-8GB | 8-16GB | 16-32GB |
| **Development Tools** | 1GB | 2-4GB | 4-8GB | 8-16GB |
| **Backup/Recovery** | 512MB | 1-2GB | 2-4GB | 4-8GB |
| **Message Queues** | 1GB | 2-4GB | 4-8GB | 8-16GB |

### RAM Considerations

**When to Allocate More:**
- **Video Transcoding**: Media servers need 2GB+ for 4K transcoding
- **Large Datasets**: PostgreSQL with large tables, MongoDB with big data
- **AI/ML Models**: Loading large models requires significant RAM
- **Caching**: Redis, Memcached benefit from more RAM
- **Development**: IDEs, browsers benefit from more RAM

**When to Allocate Minimal:**
- **Lightweight Databases**: SQLite, Redis (small datasets) use 512MB
- **Simple Web Apps**: Static sites, APIs, CLI tools
- **Monitoring Agents**: Most exporters are lightweight (512MB-1GB)
- **Alpine Containers**: Alpine services use less RAM naturally

**Memory Overhead Considerations:**
- **OS Baseline**: Debian/Ubuntu require ~400MB base, Alpine requires ~200MB
- **Web Server**: Nginx needs ~100-200MB for connections
- **Database**: PostgreSQL needs ~200-400MB base
- **Application Overhead**: Account for application requirements on top of OS

---

## Disk Allocation Guidelines

### Disk Requirements by Service Type

| Service Type | Minimal | Standard | Large | Very Large |
|--------------|---------|----------|--------|-----------|
| **Databases** | 2GB | 4-8GB | 20-50GB | 100-500GB |
| **Web Applications** | 2GB | 4-8GB | 10-20GB | 20-50GB |
| **Media Servers** | 8GB | 20-50GB | 50-200GB | 200GB+ |
| **Monitoring Tools** | 2GB | 4-8GB | 10-20GB | 20-50GB |
| **Development Tools** | 4GB | 8-20GB | 20-50GB | 50-100GB |
| **AI/ML Tools** | 10GB | 20-50GB | 50-100GB | 100GB+ |
| **Backup/Recovery** | 10GB | 20-50GB | 50-200GB | 200GB+ |

### Disk Considerations

**When to Allocate More:**
- **Media Libraries**: Growing collections (Plex, Jellyfin) need 50-200GB+
- **Large Databases**: MongoDB, PostgreSQL with growth history
- **Backup Storage**: Restic, Duplicati, BorgBackup need significant space
- **AI Models**: Downloaded models can be 10-50GB each
- **Docker Images**: Many Docker images require significant storage

**When to Allocate Minimal:**
- **Databases**: SQLite only needs 2GB
- **Simple Web Apps**: Static sites, APIs, CLI tools
- **Monitoring**: Data retention policies affect size
- **Alpine Containers**: Minimal base system images

**Growth Planning:**
- **Annual Growth Rate**: Plan for 10-50% annual data growth for databases
- **Media Collection**: Account for new movies/shows, seasons over time
- **Backup Retention**: 7-day, 30-day, or infinite retention policies
- **Log Rotation**: Database logs, application logs grow over time

**Storage Type Considerations:**
- **SSD**: Recommended for databases (better IOPS), web servers
- **HDD**: Acceptable for media libraries (cost-effective bulk storage)
- **NFS**: Consider network latency, not recommended for primary databases
- **ZFS/BTRFS**: Consider for snapshots, compression (adds overhead)

---

## Combined Resource Recommendations

### Database Servers

| Service | CPU | RAM | Disk | Reason |
|----------|-----|------|-------|---------|
| **PostgreSQL** | 1-2 | 1-2GB | 4-8GB | Small to medium workloads |
| **MySQL/MariaDB** | 1-2 | 1-2GB | 8-20GB | General purpose, growth potential |
| **MongoDB** | 2 | 2-4GB | 20-50GB | Document storage, larger indexes |
| **Redis** | 1 | 512MB-1GB | 2-4GB | Caching, data in memory |

### Media Servers

| Service | CPU | RAM | Disk | Reason |
|----------|-----|------|-------|---------|
| **Plex** | 2-4 | 2-4GB | 20-50GB | Transcoding needs CPU, storage grows |
| **Jellyfin** | 2-4 | 2-4GB | 20-50GB | Transcoding needs CPU, storage grows |
| **Emby** | 2-4 | 2-4GB | 20-50GB | Similar to Plex/Jellyfin |
| **Immich** | 2-4 | 4-8GB | 50-200GB | Photo storage, needs more RAM |
| **Jellyseerr** | 2-4 | 2-4GB | 20-50GB | Movies management |

### Web Applications

| Service | CPU | RAM | Disk | Reason |
|----------|-----|------|-------|---------|
| **Nginx** | 1-2 | 512MB-2GB | 4-8GB | Static serving needs minimal |
| **Apache** | 1-2 | 1-2GB | 4-8GB | Dynamic content needs more |
| **Caddy** | 1 | 512MB-1GB | 2-4GB | Simple sites, HTTPS built-in |

### Development Tools

| Service | CPU | RAM | Disk | Reason |
|----------|-----|------|-------|---------|
| **GitLab** | 2-4 | 4-8GB | 20-50GB | Repository storage grows |
| **Gitea** | 2 | 2-4GB | 10-20GB | Lightweight alternative |
| **Portainer** | 1 | 512MB-1GB | 4-8GB | Docker images minimal |

---

## OS-Specific Considerations

### Debian/Ubuntu Containers

**Base Memory Overhead**: ~400MB
**Package Sizes**: Larger due to glibc
**Recommended**: Full-featured applications

### Alpine Containers

**Base Memory Overhead**: ~200MB
**Package Sizes**: Smaller due to musl libc
**Recommended**: Simple applications, resource-constrained services

**Resource Reduction for Alpine:**
- **CPU**: Can often reduce by 1 core vs Debian
- **RAM**: Can often reduce by 50% vs Debian
- **Disk**: Can often reduce by 50% vs Debian

---

## Scaling Recommendations

### Vertical Scaling

**When service needs more power:**
1. Increase CPU cores (within same container)
2. Add more RAM (within same container)
3. Increase disk size (may need to migrate storage)

**Limitations:**
- Container has maximum resource limits
- Single container max: depends on Proxmox host resources
- LXC nesting doesn't allow GPU passthrough in some configurations

### Horizontal Scaling

**When single container isn't enough:**
1. Deploy multiple instances (e.g., 3 database replicas)
2. Use load balancers (Traefik, HAProxy, Nginx)
3. Cluster message queues (Kafka, RabbitMQ)
4. Sharding for databases (MongoDB, Cassandra)

**Example: MongoDB Sharding**
```
3 MongoDB instances, each:
- 2 CPUs, 4GB RAM, 20GB disk
- Combined: 6 CPUs, 12GB RAM, 60GB disk
- Horizontal scaling via sharding
```

---

## Optimization Strategies

### For CPU

**Reduce Requirements:**
- Use lightweight alternatives (SQLite vs PostgreSQL)
- Enable query caching (Redis for databases)
- Optimize application configuration
- Use connection pooling

### For RAM

**Reduce Requirements:**
- Use Alpine when possible (saves 50% RAM)
- Limit concurrent connections
- Enable memory limits in application config
- Use caching layers (Redis, Memcached)

### For Disk

**Optimize Storage:**
- Use data compression (ZSTD, LZ4)
- Implement log rotation
- Clean up temporary files regularly
- Use database backups instead of full snapshots
- Deduplication for backup tools (Restic, Borg)

---

## Resource Monitoring

### Commands to Check Usage

```bash
# Container resource usage
pct exec <ctid> top
pct exec <ctid> htop

# Disk usage
pct exec <ctid> df -h
pct exec <ctid> du -sh /path/to/data | sort -rh | head -10

# Memory usage
pct exec <ctid> free -h

# Process list
pct exec <ctid> ps aux
```

### Warning Indicators

**CPU High**: >80% for sustained periods
**RAM High**: >90% sustained, >95% during spikes
**Disk Full**: >90% usage, less than 1GB free
**Swap Usage**: High swap usage indicates RAM exhaustion

---

## Best Practices

1. **Start with minimal resources** - Can always scale up later
2. **Monitor initial usage** - First 7-14 days tell true requirements
3. **Plan for growth** - Databases, media, backups always grow
4. **Consider application-specific needs** - Some services are more resource-hungry
5. **Use Alpine for simple services** - Save 50% RAM
6. **Separate concerns** - Use different containers for app vs database
7. **Document requirements** - Keep record of why resources were chosen
8. **Review periodically** - Adjust resources based on actual usage
9. **Set limits** - Prevent one container from consuming all resources
10. **Test with workloads** - Verify resources handle peak loads

---

## Next Steps

1. **Use service type** to determine starting point
2. **Adjust based on use case** - Development vs production
3. **Consider Alpine** for resource-constrained environments
4. **Plan for growth** - Databases and media always expand
5. **Monitor and adjust** - Don't set and forget resources
6. **Document decisions** - Keep record for future reference
