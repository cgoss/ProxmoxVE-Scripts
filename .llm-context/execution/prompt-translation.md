# Prompt Translation - UI → Question Mapping

## Overview

This document maps ProxmoxVE script UI elements (whiptail menus, read prompts) to questions LLMs should ask users.

---

## Whiptail Menu Types

### Type 1: Radiolist (Single Choice)

**UI Appearance:**
```
┌──────────────────────────┐
│ Select Option:          │
│                        │
│ (*) Option 1           │
│ ( ) Option 2           │
│ ( ) Option 3           │
│                        │
│         <Ok> <Cancel> │
└──────────────────────────┘
```

**LLM Translation:** Single-choice question

**Format:**
```
[Menu Text]

1. Option 1 - [Description]
2. Option 2 - [Description]
3. Option 3 - [Description]

Which option would you like? [1/2/3]:
```

**Example - Docker Compose Installation:**
```
Docker Compose Plugin

1. Yes - Install Docker Compose v2 plugin
2. No - Skip Docker Compose installation

Would you like to install Docker Compose? [1/2]:
```

**Example - PostgreSQL Version Selection:**
```
PostgreSQL Version

1. 15 - PostgreSQL 15 (stable)
2. 16 - PostgreSQL 16 (stable)
3. 17 - PostgreSQL 17 (stable)
4. 18 - PostgreSQL 18 (development)

Which PostgreSQL version would you like? [1/2/3/4]:
```

**Handling User Response:**
```bash
# User enters: 1
# LLM provides: "1" or "Yes" or "15"
```

---

### Type 2: Checklist (Multiple Choices)

**UI Appearance:**
```
┌──────────────────────────┐
│ Select Components:      │
│                        │
│ [+] Component 1        │
│ [ ] Component 2        │
│ [*] Component 3        │
│                        │
│         <Ok> <Cancel> │
└──────────────────────────┘
```

**LLM Translation:** Multiple-choice question

**Format:**
```
[Menu Text]

Select components (you can choose multiple):

1. [ ] Component 1 - [Description]
2. [x] Component 2 - [Description] (pre-selected if checked)
3. [ ] Component 3 - [Description]

Enter numbers of components to install (e.g., "1 3" or "all"):
```

**Example - Docker Components:**
```
Docker Components

1. [ ] Docker Engine (always installed)
2. [ ] Portainer UI - Web management interface
3. [ ] Portainer Agent - Remote management

Enter numbers of components you want (e.g., "2" or "2 3"):
```

**Handling User Response:**
```bash
# User enters: 2 3
# LLM provides: "2 3" or "Portainer" or "Portainer Agent"
```

---

### Type 3: Yes/No Dialog

**UI Appearance:**
```
┌──────────────────────────┐
│                        │
│  Install Component?      │
│                        │
│       <Yes>  <No>    │
│                        │
└──────────────────────────┘
```

**LLM Translation:** Yes/No question

**Format:**
```
[Question Text]

[Description of what this does]

Would you like to install this? [Y/n]:
```

**Example - Docker Compose:**
```
Docker Compose v2 Plugin

This plugin provides CLI commands for multi-container applications.

Would you like to install Docker Compose? [Y/n]:
```

**Example - Portainer:**
```
Portainer Web UI

Portainer provides a web-based interface for managing Docker.

Would you like to add Portainer (web management UI)? [Y/n]:
```

**Handling User Response:**
```bash
# User enters: y, Y, yes
# LLM provides: "y" or "yes" or "1" (for radiolist equivalent)

# User enters: n, N, no
# LLM provides: "n" or "no" or "2" (for radiolist equivalent)
```

---

### Type 4: Input Box

**UI Appearance:**
```
┌──────────────────────────┐
│                        │
│  Enter Value:           │
│                        │
│  [__________]          │
│                        │
│        <Ok> <Cancel> │
└──────────────────────────┘
```

**LLM Translation:** Text/number input question

**Format:**
```
[Question/Label]

Enter [value type] [description/constraint]:

```

**Example - Static IP:**
```
Network Configuration

Enter IPv4 address (e.g., 192.168.1.100):
```

**Example - Version Selection:**
```
Application Version

Enter version number (e.g., 2.5.1 or "latest"):
```

**Handling User Response:**
```bash
# User enters: 192.168.1.100
# LLM provides: "192.168.1.100"

# User enters: latest
# LLM provides: "latest" or asks for version number
```

---

### Type 5: Password Box

**UI Appearance:**
```
┌──────────────────────────┐
│                        │
│  Enter Password:         │
│                        │
│  [************]        │
│                        │
│        <Ok> <Cancel> │
└──────────────────────────┘
```

**LLM Translation:** Password input question

**Format:**
```
[Question/Label]

Enter [password type] password:

Note: Password will be [hidden/obscured in script]
```

**Example - Database Password:**
```
Database Configuration

Enter root password for PostgreSQL:

Note: This password will be set for the database superuser.
```

**Handling User Response:**
```bash
# User enters: mysecurepassword123
# LLM provides: "mysecurepassword123"
# Note: LLM should store this securely and provide to script
```

---

### Type 6: Menu (Multiple-Level Navigation)

**UI Appearance:**
```
┌──────────────────────────┐
│  Main Menu:            │
│                        │
│  1. Default Install   │
│  2. Advanced Install   │
│  3. Settings         │
│  4. Exit             │
│                        │
│                        │
└──────────────────────────┘
```

**LLM Translation:** Multi-step navigation

**Format:**
```
[Menu Title]

1. [Option 1] - [Description]
2. [Option 2] - [Description]
3. [Option 3] - [Description]
4. [Option 4] - [Description]

Select an option [1/2/3/4]:
```

**Example - Docker Installation Menu:**
```
Docker Installation Options

1. Default Install - Use recommended settings
2. Advanced Install - Customize all options
3. User Defaults - Load saved configuration
4. Settings - Manage defaults
5. Exit

Select an option [1/2/3/4/5]:
```

**Handling User Response:**
```bash
# User enters: 1
# LLM executes action for option 1 (default install)

# User enters: 2
# LLM proceeds to ask advanced settings questions
```

---

## Read -p Prompts (Direct Input)

### Pattern 1: Simple Yes/No

**Bash Code:**
```bash
read -r -p "${TAB3}Install Docker Compose v2 plugin? <y/N> " prompt_compose
if [[ ${prompt_compose,,} =~ ^(y|yes)$ ]]; then
  # Install
fi
```

**LLM Translation:**
```
Install Docker Compose v2 Plugin

This plugin provides CLI commands for multi-container Docker applications.

Would you like to install Docker Compose v2 plugin? [Y/n]:
```

**Execution via stdin:**
```bash
echo "y" | bash ct/docker.sh  # If user wants it
echo "n" | bash ct/docker.sh  # If user doesn't want it
```

---

### Pattern 2: Input with Validation

**Bash Code:**
```bash
read -r -p "${TAB3}Enter PostgreSQL version (15/16/17/18): " ver
[[ $ver =~ ^(15|16|17|18)$ ]] || {
  echo "Invalid version"
  exit 1
}
PG_VERSION=$ver setup_postgresql
```

**LLM Translation:**
```
PostgreSQL Version Selection

Available versions:
- 15 - PostgreSQL 15 (stable)
- 16 - PostgreSQL 16 (stable)
- 17 - PostgreSQL 17 (stable)
- 18 - PostgreSQL 18 (development)

Which PostgreSQL version would you like? [15/16/17/18]:
```

**Handling Invalid Input:**
```bash
# User enters: 19
LLM: "Invalid version. Please choose from 15, 16, 17, or 18."
```

---

### Pattern 3: Multi-Choice Input

**Bash Code:**
```bash
read -r -p "${TAB3}Expose Docker TCP socket? [n = No, l = Local only, a = All interfaces] <n/l/a>: " socket_choice
case "${socket_choice,,}" in
  l)
    socket="tcp://127.0.0.1:2375"
    ;;
  a)
    socket="tcp://0.0.0.0:2375"
    ;;
  *)
    socket=""
    ;;
esac
```

**LLM Translation:**
```
Docker TCP Socket Configuration

This allows Docker to be managed remotely (insecure - use with caution).

Options:
- n = No (recommended - don't expose)
- l = Local only (127.0.0.1:2375)
- a = All interfaces (0.0.0.0:2375 - insecure)

How would you like to configure Docker TCP socket? [n/l/a]:
```

**Execution via stdin:**
```bash
echo "n" | bash ct/docker.sh   # Don't expose
echo "l" | bash ct/docker.sh  # Local only
echo "a" | bash ct/docker.sh  # All interfaces (insecure)
```

---

## Advanced Settings Wizard (28 Steps)

The `advanced_settings()` function in build.func provides a 28-step configuration wizard.

### Standard Questions to Ask (Advanced Mode)

When user selects "Advanced" mode, LLM should ask:

**Group 1: Basic Configuration**
1. Container Type: Unprivileged (recommended) or Privileged?
2. Root Password: Set password or leave empty for auto-login?
3. Container ID: Auto-assign or specific ID?
4. Hostname: Use script default or custom name?

**Group 2: Resources**
5. Disk Size: Enter size in GB?
6. CPU Cores: Enter number (1-8)?
7. RAM Size: Enter size in MB?

**Group 3: Network**
8. Network Bridge: Which bridge? (vmbr0, vmbr1, etc.)
9. IPv4 Configuration: DHCP, Static IP, or IP Range Scan?

**If Static IP selected:**
9a. IPv4 Address: Enter IP (e.g., 192.168.1.100)?
9b. Gateway: Enter gateway (e.g., 192.168.1.1)?

10. IPv6 Configuration: Auto, DHCP, Static, None, or Disable?

**If Static IPv6 selected:**
10a. IPv6 Address: Enter IPv6 address?

11. MTU Size: Use default 1500 or custom value?

12. DNS Search Domain: Leave empty for host setting or enter domain?

13. DNS Server: Leave empty for host setting or enter server IP?

14. MAC Address: Leave empty for auto-generated or enter specific MAC?

15. VLAN Tag: Leave empty for no VLAN or enter VLAN number?

16. Tags: Semicolon-separated custom tags (optional)?

**Group 4: Advanced Features**
17. SSH Settings: Enable SSH access with key selection?

18. FUSE Support: Enable for rclone, AppImage, mergerfs?

19. TUN/TAP Support: Enable for VPN, WireGuard, Tailscale?

20. Nesting Support: Enable for Docker/LXC in LXC?

21. GPU Passthrough: Enable for AI tools, media servers?

22. Keyctl Support: Enable for Docker, systemd-networkd?

23. APT Cacher Proxy: Speed up package downloads?

24. Timezone: Use host timezone or enter specific timezone?

25. Container Protection: Enable to prevent accidental deletion?

26. Device Node Creation (mknod): Experimental feature for device management?

27. Mount Filesystems: nfs, cifs, fuse, ext4, etc.?

28. Verbose Mode & Confirmation: Show all output and confirm before creation?

---

## Providing Answers to Scripts

### Method 1: Environment Variables (Container Settings)

**Use for:** CPU, RAM, Disk, OS, Network, Features

**Example:**
```bash
var_cpu=4 var_ram=8192 var_disk=20 var_unprivileged=0 var_storage=local-lvm \
var_net=static var_ip=192.168.1.100 var_gateway=192.168.1.1 \
var_gpu=yes var_fuse=yes var_nesting=1 \
bash ct/jellyfin.sh
```

### Method 2: stdin (Script-Specific Prompts)

**Use for:** Interactive prompts in install script

**Example - Single Prompt:**
```bash
# User wants Docker Compose
echo "y" | var_cpu=2 var_ram=2048 bash ct/docker.sh
```

**Example - Multiple Prompts:**
```bash
# User wants Docker Compose (y), Portainer (n), TCP socket (l)
echo -e "y\nn\nl" | var_cpu=2 var_ram=2048 bash ct/docker.sh
```

**Example - Version Selection:**
```bash
# User wants PostgreSQL 17
echo "17" | bash ct/postgresql.sh
```

### Method 3: Combined Approach

**Best for:** Scripts with both container settings and script-specific prompts

**Example:**
```bash
# Set container settings via env vars
# Provide answers to script prompts via stdin
var_cpu=2 var_ram=4096 var_storage=local-lvm bash ct/docker.sh <<< "n
y
n"
```

---

## Common Prompt Patterns

### "Install X?" Pattern

**Translation:**
```
Would you like to install [Component Name]?

This [component] [description of what it does].

Options:
- Y = Yes, install [component]
- N = No, skip [component]

Install? [Y/n]:
```

**Examples:**
- "Install Docker Compose?"
- "Add Portainer (web UI)?"
- "Install Portainer Agent (for remote management)?"
- "Expose Docker TCP socket?"

---

### "Enter [value]" Pattern

**Translation:**
```
[Field/Question]

Enter [value type] [description/constraint]:

[Example/Range]:
```

**Examples:**
- "Enter PostgreSQL version (15/16/17/18):"
- "Enter static IP address (e.g., 192.168.1.100):"
- "Enter disk size in GB:"

---

### "Select option" Pattern

**Translation:**
```
[Menu Title]

1. [Option 1] - [Description]
2. [Option 2] - [Description]
3. [Option 3] - [Description]

Select an option [1/2/3]:
```

**Examples:**
- Network type (DHCP/Static/IP Range)
- Storage selection
- Configuration mode (Default/Advanced/User Defaults)

---

## Handling User's "Default" vs "Advanced" Request

When user doesn't specify, LLM should ask:

```
Would you like to use Default settings or Advanced customization?

- Default = Use script's recommended settings (only ask script-specific prompts)
- Advanced = Customize all options (CPU, RAM, Disk, Network, Features)

Choose [Default/Advanced]:
```

**If Default:**
- Use script defaults for CPU/RAM/Disk
- Skip all 28 advanced settings questions
- Only ask script-specific interactive prompts

**If Advanced:**
- Ask all 28 advanced settings questions (see list above)
- Collect all values before execution
- Provide complete environment variable setup

---

## Special Cases

### Scripts with No Interactive Prompts

**Examples:** grafana.sh, postgresql.sh (some versions)

**Action:** No questions needed beyond container settings

```bash
# Just ask default vs advanced
var_cpu=1 var_ram=512 bash ct/grafana.sh
```

### Scripts with Many Prompts (e.g., docker.sh)

**Action:** Ask all script-specific questions before execution

```bash
# Questions to ask:
1. Install Docker Compose?
2. Add Portainer UI?
3. Add Portainer Agent?
4. Expose Docker TCP socket?

# Collect answers
# Execute with all answers provided
echo -e "n\nn\ny\nn" | var_cpu=2 var_ram=2048 bash ct/docker.sh
```

### Scripts with Version Selection

**Examples:** postgresql.sh

**Action:** Ask for specific version

```bash
# Question:
Which PostgreSQL version? (15/16/17/18)

# User response: 17

# Execute:
echo "17" | bash ct/postgresql.sh
```

---

## Best Practices

1. **Always show menu structure** - Help user understand their options
2. **Provide examples** - Show valid values when asking
3. **Accept abbreviations** - "Y", "N", "y", "n" for yes/no
4. **Validate input** - If user provides invalid value, ask again with clarification
5. **Be explicit about defaults** - Tell user what will happen if they choose default
6. **Group related questions** - Network questions together, storage questions together
7. **Show impact of choices** - Explain what GPU does, what FUSE enables
8. **For Advanced mode, consider 28 questions** - Can be overwhelming, offer to skip groups

---

## Next Steps

1. See `ui-mimicry.md` for detailed question formulation
2. See `non-interactive-mode.md` for environment variable reference
3. See script-specific context files for exact prompt text
