# Grafana Context

## Basic Information

- **Name**: Grafana
- **Slug**: grafana
- **Categories**: 9

## Description

Grafana is a data visualization and monitoring platform that enables users to query, visualize, alert on and understand metrics, logs, and other data sources. It integrates with various data sources, including Prometheus, InfluxDB, Elasticsearch, and many others, to present a unified view of the dat

## Resources by Install Method

### Default Install
- **CPU**: 1 cores
- **RAM**: 512 MB (0 GB)
- **Disk**: 2 GB
- **OS**: Debian 13
- **Privileged**: true
- **Updateable**: Yes

### Alpine Install
- **CPU**: 1 core (typical for Alpine)
- **RAM**: 512 MB (256 MB = 0 GB) - Alpine typically uses ~50% less RAM
- **Disk**: 2 GB (typical for Alpine)
- **OS**: Alpine 13
- **Privileged**: true
- **Updateable**: Yes

## Access Information

- **Interface Port**: 3000
- **Web URL**: https://grafana.com/
- **Documentation**: https://grafana.com/docs/grafana/latest/
- **Configuration Path**: Debian: /etc/grafana/grafana.ini | Alpine: /etc/grafana.ini

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
