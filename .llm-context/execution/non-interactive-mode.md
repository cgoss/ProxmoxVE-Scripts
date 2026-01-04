# Non-Interactive Mode - Environment Variables Reference

## Overview

This document provides a complete reference of all environment variables available for non-interactive script execution.

**Usage:** Set variables before script execution: `var_cpu=2 var_ram=2048 bash ct/script.sh`

---

## Core Container Variables

### var_cpu
**Description:** Number of CPU cores for container
**Type:** Number (integer)
**Default:** Script-specific (usually 2)
**Range:** 1-4 typical, up to 8 for heavy workloads
**Examples:**
```bash
var_cpu=1      # 1 core (minimal)
var_cpu=2      # 2 cores (standard)
var_cpu=4      # 4 cores (high performance)
```

---

### var_ram
**Description:** RAM in megabytes (MB) for container
**Type:** Number (integer)
**Default:** Script-specific (usually 2048)
**Range:** 512-16384
**Examples:**
```bash
var_ram=512      # 512 MB (minimal)
var_ram=2048     # 2048 MB / 2 GB (standard)
var_ram=4096     # 4096 MB / 4 GB (high)
var_ram=8192     # 8192 MB / 8 GB (very high)
```

---

### var_disk
**Description:** Disk size in gigabytes (GB) for container
**Type:** Number (integer)
**Default:** Script-specific (usually 4)
**Range:** 2-100+
**Examples:**
```bash
var_disk=2       # 2 GB (minimal, Alpine)
var_disk=4       # 4 GB (standard)
var_disk=8       # 8 GB (applications with data)
var_disk=20      # 20 GB (databases, media)
```

---

### var_os
**Description:** Base operating system for container
**Type:** String
**Default:** debian
**Valid Values:**
- `debian` - Debian Linux (default, full package ecosystem)
- `ubuntu` - Ubuntu Linux (latest software)
- `alpine` - Alpine Linux (minimal, secure)

**Examples:**
```bash
var_os=debian    # Debian 12
var_os=ubuntu    # Ubuntu 22.04 or 24.04
var_os=alpine    # Alpine 3.22
```

---

### var_version
**Description:** OS version (depends on var_os)
**Type:** String
**Default:** Script-specific

**Values by OS:**
- **Debian:** `12` (bookworm), `13` (trixie)
- **Ubuntu:** `22.04` (jammy), `24.04` (noble)
- **Alpine:** `3.20`, `3.21`, `3.22`

**Examples:**
```bash
# For Debian
var_os=debian var_version=12    # Debian 12 (bookworm)
var_os=debian var_version=13    # Debian 13 (trixie)

# For Ubuntu
var_os=ubuntu var_version=22.04  # Ubuntu 22.04 (jammy)
var_os=ubuntu var_version=24.04  # Ubuntu 24.04 (noble)

# For Alpine
var_os=alpine var_version=3.22  # Alpine 3.22
```

---

### var_unprivileged
**Description:** Container security type (privileged vs unprivileged)
**Type:** Number (0 or 1)
**Default:** 1 (unprivileged - recommended)
**Values:**
- `0` = Privileged (less secure, more capabilities)
- `1` = Unprivileged (secure, recommended)

**Examples:**
```bash
var_unprivileged=0    # Privileged container (for Docker, GPU passthrough)
var_unprivileged=1    # Unprivileged container (recommended, secure)
```

---

### var_storage
**Description:** Storage drive/ID for container
**Type:** String
**Default:** System default (auto-selects first available)
**Finding Storage Values:**
```bash
pvesm status
# Output example:
# storageid: type (free space)
# local: lvmthin (500GB available)
# local-lvm: lvm (1TB available)
# nas: nfs (5TB available)
```

**Examples:**
```bash
var_storage=local       # Default local storage
var_storage=local-lvm   # LVM-backed storage
var_storage=nas         # NFS-mounted storage
```

---

## Network Configuration Variables

### var_net
**Description:** Network configuration type
**Type:** String
**Default:** dhcp
**Valid Values:**
- `dhcp` - Automatic IP assignment (default)
- `static` - Manual IP configuration
- `none` - No network configuration

**Examples:**
```bash
var_net=dhcp       # Use DHCP (default)
var_net=static     # Use static IP
```

---

### var_ip
**Description:** Static IP address (required when var_net=static)
**Type:** String (IPv4 address)
**Default:** Empty (not set for dhcp)
**Format:** xxx.xxx.xxx.xxx

**Examples:**
```bash
var_ip=192.168.1.100
var_ip=10.0.0.50
```

---

### var_gateway
**Description:** Default gateway (required when var_net=static)
**Type:** String (IPv4 address)
**Default:** Empty (not set for dhcp)
**Format:** xxx.xxx.xxx.xxx

**Examples:**
```bash
var_gateway=192.168.1.1
var_gateway=10.0.0.1
```

---

### var_brg
**Description:** Network bridge to attach container
**Type:** String
**Default:** vmbr0 (first Proxmox bridge)
**Finding Bridge Values:**
```bash
pvesh get /nodes/<node>/qemu/<vmid>/agent/network
# Or check /etc/pve/qemu-server/<vmid>.conf
```

**Examples:**
```bash
var_brg=vmbr0    # Default bridge
var_brg=vmbr1    # Secondary bridge
var_brg=vmbr10   # VLAN bridge
```

---

### var_vlan
**Description:** VLAN tag for container
**Type:** String (number)
**Default:** Empty (no VLAN)
**Range:** 1-4094

**Examples:**
```bash
var_vlan=100      # VLAN 100
var_vlan=200      # VLAN 200
```

---

## Advanced Features Variables

### var_gpu
**Description:** Enable GPU passthrough
**Type:** String
**Default:** no
**Valid Values:**
- `no` - No GPU passthrough
- `yes` - Pass all available GPUs

**Scripts Requiring GPU:**
plex, jellyfin, emby, immich, comfyui, frigate, agentdvr, channels, and 18 others

**Auto-Detection:**
```bash
# Script checks if GPUs are available
# Prompts: "Do you want to pass through GPU?"
```

**Examples:**
```bash
var_gpu=yes       # Enable GPU passthrough
var_gpu=no        # Disable GPU passthrough (default)
```

---

### var_fuse
**Description:** Enable FUSE filesystem support
**Type:** String
**Default:** no
**Valid Values:**
- `no` - No FUSE support
- `yes` - Enable FUSE (for rclone, AppImage, mergerfs)

**Scripts Requiring FUSE:**
rclone, alpine-rclone, cosmos, kasm, minarca

**Examples:**
```bash
var_fuse=yes      # Enable FUSE support
var_fuse=no       # Disable FUSE (default)
```

---

### var_tun
**Description:** Enable TUN/TAP device support
**Type:** String
**Default:** no
**Valid Values:**
- `no` - No TUN/TAP support
- `yes` / `1` - Enable TUN/TAP (for VPN, WireGuard)

**Scripts Requiring TUN:**
wireguard, alpine-wireguard, tailscale, kasm, pangolin

**Examples:**
```bash
var_tun=yes       # Enable TUN/TAP support
var_tun=no        # Disable TUN/TAP (default)
```

---

### var_nesting
**Description:** Enable LXC nesting (containers within containers)
**Type:** Number (0 or 1)
**Default:** 1
**Values:**
- `0` - No nesting
- `1` - Enable nesting (default for Docker scripts)

**Scripts Requiring Nesting:**
docker, alpine-docker (implicit)

**Examples:**
```bash
var_nesting=1     # Enable LXC nesting (for Docker-in-LXC)
var_nesting=0     # Disable nesting
```

---

### var_keyctl
**Description:** Enable keyctl support (for Docker, systemd-networkd)
**Type:** Number (0 or 1)
**Default:** 0
**Values:**
- `0` - No keyctl (default)
- `1` - Enable keyctl

**Examples:**
```bash
var_keyctl=1     # Enable keyctl support
```

---

### var_mknod
**Description:** Enable device node creation (mknod)
**Type:** Number (0 or 1)
**Default:** 0
**Values:**
- `0` - No mknod (default)
- `1` - Enable mknod (experimental)

**Examples:**
```bash
var_mknod=1      # Enable mknod
```

---

## Security & Access Variables

### var_ssh
**Description:** Enable SSH access to container
**Type:** String
**Default:** no
**Valid Values:**
- `no` - Disable SSH (default)
- `yes` - Enable SSH access

**Examples:**
```bash
var_ssh=yes       # Enable SSH access
var_ssh=no        # Disable SSH (default)
```

---

### var_protection
**Description:** Enable container protection (prevent deletion)
**Type:** String
**Default:** no
**Valid Values:**
- `no` - No protection (default)
- `yes` - Enable deletion protection

**Examples:**
```bash
var_protection=yes  # Enable protection
var_protection=no   # Disable protection (default)
```

---

### var_timezone
**Description:** Container timezone
**Type:** String
**Default:** host (use Proxmox host timezone)
**Valid Values:**
- `host` - Use host timezone (default)
- Specific timezone: `UTC`, `America/New_York`, `Europe/London`, etc.

**Examples:**
```bash
var_timezone=UTC              # Set to UTC
var_timezone=host            # Use host timezone (default)
var_timezone=America/New_York # Set to New York timezone
```

---

## Utility Variables

### var_apt_cacher
**Description:** Use APT cacher proxy for package downloads
**Type:** String
**Default:** no
**Valid Values:**
- `no` - Don't use cacher (default)
- IP address of cacher server

**Examples:**
```bash
var_apt_cacher=192.168.1.10    # Use cacher at 192.168.1.10
var_apt_cacher=no                # Don't use cacher (default)
```

---

### var_verbose
**Description:** Enable verbose output (show all command output)
**Type:** String
**Default:** no
**Valid Values:**
- `no` - Silent mode (suppress non-error output)
- `yes` - Show all output

**Examples:**
```bash
VERBOSE=yes bash ct/docker.sh        # Enable verbose
var_verbose=yes bash ct/docker.sh   # Alternative syntax
```

---

## Script-Level Variables

### APP
**Description:** Application name (script-defined, not set via env var)
**Type:** String (script header)
**Example:** `APP="Docker"`

### var_tags
**Description:** Category tags for the application
**Type:** String
**Default:** Script-defined
**Format:** Semicolon-separated, max 2 tags
**Examples:**
```bash
var_tags=database           # Single tag
var_tags=media;streaming   # Multiple tags
```

---

## Container ID Variables

### var_ctid
**Description:** Specific container ID to use
**Type:** Number
**Default:** Auto-assigned (next available ID)
**Range:** 100-999999999

**Examples:**
```bash
var_ctid=150      # Use specific container ID 150
```

---

### var_hostname
**Description:** Container hostname
**Type:** String
**Default:** Derived from APP name (lowercase, no spaces)
**Format:** Lowercase, alphanumeric, hyphens only

**Examples:**
```bash
var_hostname=webserver       # Custom hostname
# Default would be: docker (for docker.sh)
```

---

## Combining Variables

### Basic Setup
```bash
# Minimal non-interactive
var_cpu=2 var_ram=2048 bash ct/docker.sh
```

### With Network Configuration
```bash
# Static IP setup
var_net=static var_ip=192.168.1.100 var_gateway=192.168.1.1 bash ct/docker.sh
```

### With All Advanced Settings
```bash
# Fully customized container
var_cpu=4 var_ram=8192 var_disk=20 var_os=ubuntu var_version=24.04 \
var_unprivileged=0 var_storage=local-lvm var_net=static var_ip=192.168.1.100 \
var_gateway=192.168.1.1 var_vlan=100 var_ssh=yes var_gpu=yes \
bash ct/jellyfin.sh
```

### With Script-Specific Answers (via stdin)
```bash
# Set container variables via env vars
# Provide script-specific answers via stdin
var_cpu=2 var_ram=4096 bash ct/docker.sh <<< "n
y
n
"
```

---

## Priority of Variables

**Highest Priority (set in script header):**
- APP, var_tags, var_os, var_version, var_cpu, var_ram, var_disk, var_unprivileged

**Medium Priority (can override script defaults):**
- var_gpu, var_fuse, var_tun, var_nesting, var_storage, var_net, var_ip, var_gateway, var_brg, var_vlan

**Lowest Priority (advanced/optional):**
- var_ssh, var_protection, var_timezone, var_apt_cacher, var_verbose, var_keyctl, var_mknod

---

## Best Practices

1. **Set only what you need** - Let script use defaults for the rest
2. **Use proper units** - RAM in MB, disk in GB
3. **Validate before execution** - Check storage names, IP formats
4. **Combine with stdin** - Use env vars for container, stdin for script prompts
5. **Use VERBOSE=yes** - When troubleshooting to see all output
6. **Check script context** - Some scripts have specific requirements not covered by general vars

---

## Finding Available Values

### Get Available Storage
```bash
pvesm status
# Lists: storageid, type, total, used, avail
```

### Get Available Bridges
```bash
ls /etc/pve/qemu-server/
# Lists: vmbr0, vmbr1, vmbr10, etc.
```

### Check for GPUs
```bash
lspci | grep -i vga
# Or inside Proxmox:
qm list | grep gpu
```

---

## Next Steps

1. Use this reference to set appropriate environment variables
2. See `prompt-translation.md` for script-specific prompt handling
3. See `ui-mimicry.md` for how to ask users questions
4. See `storage-selection.md` for storage drive selection details
