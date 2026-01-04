# LLM Context System for ProxmoxVE Helper-Scripts

## Overview

This directory contains comprehensive context files designed to help AI/LLM agents navigate, understand, execute, and create scripts for the ProxmoxVE Helper-Scripts repository.

## Purpose

The LLM Context System enables AI agents to:
1. **Navigate and locate** appropriate existing scripts for services
2. **Execute scripts** non-interactively by translating UI prompts into questions
3. **Create new service scripts** with comprehensive research guidance
4. **Maintain context** as new scripts are added to the repository

---

## HOW TO FIND APPROPRIATE CONTEXT FILES

When you need information about a script or service, use one of these methods:

### Method 1: By Script Name (Direct Lookup)
If you know the script name:
```
Search for: .llm-context/scripts/[script-name].md
Examples:
  - Docker → .llm-context/scripts/docker.md
  - Plex → .llm-context/scripts/plex.md
  - PostgreSQL → .llm-context/scripts/postgresql.md
```

### Method 2: By Category
If you know the category of service:
```
Browse: .llm-context/categories/[category-id]-[category-name].md
Examples:
  - Databases → .llm-context/categories/08-databases.md
  - Media Streaming → .llm-context/categories/13-media-streaming.md
  - Monitoring & Analytics → .llm-context/categories/09-monitoring-analytics.md
```

### Method 3: By Keyword Search
If you only have keywords:
```
Search in: .llm-context/index.md
Use the "Keyword Search Patterns" section to find relevant scripts
Examples:
  - "message queue" → Kafka, RabbitMQ
  - "ad blocking" → AdGuard, Pi-hole
  - "video surveillance" → Frigate, AgentDVR
  - "password manager" → Vaultwarden, Bitwarden
```

### Method 4: By Port Number
If you know the service port:
```
Search in: .llm-context/index.md under "Port-Based Lookup" section
Examples:
  - Port 80/443 → Web servers, Caddy, Nginx
  - Port 3000 → Grafana, Node.js apps
  - Port 5432 → PostgreSQL
  - Port 27017 → MongoDB
```

### Method 5: By Special Requirement
If you need a specific feature:
```
Search in: .llm-context/index.md under "Special Requirements Index"
Examples:
  - GPU acceleration → Plex, Jellyfin, ComfyUI
  - FUSE support → Rclone, Kasm
  - TUN/TAP → WireGuard, Tailscale
  - LXC nesting → Docker, Alpine Docker
```

### Method 6: Popular Scripts (Quick Access)
For the most commonly used services:
```
Check: .llm-context/index.md under "Top 50 Popular Scripts"
Includes: Docker, PostgreSQL, Grafana, Plex, Jellyfin, Home Assistant, etc.
```

---

## Directory Structure

```
.llm-context/
├── README.md                  # This file
├── index.md                  # Master searchable index
├── CHANGELOG.md              # Phase progress tracking
├── automation/               # Scripts to maintain context system
│   ├── generate-context.sh     # Auto-generate context for new scripts
│   ├── update-index.sh        # Update index.md when scripts added
│   └── scan-new-scripts.sh   # Scan for scripts by other users
├── execution/                # How to execute scripts non-interactively
│   ├── overview.md           # Execution modes and LLM approach
│   ├── non-interactive-mode.md
│   ├── prompt-translation.md  # UI → question mapping
│   ├── ui-mimicry.md        # How to ask users for settings
│   ├── storage-selection.md  # Storage drive selection handling
│   └── error-handling.md
├── script-creation/         # Guides for creating new scripts
│   ├── overview.md
│   ├── research-methodology.md
│   ├── dependency-analysis.md
│   ├── resource-planning.md
│   ├── os-selection.md
│   ├── installation-patterns.md
│   ├── template-guide.md
│   ├── testing-validation.md
│   └── best-practices.md
├── categories/              # Category-specific context (26 files)
│   ├── 01-proxmox-virtualization.md
│   ├── 02-operating-systems.md
│   └── ...
└── scripts/                 # Individual script context files (408 files)
    ├── section-01/         # Scripts 1-10
    ├── section-02/         # Scripts 11-20
    └── ...
```

---

## Quick Start for LLM Agents

### Task 1: Find a Script for Existing Service

**User Request:** "Create a PostgreSQL database on node1"

**LLM Steps:**
1. Check if PostgreSQL exists: Look at `.llm-context/index.md` or search for "postgresql"
2. Read context: `.llm-context/scripts/postgresql.md`
3. Execute script using non-interactive mode (see `execution/` docs)

### Task 2: Create a New Service Script

**User Request:** "Create a Kafka service"

**LLM Steps:**
1. Check if Kafka exists: Search `index.md`
2. If not found, use `script-creation/` guides:
   - Read `script-creation/research-methodology.md`
   - Read `script-creation/dependency-analysis.md`
   - Read `script-creation/installation-patterns.md`
3. Follow template from `script-creation/template-guide.md`
4. Create CT script and install script
5. Generate context file using `automation/generate-context.sh`

### Task 3: Execute Script Non-Interactively

**User Request:** "Create a Docker container with 4GB RAM"

**LLM Steps:**
1. Read `.llm-context/scripts/docker.md`
2. Check for interactive prompts in docker-install.sh
3. Ask user: "Do you want Docker Compose? (y/N)"
4. Ask user: "Do you want Portainer UI? (y/N)"
5. Ask user: "Which storage drive should be used?" (if storage selection required)
6. Execute with environment variables:
   ```bash
   var_ram=4096 bash ct/docker.sh
   ```
7. Provide answers to prompts via stdin:
   ```bash
   echo -e "n\nn\nn" | var_ram=4096 bash ct/docker.sh
   ```

---

## Key Concepts

### Interactive vs Non-Interactive Mode

- **Interactive Mode**: Script displays whiptail menus, user selects options with keyboard
- **Non-Interactive Mode**: LLM collects all required information upfront, then executes script with pre-determined answers

LLM Agents should **ALWAYS use Non-Interactive Mode** because:
1. LLMs cannot interact with whiptail UI
2. LLMs must ask user all questions before execution
3. Pre-collected answers ensure no script gets stuck waiting for input

### Default vs Advanced Settings

When user requests a service, LLM should ask:

**"Do you want Default settings or Advanced customization?"**

- **Default**: Use script's default CPU/RAM/disk, skip advanced settings, only ask script-specific prompts
- **Advanced**: Ask user for ALL configuration options:
  - CPU cores
  - RAM amount
  - Disk size
  - Storage drive (if multiple available)
  - Network type (DHCP/Static)
  - VLAN settings
  - Special features (GPU, FUSE, TUN, Nesting)
  - Timezone
  - SSH access

See `execution/ui-mimicry.md` for detailed question formulation.

---

## Maintaining This Context System

### When New Scripts Are Added

If you add new scripts to the repository:
1. Run `automation/generate-context.sh` to create context files
2. Run `automation/update-index.sh` to update `index.md`
3. Run `automation/scan-new-scripts.sh` to check for scripts by other users

### When Existing Scripts Are Modified

If you modify existing scripts:
1. Re-run `automation/generate-context.sh` for the modified script
2. Run `automation/update-index.sh` if any metadata changed

---

## Important Notes

- **All context files are in Markdown format** for easy LLM parsing
- **Section-based organization**: Scripts organized in batches of 10 for maintainability
- **CHANGELOG.md tracks progress**: See which sections are completed
- **Automation scripts**: Help maintain context as repository grows
- **Category-based navigation**: 26 categories align with frontend metadata

---

## Getting Started

1. **To find a script**: Start with `index.md` or search by script name
2. **To execute a script**: Read `execution/overview.md` first
3. **To create a new script**: Read `script-creation/overview.md` first
4. **To maintain context**: Use scripts in `automation/` directory

---

## Next Steps

- See `index.md` for the master navigation system
- See `execution/` for how to run scripts
- See `script-creation/` for how to build new scripts
- See `CHANGELOG.md` for current progress
