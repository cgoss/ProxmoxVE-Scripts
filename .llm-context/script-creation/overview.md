# Script Creation - Overview

## Overview

This document provides a comprehensive overview of creating new ProxmoxVE Helper-Scripts for LLM agents.

---

## Script Types

There are two types of scripts in ProxmoxVE Helper-Scripts repository:

### CT Script (`ct/appname.sh`)
**Purpose:** Container creation and configuration
**Location:** `ct/` directory
**Responsibilities:**
- Define container resources (CPU, RAM, disk, OS)
- Handle user interaction (advanced settings wizard)
- Call build_container() to create LXC container
- Push install script into container
- Execute install script inside container
- Provide update_script() function

**Example:** `ct/docker.sh`

### Install Script (`install/appname-install.sh`)
**Purpose:** Application installation inside container
**Location:** `install/` directory
**Responsibilities:**
- Source ProxmoxVE helper functions
- Check and configure network
- Update operating system
- Install application dependencies
- Configure application
- Create systemd service
- Set up credentials and access

**Example:** `install/docker-install.sh`

---

## Script Anatomy

### CT Script Structure

```bash
#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: [YourUsername]
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: [SOURCE_URL]

APP="[AppName]"
var_tags="${var_tags:-[category]}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-4}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"
# Additional vars as needed (var_gpu, var_fuse, var_tun, etc.)

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  # Check for existing installation
  if [[ ! -d /opt/appname ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  # Update logic here
  # ...
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:PORT${CL}"
```

### Install Script Structure

```bash
#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: [YourUsername]
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: [SOURCE_URL]

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

# Installation logic here
# Install dependencies
# Configure application
# Create service
# ...

motd_ssh
customize
cleanup_lxc
```

---

## Execution Flow

### CT Script Execution Flow

```
User runs: bash ct/appname.sh
    ↓
Source build.func
    ↓
Initialize variables
    ↓
Display header
    ↓
Call variables() - Set NSAPP, defaults, etc.
    ↓
Call color() - Set up colors
    ↓
Call catch_errors() - Set error handling
    ↓
Call start() - Main entry point
    ↓
Show menu (if no CLI args)
    ↓
Collect settings (default/advanced/user/app)
    ↓
Call build_container() - Create LXC container
    ↓
Push install script to /tmp/
    ↓
Execute install script inside container
    ↓
Show success message
    ↓
Call update_script() - If requested
    ↓
Exit
```

### Install Script Execution Flow

```
CT script calls install script
    ↓
Source install.func
    ↓
Call setting_up_container()
    ↓
Call network_check()
    ↓
Call update_os()
    ↓
Install dependencies
    ↓
Configure application
    ↓
Create systemd service
    ↓
Enable and start service
    ↓
Call motd_ssh()
    ↓
Call customize()
    ↓
Call cleanup_lxc()
    ↓
Exit with success
```

---

## Required Sections

### CT Script Must Include

1. **Shebang**: `#!/usr/bin/env bash`
2. **Source Line**: `source <(curl -fsSL ...)`
3. **Copyright Comment**: With year, author, license
4. **Source URL**: Official documentation URL
5. **APP Variable**: Application display name
6. **var_tags**: Category tags (semicolon-separated, max 2)
7. **var_cpu**: Default CPU cores (number)
8. **var_ram**: Default RAM in MB (number)
9. **var_disk**: Default disk in GB (number)
10. **var_os**: Default OS (debian/ubuntu/alpine)
11. **var_version**: OS version
12. **var_unprivileged**: Container security type (0 or 1)
13. **Special Variables**: As needed (var_gpu, var_fuse, var_tun, etc.)
14. **Function Calls**: header_info, variables, color, catch_errors
15. **update_script()**: Update logic with exit

### Install Script Must Include

1. **Shebang**: `#!/usr/bin/env bash`
2. **Copyright Comment**: With year, author, license
3. **Source URL**: Official documentation URL
4. **Function Calls**: color, verb_ip6, catch_errors, setting_up_container, network_check, update_os
5. **Installation Logic**: Dependencies, configuration, service creation
6. **Cleanup**: motd_ssh, customize, cleanup_lxc

---

## Key Functions

### From build.func (CT Script)

**variables()**: Initialize all core variables
**start()**: Entry point for menu system
**build_container()**: Create LXC container with resources
**description()**: Show script description
**header_info()**: Display colored header
**color()**: Set up color variables
**catch_errors()**: Set up error handling

### From install.func (Install Script)

**setting_up_container()**: Verify network and container
**network_check()**: Check IPv4/IPv6 connectivity and DNS
**update_os()**: Run apt-get update/upgrade
**motd_ssh()**: Configure MOTD banner and SSH
**customize()**: Auto-login setup, SSH key injection
**cleanup_lxc()**: Remove temporary files and clean up packages

### From tools.func (Helper Functions)

**setup_postgresql**, **setup_mariadb**, **setup_mysql**, **setup_mongodb**: Database setup
**setup_nodejs**, **setup_uv**: Python/Node.js setup
**setup_go**, **setup_rust**, **setup_ruby**, **setup_java**: Language runtime setup
**setup_php**, **setup_composer**: PHP setup
**setup_docker**: Docker Engine setup
**fetch_and_deploy_gh_release**: Download from GitHub releases
**check_for_gh_release**: Check for updates
**ensure_dependencies**: Install packages with retry

---

## Variable Naming Conventions

### CT Script Variables

```bash
# Constants (uppercase)
APP="Docker"
NSAPP=$(echo "${APP,,}" | tr -d ' ')

# Environment variables (var_*)
var_cpu=2
var_ram=2048
var_disk=4
var_os=debian
var_version=12
var_unprivileged=1

# Local variables (lowercase)
app_version=""
install_dir=""
```

### Install Script Variables

```bash
# Constants (uppercase)
DB_NAME="appdb"
DB_USER="appuser"
DB_PASS=""
SERVICE_PORT="8080"
APP_DIR="/opt/appname"

# Local variables (lowercase)
db_host=""
db_port=""
```

---

## Templates

### Using Templates

Templates provide consistent starting points:

1. **CT Template**: `docs/contribution/templates_ct/AppName.sh`
   - Copy to `ct/appname.sh`
   - Fill in APP name, tags, defaults
   - Implement update_script()
   - Test with bash ct/appname.sh

2. **Install Template**: `docs/contribution/templates_install/AppName-install.sh`
   - Copy to `install/appname-install.sh`
   - Add installation logic
   - Add service configuration
   - Test with CT script

**Always start with templates** - Don't create from scratch

---

## Common Patterns

### Simple Application (Minimal Dependencies)

**CT Script:**
```bash
APP="SimpleApp"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-2}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"
```

**Install Script:**
```bash
msg_info "Installing SimpleApp"
$STD apt-get install -y simpleapp
msg_ok "Installed SimpleApp"
```

### Database Application

**CT Script:**
```bash
APP="DatabaseApp"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-1024}"
var_disk="${var_disk:-4}"
var_tags="${var_tags:-database}"
```

**Install Script:**
```bash
# Use helper function
setup_postgresql
# Or setup_mariadb, setup_mysql, setup_mongodb
```

### Web Application with Database

**CT Script:**
```bash
APP="WebApp"
var_tags="${var_tags:-web;database}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-8}"
```

**Install Script:**
```bash
# Install web server and database
$STD apt-get install -y nginx php-fpm

# Install and configure database
PG_VERSION=16 setup_postgresql

# Install application
curl -fsSL https://github.com/user/app/releases/latest/download \
  -o /opt/webapp/app.tar.gz

# Configure
cat > /etc/nginx/sites-available/webapp.conf <<EOF
server {
  listen 80;
  root /opt/webapp/public;
  index index.php;
  location ~ \.php$ {
    include fastcgi_params;
    fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
  }
}
EOF

# Create service
cat > /etc/systemd/system/webapp.service <<EOF
[Unit]
Description=WebApp
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/webapp
ExecStart=/usr/sbin/nginx -g daemon off;
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable -q --now webapp
```

### Service from GitHub Release

**Install Script:**
```bash
# Get latest release version
LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/user/repo/releases/latest | grep '"tag_name":' | cut -d'"' -f4)

# Download and deploy
CLEAN_INSTALL=1 fetch_and_deploy_gh_release "appname" "user/repo" "tarball" "latest" "/opt/appname"

# Create systemd service
cat > /etc/systemd/system/appname.service <<EOF
[Unit]
Description=App
After=network.target

[Service]
Type=simple
User=appname
WorkingDirectory=/opt/appname
ExecStart=/opt/appname/appname start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable -q --now appname

msg_ok "Installed App ${LATEST_RELEASE}"
```

---

## Best Practices

### CT Script Best Practices

1. **Always use correct header format** - Follow templates exactly
2. **Set reasonable defaults** - CPU: 1-2, RAM: 512-4096MB, Disk: 2-10GB
3. **Use proper OS selection** - Debian for default, Ubuntu for latest, Alpine for minimal
4. **Include var_tags** - Max 2 tags, semicolon-separated
5. **Implement update_script()** - Check for existing installation, update logic, exit
6. **Use APP for display** - Capitalized, no spaces in default

### Install Script Best Practices

1. **Source install.func** - Always required first line
2. **Use helper functions** - Don't reinvent wheels (setup_postgresql, setup_docker, etc.)
3. **Use $STD prefix** - Suppress command output
4. **Use message functions** - msg_info, msg_ok, msg_error
5. **Create systemd services** - Don't use init scripts
6. **Handle errors gracefully** - Check for package failures
7. **Clean up properly** - motd_ssh, customize, cleanup_lxc must be called
8. **Install in /opt/** - Standard location for applications
9. **Generate secure passwords** - Use random passwords, never hardcode
10. **Set proper permissions** - Only what's needed, no world-readable secrets

---

## Testing

### Test CT Script

```bash
# Test script locally
bash -n ct/appname.sh

# Test with specific settings
var_cpu=2 var_ram=2048 bash ct/appname.sh

# Test verbose mode
VERBOSE=yes bash ct/appname.sh
```

### Test Install Script

```bash
# CT script will execute install script
# Test from Proxmox host before running in production
```

---

## Next Steps

1. **Research methodology** - See `research-methodology.md`
2. **Dependency analysis** - See `dependency-analysis.md`
3. **Resource planning** - See `resource-planning.md`
4. **OS selection** - See `os-selection.md`
5. **Installation patterns** - See `installation-patterns.md`
6. **Templates** - See `template-guide.md`
7. **Testing** - See `testing-validation.md`
8. **Best practices** - See `best-practices.md`
