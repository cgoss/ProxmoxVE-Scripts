# Template Guide - Using Templates Effectively

## Overview

This document explains how to use ProxmoxVE Helper-Scripts templates to create new services.

---

## Available Templates

### CT Script Template
**Location:** `docs/contribution/templates_ct/AppName.sh`

**Purpose:** Container creation with proper header, variables, and update logic

**When to Use:**
- Creating any new LXC container
- Need standard container setup
- Application provides service via web interface or CLI

### Install Script Template
**Location:** `docs/contribution/templates_install/AppName-install.sh`

**Purpose:** Application installation inside container with proper setup and service configuration

**When to Use:**
- Installing any application inside LXC
- Need service configuration
- May need dependencies, database, or runtime setup

---

## Template Structure

### CT Script Template Anatomy

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

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -d /opt/[appname] ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  # Update logic here
  # ... (implement update logic)

  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
```

**Key Sections:**
1. **Shebang & Source**: Required
2. **Comments**: Copyright, Author, License, Source
3. **Variables**: APP, var_tags, CPU, RAM, Disk, OS, Version, Unprivileged
4. **Function Calls**: header_info, variables, color, catch_errors
5. **update_script()**: Check for installation, update logic, exit
6. **Execution**: start, build_container, description

### Install Script Template Anatomy

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

msg_info "Installing Dependencies"
$STD apt-get install -y dependency1 dependency2 ...

msg_info "Configuring [AppName]"
# Configuration logic here

msg_info "Creating Systemd Service"
cat > /etc/systemd/system/[appname].service <<EOF
[Unit]
Description=[AppName]
After=network.target

[Service]
Type=simple
User=root
ExecStart=/opt/[appname]/[appname] start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable -q --now [appname]

msg_info "Enabling and Starting [AppName]"
systemctl enable -q --now [appname]

motd_ssh
customize
cleanup_lxc
```

**Key Sections:**
1. **Source & Initial Calls**: Source install.func, set up container
2. **Dependency Installation**: Use $STD prefix, install all at once
3. **Configuration**: Create config files, set up environment
4. **Service Creation**: Create systemd service file
5. **Service Management**: Enable and start service
6. **Cleanup**: motd_ssh, customize, cleanup_lxc

---

## Customizing Templates

### Customizing CT Script Variables

**APP Name**
```bash
# Set the application display name
APP="MyCustomService"
```

**var_tags**
```bash
# Max 2 tags, semicolon-separated
var_tags="${var_tags:-category1;category2}"
```

**var_cpu**
```bash
# Set CPU cores (typically 1-4)
var_cpu="${var_cpu:-2}"
```

**var_ram**
```bash
# Set RAM in MB (512, 1024, 2048, 4096, 8192)
var_ram="${var_ram:-2048}"
```

**var_disk**
```bash
# Set disk size in GB
var_disk="${var_disk:-4}"
```

**var_os**
```bash
# debian (default), ubuntu, alpine
var_os="${var_os:-debian}"
```

**var_version**
```bash
# Debian 12/13, Ubuntu 22.04/24.04, Alpine 3.20/3.21/3.22
var_version="${var_version:-12}"
```

**var_unprivileged**
```bash
# 1 = unprivileged (default, recommended)
# 0 = privileged (for Docker, GPU passthrough)
var_unprivileged="${var_unprivileged:-1}"
```

**Special Variables (as needed)**
```bash
# GPU passthrough
var_gpu="${var_gpu:-no}"

# FUSE support
var_fuse="${var_fuse:-no}"

# TUN/TAP support
var_tun="${var_tun:-no}"

# LXC nesting
var_nesting="${var_nesting:-1}"
```

---

## Implementing update_script()

### Pattern 1: GitHub Release Download

```bash
function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -d /opt/$APP ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  # Get latest release version
  LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/owner/repo/releases/latest | \
    grep '"tag_name":' | cut -d'"' -f4)

  # Compare with installed version
  CURRENT_VERSION=$(cat /opt/$APP/version.txt 2>/dev/null)

  if [[ "$LATEST_RELEASE" != "$CURRENT_VERSION" ]]; then
    msg_info "Updating ${APP} to ${LATEST_RELEASE}"
    # Stop service
    systemctl stop $APP
    # Backup data
    cp /opt/$APP/config.ini /tmp/$APP-backup.ini
    # Download new version
    CLEAN_INSTALL=1 fetch_and_deploy_gh_release "$APP" "owner/repo" "tarball" "latest" "/opt/$APP"
    # Restore configuration
    cp /tmp/$APP-backup.ini /opt/$APP/config.ini
    # Start service
    systemctl start $APP
    msg_ok "Updated successfully!"
  else
    msg_ok "No update required. Already at ${LATEST_RELEASE}"
  fi

  exit
}
```

### Pattern 2: APT Repository Update

```bash
function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if ! dpkg -s "$APP" >/dev/null 2>&1; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Updating ${APP} LXC"
  $STD apt-get update
  $STD apt-get --only-upgrade install -y "$APP"
  msg_ok "Updated successfully!"
  exit
}
```

### Pattern 3: Docker Images

```bash
function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if ! command -v docker >/dev/null 2>&1; then
    msg_error "Docker not installed"
    exit
  fi

  msg_info "Updating Docker images"
  docker pull "$APP:$VERSION"
  docker pull "portainer/portainer-ce:latest"

  if [ $? -eq 0 ]; then
    msg_ok "Docker images updated successfully!"
  else
    msg_error "Failed to update Docker images"
  fi

  exit
}
```

### Pattern 4: Custom Application

```bash
function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -f /opt/$APP/app ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  APP_VERSION=$(/opt/$APP/app --version)

  # Custom update logic
  cd /opt/$APP
  git pull
  make build
  make install

  msg_ok "Updated ${APP} to $(/opt/$APP/app --version)"
  exit
}
```

---

## Using Helper Functions

### Database Setup

```bash
# PostgreSQL
PG_VERSION=15 setup_postgresql

# MariaDB
setup_mariadb

# MySQL
# (No specific helper, use apt-get install)

# MongoDB
setup_mongodb

# Redis
setup_redis
```

### Language Runtime Setup

```bash
# Node.js
setup_nodejs

# Python
setup_uv  # Recommended modern setup

# Go
# No specific helper, ensure in PATH or install manually

# Rust
setup_rust

# Java
setup_java
```

### Docker Setup

```bash
# Docker Engine
setup_docker

# Docker Compose
$STD apt-get install -y docker-compose-plugin
```

---

## Common Modifications

### Adding Alpine Variant

1. Copy template to `ct/alpine-appname.sh`
2. Change OS to alpine:
   ```bash
   var_os="${var_os:-alpine}"
   var_version="${var_version:-3.20}"
   ```
3. Adjust resources (Alpine typically needs less):
   ```bash
   var_cpu="${var_cpu:-1}"  # Can often reduce
   var_ram="${var_ram:-512}"  # Saves 200-400MB
   ```
4. Test with `bash ct/alpine-appname.sh`

### Adding GPU Support

1. Add variable to CT script:
   ```bash
   var_gpu="${var_gpu:-yes}"
   ```
2. Ensure var_unprivileged=0 if GPU passthrough needed
3. Add FUSE support if needed:
   ```bash
   var_fuse="${var_fuse:-yes}"
   ```

### Adding Storage Configuration

1. Add storage prompts to install script:
   ```bash
   read -r -p "${TAB3}Which storage drive? [local/local-lvm/nas]: " STORAGE
   echo $STORAGE > /opt/$APP/.storage-location
   ```

2. Use storage in configuration

---

## Best Practices

### Do's and Don'ts

**DO:**
1. **Always start from template** - Copy template file directly
2. **Use helper functions** - Don't reinvent existing functions
3. **Follow variable naming** - Use APP, var_tags, var_cpu, etc.
4. **Implement update_script()** - Check for updates, logic, exit
5. **Use message functions** - msg_info, msg_ok, msg_error
6. **Test thoroughly** - Verify container creation, service start
7. **Document custom logic** - Comment complex operations
8. **Check existing scripts** - Look at similar services for patterns
9. **Consider resource needs** - Adjust defaults based on service type
10. **Use proper exit codes** - Exit with error on failure

**DON'T:**
1. **Don't modify template header** - Keep exact format
2. **Don't remove required sections** - Keep all variables, function calls
3. **Don't hardcode paths** - Use /opt/$APP convention
4. **Don't skip update_script()** - All scripts need this function
5. **Don't use sudo inside container** - Install scripts run as root
6. **Don't forget cleanup_lxc** - Always call at end of install script
7. **Don't hardcode versions** - Use variables for flexibility
8. **Don't ignore errors** - Use proper error handling

---

## Testing Templates

### Test CT Script

```bash
# Test locally (dry run)
bash -n ct/myapp.sh

# Test with verbose mode
VERBOSE=yes bash ct/myapp.sh

# Test with specific settings
var_cpu=4 var_ram=8192 bash ct/myapp.sh
```

### Test Install Script

Test via CT script:
```bash
# CT script will execute install script
bash ct/myapp.sh
```

Test inside container:
```bash
# Enter container after creation
pct enter <ctid>

# Check installation
ls /opt/myapp

# Check service status
systemctl status myapp

# View logs
journalctl -u myapp -n 50

# Test application functionality
/opt/myapp/app --help
```

---

## Common Template Errors

### Syntax Errors

**Missing Source Line:**
- Ensure CT script sources build.func
- Ensure install script sources install.func

**Missing Variables:**
- APP variable not defined
- Required var_* variables missing

**Function Call Errors:**
- header_info not called before variables
- start not called before build_container

**Install Script Errors:**
- Source line missing or incorrect
- Function calls before source statement
- motd_ssh or cleanup_lxc not called

---

## Next Steps

1. **Choose appropriate template** - CT or install based on service type
2. **Customize only what's necessary** - Don't over-modify templates
3. **Use helper functions** - Leverage tools.func functions
4. **Implement update_script()** - Essential for maintenance
5. **Test thoroughly** - Verify installation and service startup
6. **Document your changes** - Explain why templates were modified
7. **Check existing scripts** - Learn from similar implementations
8. **Follow patterns** - Match repository conventions and style
