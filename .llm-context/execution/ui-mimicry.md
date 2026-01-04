# UI Mimicry - How to Ask Users for Settings

## Overview

This document guides LLMs on how to translate whiptail UI into natural questions for users.

---

## The "Default vs Advanced" Question

**Critical First Question:**

When user requests a service (e.g., "Create a Docker container"), always ask:

```
Would you like to use Default settings or Advanced customization?

- Default: Use script's recommended settings (fast, simple)
- Advanced: Customize all configuration options (CPU, RAM, disk, network, features)
```

**This determines which questions to ask:**

---

## Flow Chart: Default vs Advanced Decision

```
User Request: "Create [service]"
    ↓
LLM: Find script and read context file
    ↓
LLM: Ask "Default or Advanced?"
    ↓
    ┌─────────────┬────────────┐
    │            │            │
  Default      Advanced
    │            │            │
    ↓            ↓            ↓
Use script    Ask ALL     Collect ALL
defaults     advanced    settings
    │            │            │
    ↓            ↓            ↓
Ask script-  Execute with
specific     environment
prompts      variables
    │            │            │
    ↓            ↓            ↓
Only ask     Execute
for script-   with all
prompts      settings set
    └────────────┴────────────┘
```

---

## When to Use Default Mode

**Indicators for Default Mode:**
- User says "just make it work", "standard setup", "quick install"
- User says "I don't care about details", "use defaults"
- User provides minimal info (e.g., just "docker" without specs)

**Default Mode Workflow:**

1. **Skip container settings** - Use script's defaults (CPU/RAM/Disk/OS)
2. **Skip advanced settings** - Don't ask about VLAN, DNS, SSH, features
3. **Only ask script-specific prompts** - If script has interactive prompts, ask those
4. **Ask about storage** - If multiple storage drives available, ask which one

**Example:**
```
User: "Create a Grafana instance"

LLM: Would you like Default settings or Advanced customization?
User: Default

LLM: [Uses script defaults: 1 CPU, 512MB RAM, 2GB disk]
LLM: Which storage drive should I use?
User: local

[Executes with: var_storage=local bash ct/grafana.sh]
```

---

## When to Use Advanced Mode

**Indicators for Advanced Mode:**
- User specifies resources (e.g., "8GB RAM", "4 CPUs")
- User says "I want to configure everything", "full control"
- User mentions specific feature needs (e.g., "I need GPU", "I need VPN support")
- User wants to customize network (static IP, VLAN)
- User wants custom storage location

**Advanced Mode Workflow:**

1. **Ask all container settings** - CPU, RAM, Disk, OS, Privileged
2. **Ask all network settings** - Bridge, IP config, DNS, MTU, VLAN
3. **Ask all feature settings** - GPU, FUSE, TUN, Nesting, SSH
4. **Ask script-specific prompts** - If script has interactive prompts
5. **Ask about storage** - Which drive to use
6. **Confirm before execution** - Show summary and ask for confirmation

**Example:**
```
User: "Create a Jellyfin instance with 4 CPUs, 8GB RAM"

LLM: [User specified resources → Advanced mode]

LLM: Let's configure your Jellyfin container:

1. CPU Cores: 4 [User specified] - OK?
2. RAM Size: 8192 MB (8GB) [User specified] - OK?
3. Disk Size: 20 GB (script default) - OK? [or ask user]
4. OS: Debian 12 - OK? [or ask user]
5. Privileged: No (script default) - OK? [Jellyfin needs GPU]
6. GPU Passthrough: Yes - OK?
7. Network: DHCP - OK?
8. Storage: Which drive? [Show options]
9. Jellyfin-specific prompts: None

Summary:
- 4 CPUs
- 8192 MB RAM
- 20 GB disk
- Debian 12
- GPU enabled
- Local storage

Proceed? [Y/n]:
User: y

[Executes with full configuration]
```

---

## Question Formulation Guidelines

### Principle 1: Be Clear and Concise

**Bad:**
```
What kind of central processing unit allocation do you desire to utilize within the logical container environment?
```

**Good:**
```
How many CPU cores? (1-8 recommended)
```

### Principle 2: Provide Context and Examples

**Bad:**
```
Enter IP address:
```

**Good:**
```
Enter static IP address (e.g., 192.168.1.100):
```

### Principle 3: Show Defaults When Available

**Always tell user what the default is:**
```
How many CPU cores? (Default: 2):
```

### Principle 4: Explain Impact of Choices

**For GPU:**
```
Enable GPU passthrough?

This is required for:
- Hardware-accelerated video transcoding
- AI/ML workloads
- 3D rendering
- Computer vision (e.g., Frigate)

Enable GPU? [Y/n]:
```

**For FUSE:**
```
Enable FUSE filesystem support?

This is required for:
- Rclone (cloud storage mounting)
- AppImage applications
- MergerFS (filesystem merging)
- Custom filesystems

Enable FUSE? [Y/n]:
```

**For Nesting:**
```
Enable LXC nesting?

This is required for:
- Running Docker within a container
- Running LXC within a container
- Nested virtualization

Enable nesting? [Y/n]:
```

---

## Storage Selection Questions

### When to Ask Storage

**Always ask when:**
- User selects Advanced mode
- Multiple storage drives available on Proxmox host
- Script doesn't have a default storage preference

### How to Ask

**Step 1: Check Available Storage**
```bash
# Run this command
pvesm status

# Example output:
# storageid: type (total/used/avail)
# local: lvmthin (500G total, 100G used, 400G avail)
# local-lvm: lvm (1T total, 200G used, 800G avail)
# nas: nfs (5T total, 2T used, 3T avail)
```

**Step 2: Present Options to User**

```
Available storage drives:

1. local (400GB free) - Default LVM thin storage
2. local-lvm (800GB free) - LVM storage
3. nas (3TB free) - NFS-mounted storage

Which storage drive would you like to use? [1/2/3]:
```

**Step 3: Set Variable**

```bash
# User chooses 2
var_storage=local-lvm bash ct/script.sh
```

---

## Network Configuration Questions

### IPv4 Configuration

**Question:**
```
How should I configure IPv4 networking?

1. DHCP - Automatic (recommended)
2. Static - Manual IP configuration
3. IP Range Scan - Find available IPs

Choose network type [1/2/3]:
```

**If User Chooses Static:**
```
Enter IPv4 address (e.g., 192.168.1.100):
```
```
Enter gateway (e.g., 192.168.1.1):
```

**If User Chooses IP Range Scan:**
```
Enter IP range to scan (e.g., 192.168.1.0/24):
```

---

### IPv6 Configuration

**Question:**
```
How should I configure IPv6 networking?

1. Auto - SLAAC (recommended)
2. DHCP - Automatic assignment
3. Static - Manual configuration
4. None - Disable IPv6
5. Disable - Disable IPv6 completely

Choose IPv6 type [1/2/3/4/5]:
```

---

## Advanced Features Questions

### GPU Passthrough

**Question:**
```
Does this application require GPU acceleration?

GPU is needed for:
- Video transcoding (Plex, Jellyfin, Emby)
- AI/ML workloads (ComfyUI, Ollama)
- Computer vision (Figate, AgentDVR)
- 3D rendering

Enable GPU passthrough? [Y/n]:
```

**Auto-Detection Note:**
```
Note: I've detected the following GPUs on this system:
- GPU 0: NVIDIA GeForce RTX 3090 (8GB)
- GPU 1: Intel UHD Graphics 630

Would you like to pass through GPU 0? [Y/n]:
```

---

### FUSE Support

**Question:**
```
Does this application need FUSE filesystem support?

FUSE is needed for:
- Rclone (cloud storage)
- AppImage applications
- MergerFS (filesystem merging)
- Custom filesystems

Enable FUSE support? [Y/n]:
```

---

### TUN/TAP Support

**Question:**
```
Does this application need TUN/TAP device support?

TUN/TAP is needed for:
- VPN (WireGuard, OpenVPN, Tailscale)
- Tunnels
- Network-level applications

Enable TUN/TAP support? [Y/n]:
```

---

### LXC Nesting

**Question:**
```
Does this application need LXC nesting?

Nesting is needed for:
- Running Docker within a container
- Running LXC within a container
- Nested virtualization

Enable LXC nesting? [Y/n]:
```

**For Docker Scripts:**
```
Note: Docker requires LXC nesting to function.

Enable LXC nesting for Docker-in-LXC? [Y/n]:
```

---

## Summary Confirmation

### Before Execution

Always show user a summary of what will be created:

**Example:**
```
Container Configuration Summary:

Container: Docker
CPU Cores: 2
RAM: 4096 MB (4 GB)
Disk: 8 GB
OS: Debian 12
Privileged: No
Storage: local
Network: DHCP
GPU: No
FUSE: No
TUN/TAP: No

Proceed with this configuration? [Y/n]:
```

**Benefits:**
- User verifies settings before execution
- LLM catches mistakes before running
- Clear confirmation prevents accidental creation

---

## Handling "I Don't Know" Responses

**If user doesn't know an answer:**

1. **Provide recommendations:**
```
How many CPU cores? (Recommended: 2 for standard apps, 4 for AI/media)

Enter number or press Enter for default [2]:
```

2. **Explain trade-offs:**
```
GPU passthrough?

Yes - Enables hardware acceleration but requires more resources
No - Uses CPU only, lower resource requirements

Enable GPU? [Y/n]:
```

3. **Offer to use defaults:**
```
I see you're unsure. Would you like to use the recommended defaults?

- CPU: 2 cores
- RAM: 2048 MB (2 GB)
- Disk: 4 GB

Use defaults? [Y/n]:
```

---

## Script-Specific Questions

### For PostgreSQL
```
Which PostgreSQL version do you want to install?

Available versions:
- 15 (stable, long-term support until 2027)
- 16 (stable, recommended)
- 17 (stable, includes additional features)
- 18 (development, latest features)

Choose version [15/16/17/18]:
```

### For Docker (Advanced)
```
Docker provides additional components:

1. Docker Engine - Always installed
2. Docker Compose - CLI for multi-container apps
3. Portainer UI - Web management interface
4. Portainer Agent - Remote management (no UI)

Select additional components (comma-separated or 'all'):
```

### For Kasm
```
Kasm Workspaces provides a browser-based VDI.

Would you like to install Kasm Workspaces? [Y/n]:

Note: This requires:
- Minimum 8GB RAM
- GPU passthrough recommended
- FUSE support
```

---

## Best Practices

1. **Always ask default vs advanced first** - This is the most important question
2. **Group related questions** - Network questions together, storage questions together
3. **Show impact of choices** - Explain what GPU/FUSE/TUN actually does
4. **Provide examples** - Show valid input format
5. **Accept partial information** - User can answer some questions with "default"
6. **Be flexible with format** - Accept "Y", "y", "Yes", "1" for yes
7. **Validate complex answers** - Ask for confirmation if user provides unusual values
8. **Offer defaults prominently** - Make it easy for users to choose defaults
9. **Explain special requirements clearly** - GPU, FUSE, TUN, nesting have specific use cases
10. **Don't overwhelm** - Break advanced settings into logical groups

---

## Common User Patterns

### User says "Just make it work"
→ Use Default mode, skip advanced questions

### User provides exact specifications
→ Use Advanced mode, confirm specs
Example: "4 CPUs, 16GB RAM, 100GB disk"

### User says "Use what you recommend"
→ Use Default mode for container settings, only ask script-specific prompts

### User says "I want full control"
→ Use Advanced mode, ask all 28 settings questions

### User asks "What should I choose?"
→ Explain trade-offs, recommend based on use case

---

## Next Steps

1. Use this guide to formulate questions clearly
2. See `prompt-translation.md` for UI element mappings
3. See `storage-selection.md` for storage drive handling
4. See `non-interactive-mode.md` for environment variable reference
