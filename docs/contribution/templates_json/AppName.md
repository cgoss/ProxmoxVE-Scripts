# **AppName<span></span>.json Files**

`AppName.json` files found in the `/json` directory. These files are used to provide informations for the website. For this guide we take `/json/snipeit.json` as example.

## Table of Contents

- [**AppName.json Files**](#appnamejson-files)
  - [Table of Contents](#table-of-contents)
  - [1. JSON Generator](#1-json-generator)
  - [2. LLM Context Integration](#2-llm-context-integration)

## 1. JSON Generator

Use the [JSON Generator](https://community-scripts.github.io/ProxmoxVE/json-editor) to create this file for your application.

## 2. LLM Context Integration

The JSON metadata file is essential for the **LLM Context System**:

**Required Fields for LLM Context:**
- `name` - Application display name
- `description` - Detailed description (up to 100 chars used in context)
- `categories` - Array of category IDs (see list below)
- `install_methods[].resources` - CPU, RAM, disk, OS, version defaults
- `interface_port` - Main application port
- `website` - Official website URL
- `documentation` - Documentation link
- `config_path` - Configuration file path (if applicable)

**Category IDs Reference:**
- 1: Proxmox Virtualization
- 2: Operating Systems
- 3: Containers & Docker
- 4: Network & Firewall
- 5: Adblock & DNS
- 6: Authentication & Security
- 7: Backup & Recovery
- 8: Databases
- 9: Monitoring & Analytics
- 10: Dashboards & Frontends
- 11: Files & Downloads
- 12: Documents & Notes
- 13: Media Streaming
- 14: Arr Suite
- 15: NVR & Cameras
- 16: IoT & Smart Home
- 17: Zigbee, Z-Wave, Matter
- 18: MQTT & Messaging
- 19: Automation & Scheduling
- 20: AI & Coding DevTools
- 21: Web Servers & Proxies
- 22: Bots & ChatOps
- 23: Finance & Budgeting
- 24: Gaming & Leisure
- 25: Business & ERP
- 99: Miscellaneous

**Automatic Context Generation:**
After creating your script and JSON metadata, the LLM Context System can automatically generate context files by running:
```bash
bash .llm-context/automation/generate-context.sh
```

This will create `.llm-context/scripts/section-*/${APP}.md` with:
- Script description and metadata
- Resource requirements from JSON
- Port and access information
- Non-interactive execution examples
- Special requirements (GPU, FUSE, TUN, nesting)

**Learn More:**
- **[LLM Context System README](../../.llm-context/README.md)** - Complete system overview
- **[LLM Context Integration Guide](../../.llm-context/execution/overview.md)** - How context is used by AI agents
- **[Script Context Example](../../.llm-context/scripts/section-*/example.md)** - See a generated context file
