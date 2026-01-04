# Execution Modes and LLM Approach

## Overview

This document explains how LLM agents should execute ProxmoxVE Helper-Scripts without interactive UI.

---

## The Challenge

ProxmoxVE scripts use `whiptail` and `read` prompts for user interaction in the terminal. LLMs cannot:
- Display or interact with whiptail menus
- Respond to interactive `read -p` prompts in real-time
- Navigate complex multi-stage menus

**Solution**: LLMs must collect all required information **before** script execution, then provide answers via environment variables or stdin.

---

## Two Execution Modes

### Mode 1: Interactive Mode (Human Use)

**How it works:**
1. User runs script: `bash ct/docker.sh`
2. Script displays whiptail menu
3. User selects options with keyboard
4. Script executes based on selections

**Example:**
```bash
$ bash ct/docker.sh

# Script displays whiptail menu:
# ┌────────────────────────────┐
# │ 1. Default Install      │
# │ 2. Advanced Install     │
# └────────────────────────────┘

# User presses "1" and enters "Default Install" mode
```

---

### Mode 2: Non-Interactive Mode (LLM Use)

**How it works:**
1. LLM collects all required information from user upfront
2. LLM sets environment variables for container settings
3. LLM provides answers to script-specific prompts via stdin
4. Script executes without waiting for user input

**Example:**
```bash
# LLM asks user questions first
User: "I want Docker on node1 with 4GB RAM"

# LLM determines:
# - Script: docker.sh
# - RAM: 4096 MB
# - Storage: local (need to ask)
# - Optional components: Docker Compose? Portainer?

# LLM executes:
var_ram=4096 var_storage=local bash ct/docker.sh <<< "n
n"
```

---

## LLM Execution Workflow

### Step 1: Identify Script

1. Search for script name (see `.llm-context/index.md`)
2. Read script context file for details
3. Identify required parameters and interactive prompts

### Step 2: Ask User for Settings

**Critical Question:** "Do you want Default settings or Advanced customization?"

**Default Mode:**
- Use script's default CPU/RAM/disk
- Skip advanced settings questions
- Only ask script-specific interactive prompts (if any)
- Use system default storage (or ask if multiple available)

**Advanced Mode:**
- Ask user for ALL configuration options
- Collect: CPU, RAM, Disk, Storage, Network, VLAN, SSH, Features
- Map to environment variables (see `non-interactive-mode.md`)

### Step 3: Collect Storage Information

**If storage selection required:**

Ask: "Which storage drive should be used?"

Get available storage:
```bash
pvesm status
# Output:
# storageid: type (available space)
# local: lvmthin (500GB)
# local-lvm: lvm (1TB)
# nas: nfs (5TB)
```

Example question:
```
Available storage drives:
1. local (500GB free)
2. local-lvm (1TB free)
3. nas (5TB free)

Which storage drive should I use? [1/2/3]:
```

### Step 4: Prepare Execution Command

**For container-level settings (CPU/RAM/Disk):**
```bash
var_cpu=2 var_ram=4096 var_disk=8 bash ct/script.sh
```

**For advanced settings:**
```bash
var_cpu=2 var_ram=4096 var_disk=8 var_storage=local-lvm var_net=static var_ip=192.168.1.100/24 var_gateway=192.168.1.1 bash ct/script.sh
```

**For script-specific prompts (via stdin):**
```bash
echo -e "n\nn\nn" | var_cpu=2 bash ct/script.sh
# Each line provides answer to one read -p prompt
```

**Combined approach:**
```bash
# Set container settings via env vars
# Provide script-specific answers via stdin
var_cpu=2 var_ram=4096 bash ct/script.sh <<< "n
y
n
"
```

### Step 5: Execute Script

```bash
# Non-interactive execution
var_cpu=2 var_ram=4096 bash ct/docker.sh

# With stdin for script-specific prompts
echo -e "n\ny\nn" | var_cpu=2 var_ram=4096 bash ct/docker.sh

# With storage selection
var_storage=local-lvm var_cpu=2 var_ram=4096 bash ct/docker.sh
```

### Step 6: Monitor Output

Capture script output for:
- Success message with access URL/port
- Error messages
- Container ID for verification

---

## Decision Tree: When to Use Which Mode

```
User Request: "Create a [service]"
    ↓
Is script known (has context file)?
    ↓
    YES: Read context file
        ↓
    Check for interactive prompts
            ↓
        Has prompts?
            ↓
        YES: Ask user all prompt questions
            ↓
        NO: Ask default vs advanced
            ↓
    NO: Use script-creation guides
```

---

## Key Principles

1. **Never execute with waiting for input** - Always collect information first
2. **Default vs Advanced is critical** - Determines how many questions to ask
3. **Storage is frequently needed** - Always check storage options
4. **Use stdin for script prompts** - Environment variables work for container settings only
5. **Log everything** - Capture output for verification and error reporting

---

## Example Scenarios

### Scenario 1: Simple Script (No Interactive Prompts)

**User Request:** "Create a Grafana monitoring instance"

**LLM Actions:**
1. Find script: `.llm-context/scripts/grafana.md`
2. Check for prompts: None (simple script)
3. Ask: "Default or Advanced?"
   - User: "Default"
4. Execute:
   ```bash
   bash ct/grafana.sh
   ```
   (Uses script defaults: 1 CPU, 512MB RAM, 2GB disk)

### Scenario 2: Script with Interactive Prompts

**User Request:** "Create a Docker container"

**LLM Actions:**
1. Find script: `.llm-context/scripts/docker.md`
2. Check for prompts: Yes (Docker Compose, Portainer, TCP socket)
3. Ask: "Default or Advanced?"
   - User: "Advanced - I want to choose components"
4. Ask: "Install Docker Compose v2 plugin?"
   - User: "Yes"
5. Ask: "Add Portainer (web UI)?"
   - User: "No"
6. Ask: "Add Portainer Agent (for remote management)?"
   - User: "Yes"
7. Ask: "Which storage drive?"
   - User: "local-lvm"
8. Execute:
   ```bash
   echo -e "y\nn\ny" | var_storage=local-lvm bash ct/docker.sh
   ```

### Scenario 3: Custom Resources

**User Request:** "Create a PostgreSQL database with 8GB RAM and 4 CPUs"

**LLM Actions:**
1. Find script: `.llm-context/scripts/postgresql.md`
2. Check for prompts: Yes (version selection)
3. Ask: "Which PostgreSQL version? (15/16/17/18)"
   - User: "17"
4. Execute:
   ```bash
   echo "17" | var_cpu=4 var_ram=8192 bash ct/postgresql.sh
   ```

---

## Troubleshooting

### Script Stuck Waiting for Input

**Symptom:** Script execution hangs, no output

**Cause:** Required prompt answer not provided

**Solution:**
1. Count number of `read -p` in install script
2. Ensure same number of lines provided via stdin
3. Check for whiptail menus (may need environment variables)
4. Use VERBOSE=yes to see where it's waiting

```bash
VERBOSE=yes bash ct/script.sh
```

### Wrong Answer Format

**Symptom:** Script rejects input or uses default

**Cause:** Answer format doesn't match prompt expectations

**Solution:**
1. Read script context file carefully
2. Check prompt translation in `prompt-translation.md`
3. Verify answer format (y/n, number, text)

### Storage Not Found

**Symptom:** "Storage not found" error

**Cause:** var_storage value doesn't match available storage

**Solution:**
1. Run `pvesm status` to list available storage
2. Show user list and ask for correct name
3. Use exact storage name from output

---

## Best Practices

1. **Always read context file first** - Contains prompt details and special requirements
2. **Ask clearly** - Present options with numbers or labels
3. **Validate user input** - Ensure it matches expected format before execution
4. **Use VERBOSE for debugging** - Add `VERBOSE=yes` when troubleshooting
5. **Document all answers** - Keep track of what user chose for reporting back
6. **Check for Alpine variants** - Some scripts have Alpine options with different resources
7. **Handle GPU/FUSE/TUN** - Check context for special var requirements

---

## Next Steps

1. Read `non-interactive-mode.md` for all environment variables
2. Read `prompt-translation.md` for UI → question mappings
3. Read `ui-mimicry.md` for detailed question formulation
4. Read `storage-selection.md` for storage drive handling
5. Read `error-handling.md` for common error recovery
