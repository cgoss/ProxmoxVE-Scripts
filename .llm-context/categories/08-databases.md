# 08 Databases

## Category Information

**Category ID**: 8
**Number of Scripts**: 16

## Description

This category includes scripts for Ubuntu, Alpine, Debian and related services.

## Scripts in This Category (16 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Apache-Cassandra](https://cassandra.apache.org/) | `apache-cassandra` | N/A | 1 | 2048 MB | 4 GB | Debian 12 |  |
| [Apache-CouchDB](https://couchdb.apache.org/) | `apache-couchdb` | 5984 | 2 | 4096 MB | 10 GB | Debian 12 |  |
| [Garage](https://garagehq.deuxfleurs.fr/) | `garage` | 3900 | 1 | 1024 MB | 5 GB | Debian 13 |  |
| [InfluxDB](https://www.influxdata.com/) | `influxdb` | 8086 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [Mariadb](https://mariadb.org/) | `mariadb` | 3306 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Meilisearch](https://www.meilisearch.com/) | `meilisearch` | 7700 | 2 | 4096 MB | 7 GB | Debian 13 |  |
| [MinIO](https://min.io/) | `minio` | 9001 | 1 | 1024 MB | 5 GB | Debian 13 |  |
| [MongoDB](https://www.mongodb.com/) | `mongodb` | 27017 | 1 | 512 MB | 4 GB | Debian 13 |  |
| [Neo4j](https://neo4j.com/product/neo4j-graph-database/) | `neo4j` | 7474 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [PhpMyAdmin](https://www.phpmyadmin.net/) | `phpmyadmin` | N/A | None | None | None GB | N/A |  |
| [Pocketbase](https://pocketbase.io/) | `pocketbase` | N/A | 1 | 512 MB | 8 GB | Debian 13 |  |
| [PostgreSQL](https://www.postgresql.org/) | `postgresql` | 5432 | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Qdrant](https://qdrant.tech/) | `qdrant` | 6333 | 1 | 1024 MB | 5 GB | Debian 13 |  |
| [Redis ](https://redis.io/) | `redis` | N/A | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [SQL Server 2022](https://www.microsoft.com/en-us/sql-server/sql-server-2022) | `sqlserver2022` | 1433 | 1 | 2048 MB | 10 GB | Ubuntu 22.04 | ✓ |
| [VictoriaMetrics](https://victoriametrics.com/) | `victoriametrics` | 8428 | 2 | 2048 MB | 16 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 2 | 1 |
| RAM | 256 MB | 4096 MB | 2176 MB |
| Disk | 1 GB | 16 GB | 8 GB |

**Supported Operating Systems:**
- Ubuntu
- Alpine
- Debian

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 1433**: Default interface port for many scripts
- **Port 3306**: Default interface port for many scripts
- **Port 3900**: Default interface port for many scripts
- **Port 5432**: Default interface port for many scripts
- **Port 5984**: Default interface port for many scripts

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
