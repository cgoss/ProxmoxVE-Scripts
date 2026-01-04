# Storage Selection - Storage Drive Selection Handling

## Overview

This document explains how LLMs should handle storage drive selection when creating ProxmoxVE containers.

---

## Why Storage Selection is Important

Many ProxmoxVE deployments have multiple storage drives:
- **local** - Default LVM thin storage (fast, on SSD)
- **local-lvm** - LVM storage (large capacity)
- **nas** - NFS-mounted storage (network storage)
- **external** - External storage via USB or other connections

**Critical for LLMs:** User must choose which storage to use because it cannot be auto-selected in non-interactive mode.

---

## Checking Available Storage

### Method 1: pvesm Command (Recommended)

```bash
pvesm status

# Example output:
# storageid: type (total/used/avail)
# local: lvmthin (500G/50G/450G)
# local-lvm: lvm (1T/300G/700G)
# nas: nfs (5T/2T/3T)
```

**Columns:**
- **storageid**: Storage identifier (use this for var_storage)
- **type**: Storage technology (lvmthin, lvm, nfs, etc.)
- **total**: Total capacity
- **used**: Current usage
- **avail**: Available free space

**LLM Usage:**
```bash
# Get storage list
STORAGE_INFO=$(pvesm status)

# Parse and present to user
# Extract storageid and avail space
```

### Method 2: qm Command

```bash
qm config <vmid> | grep rootfs

# Output example:
# rootfs: local-lvm:vm-100-disk-0,size=20G
```

**LLM Usage:** Check what storage similar containers are using.

---

## Presenting Storage Options to User

### Format 1: Simple List (Recommended)

```
Available storage drives:

1. local (450GB free) - Default LVM thin storage (SSD)
2. local-lvm (700GB free) - LVM storage (HDD)
3. nas (3TB free) - NFS-mounted network storage

Which storage drive would you like to use? [1/2/3]:
```

### Format 2: With Recommendations

```
Available storage drives:

1. local (450GB free) - Default LVM thin storage [RECOMMENDED for performance]
2. local-lvm (700GB free) - LVM storage
3. nas (3TB free) - NFS-mounted network storage [Use for large media libraries]

Which storage drive would you like to use? [1/2/3]:
```

### Format 3: With Detailed Info

```
Available storage drives:

1. local (450GB free / 500GB total)
   - Type: LVM thin (SSD)
   - Speed: Fast
   - Recommended for: Applications, databases

2. local-lvm (700GB free / 1TB total)
   - Type: LVM (HDD)
   - Speed: Moderate
   - Recommended for: Media, backups, bulk storage

3. nas (3TB free / 5TB total)
   - Type: NFS (Network)
   - Speed: Slower (depends on network)
   - Recommended for: Media libraries, large databases, backups

Which storage drive would you like to use? [1/2/3]:
```

---

## Storage Selection by Use Case

### Databases
**Recommended:**
- **local** (fastest) or **local-lvm** (good balance)
- **Avoid:** NFS-mounted storage (slow, can cause database corruption)

**Example Question:**
```
For PostgreSQL database performance, which storage should I use?

1. local (450GB free) - Fast SSD [RECOMMENDED]
2. local-lvm (700GB free) - HDD storage

Which storage drive would you like to use? [1/2]:
```

### Media Servers (Plex, Jellyfin, Immich)

**Recommended:**
- **local-lvm** or **nas** (large capacity)
- **Avoid:** local (limited space for large media libraries)

**Example Question:**
```
For media library storage, which storage should I use?

1. local (450GB free) - Limited space, fast
2. local-lvm (700GB free) - Moderate space, good balance [RECOMMENDED]
3. nas (3TB free) - Large capacity, network storage

Which storage drive would you like to use? [1/2/3]:
```

### Backup Servers (Rclone, Restic, Duplicati)

**Recommended:**
- **nas** (network storage)
- **Avoid:** local (insufficient space for backups)

**Example Question:**
```
For backup storage, which storage should I use?

1. local (450GB free) - Insufficient space
2. local-lvm (700GB free) - Moderate capacity
3. nas (3TB free) - Large capacity [RECOMMENDED for backups]

Which storage drive would you like to use? [1/2/3]:
```

### Development/Testing

**Recommended:**
- **local** (fast, resets easily)

**Example Question:**
```
Which storage drive should I use for development container?

1. local (450GB free) - Fast, easy to reset [RECOMMENDED]
2. local-lvm (700GB free) - Good capacity
3. nas (3TB free) - Network storage

Which storage drive would you like to use? [1/2/3]:
```

---

## Handling User Responses

### User Provides Number

```bash
# User enters: 2
var_storage=local-lvm
```

### User Provides Storage Name

```bash
# User enters: nas
var_storage=nas
```

### User Asks for Recommendation

```
User: "I'm not sure, what do you recommend?"

LLM: "Based on your use case of [database], I recommend using local storage for best performance. It has 450GB free space.

Would you like to use local storage? [Y/n]:

User: "Yes"

var_storage=local
```

---

## Common Storage Issues and Solutions

### Issue 1: Insufficient Space

**Symptom:** User selects storage with < required disk size

**Solution:**
```
Storage drive selected has 5GB free, but script requires 20GB.

Available options:
1. local (450GB free)
2. local-lvm (700GB free) [SUFFICIENT]
3. nas (3TB free)

Please choose a storage with sufficient space [1/2/3]:
```

### Issue 2: Storage Not Found

**Symptom:** User provides storage name that doesn't exist

**Solution:**
```
Storage drive "backup-store" not found.

Available storage drives:
1. local
2. local-lvm
3. nas

Please select from available drives [1/2/3]:
```

### Issue 3: NFS Storage Slow/Unreachable

**Symptom:** User selects nas but container creation is slow or fails

**Solution:**
```bash
# Check NFS connection
showmount -e

# Or test connectivity
ping -c 3 <nas-ip-address>

If NFS is unavailable, ask user to choose different storage:

"NAS storage appears to be slow or unreachable. Would you like to:
1. Retry with NAS
2. Use local storage instead [RECOMMENDED for reliability]

Choose option [1/2]:
```

---

## Storage-Specific Environment Variable

### var_storage

**Description:** Storage drive/ID for container
**Type:** String
**Default:** System default (auto-selects first available)
**Setting Method:**
```bash
var_storage=local-lvm
var_storage=nas
```

**Finding Values:**
```bash
# Run pvesm status
# Match storageid column to user choice
```

---

## Advanced Mode: Full Storage Configuration

When user selects Advanced mode, ask complete storage questions:

```
Advanced Storage Configuration:

1. Storage Drive: [storageid]
   - Which Proxmox storage to use

2. Disk Size: [GB]
   - Size of container disk

3. Disk Thinning: [yes/no]
   - For LVM thin provisioning (only applies to local-lvm)

Example for PostgreSQL database:

1. Storage Drive: local-lvm
2. Disk Size: 50
3. Disk Thinning: no

[Review these settings? Y/n]:
```

---

## Storage Recommendations by Script Type

### Database Scripts

| Script | Recommended Storage | Reason |
|--------|-------------------|---------|
| PostgreSQL, MariaDB, MySQL | local (SSD) | Best performance, prevents corruption |
| MongoDB | local or local-lvm | Large write operations |
| Redis | local | Fast random access |

### Media Scripts

| Script | Recommended Storage | Reason |
|--------|-------------------|---------|
| Plex, Jellyfin, Emby | local-lvm or nas | Large capacity needed |
| Immich | nas | Massive photo storage |
| *Arr Suite | local-lvm or nas | Media libraries grow large |

### Backup Scripts

| Script | Recommended Storage | Reason |
|--------|-------------------|---------|
| Rclone, Restic | nas | Network storage for backups |
| Duplicati | nas | Large backup history |
| Syncthing | nas or local-lvm | Sync across devices |

### AI/ML Scripts

| Script | Recommended Storage | Reason |
|--------|-------------------|---------|
| ComfyUI, Ollama | local | Fast GPU access |
| Stable Diffusion | local | Model loading speed |

### Development/Tools

| Script | Recommended Storage | Reason |
|--------|-------------------|---------|
| Docker | local or local-lvm | Container images |
| GitLab, Gitea | local-lvm | Repository storage |
| Nginx, Caddy | local | Fast web serving |

---

## Integration with Script Execution

### Method 1: Environment Variable

```bash
# Set storage before execution
var_storage=local-lvm bash ct/docker.sh
```

### Method 2: Combined with Other Settings

```bash
# Full configuration
var_cpu=4 var_ram=8192 var_disk=20 var_storage=local-lvm bash ct/jellyfin.sh
```

### Method 3: With Network and Features

```bash
# Complete setup
var_cpu=2 var_ram=4096 var_storage=nas \
var_net=static var_ip=192.168.1.100 var_gateway=192.168.1.1 \
var_gpu=yes var_fuse=yes \
bash ct/kasm.sh
```

---

## Troubleshooting Storage Issues

### Container Creation Fails with "Storage Not Found"

**Cause:** Incorrect var_storage value

**Solution:**
1. Re-run `pvesm status` to verify exact storage names
2. Check for typos in user input
3. Try with `var_storage=local` (default)

### Container Starts but Storage Issues

**Symptoms:**
- Container is very slow
- I/O errors in logs
- Storage timeouts

**Check Commands:**
```bash
# Check container I/O
pct exec <ctid> iotop

# Check disk usage
pct df <ctid>
```

**Solutions:**
- For NFS: Check network connection
- For LVM: Check for thin provisioning issues
- Move container to faster storage if needed

---

## Best Practices

1. **Always show free space** - Help user make informed decision
2. **Provide recommendations** - Based on use case, not just a list
3. **Check space requirements** - Ensure chosen storage has enough space
4. **Validate storage name** - Match exact output from `pvesm status`
5. **Explain trade-offs** - Speed vs capacity, reliability vs performance
6. **Consider future growth** - Databases and media need more space over time
7. **Test storage accessibility** - Especially for NAS/NFS before recommending
8. **Offer defaults** - If uncertain, recommend based on use case
9. **Document user choice** - Keep record of what storage was selected
10. **Handle errors gracefully** - If storage unavailable, offer alternatives

---

## Example Workflows

### Workflow 1: Simple Deployment (Default Mode)

```
User: "Create a Grafana container"

LLM: [Finds grafana.sh, reads context]

LLM: Would you like Default settings or Advanced customization?
User: Default

LLM: Which storage drive should I use? [Shows available storage]
User: local

LLM: [Executes]
var_storage=local bash ct/grafana.sh
```

### Workflow 2: Custom Deployment (Advanced Mode)

```
User: "Create a PostgreSQL database on nas"

LLM: [Finds postgresql.sh, reads context]

LLM: Would you like Default settings or Advanced customization?
User: Advanced

LLM: Let's configure your PostgreSQL container:

1. Storage Drive: Which storage?
   Available: local (450GB free), local-lvm (700GB free), nas (3TB free)
   User: nas

2. Disk Size: How much space? (10-100 GB)
   User: 50

3. PostgreSQL Version: Which version? (15/16/17/18)
   User: 16

4. CPU Cores: How many? (1-4)
   User: 2

5. RAM Size: How much in MB? (512-8192)
   User: 4096

Summary:
- Storage: nas (3TB free)
- Disk: 50 GB
- Version: PostgreSQL 16
- CPUs: 2
- RAM: 4096 MB (4 GB)

Proceed? [Y/n]:
User: y

LLM: [Executes]
var_storage=nas var_disk=50 var_pgversion=16 var_cpu=2 var_ram=4096 bash ct/postgresql.sh
```

### Workflow 3: User Unsure

```
User: "I want to install Plex but I don't know which storage"

LLM: I can help you choose. Here are your options:

For Plex Media Server:

1. local (450GB free) - Fast SSD, but limited space
   - Good for: Small to medium media libraries
   - Not recommended for: Large libraries (500+ movies)

2. local-lvm (700GB free) - HDD storage, good balance
   - Good for: Medium to large libraries
   - Recommended for: Most use cases

3. nas (3TB free) - Network storage, large capacity
   - Good for: Large media libraries, backups
   - Note: Performance depends on network speed

Based on typical Plex setups, I recommend local-lvm for a balance of speed and capacity.

Would you like to use local-lvm? [Y/n]:
User: y

LLM: Great choice. I'll configure Plex with local-lvm storage using recommended settings.

[Proceeds with execution]
var_storage=local-lvm bash ct/plex.sh
```

---

## Next Steps

1. Always check available storage before asking user
2. Show free space to help user make informed decision
3. Provide use-case-specific recommendations
4. Validate storage name before setting var_storage
5. Handle storage-related errors gracefully
6. Document user's storage choice for reference
