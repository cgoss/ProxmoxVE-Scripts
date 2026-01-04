# Installation Patterns - Generic Methods

## Overview

This document provides generic installation patterns for creating ProxmoxVE Helper-Scripts, without referencing specific services.

---

## Pattern 1: APT Repository + Systemd

### Description

Install application from official APT repository, create systemd service for management.

### When to Use

- Service has official APT repository in Debian/Ubuntu
- Service provides proper systemd service files
- No custom compilation required
- Automatic updates via APT

### Implementation

**CT Script:**
```bash
APP="ServiceName"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-4}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -f /etc/apt/sources.list.d/service.list ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Updating ${APP} LXC"
  $STD apt-get update
  $STD apt-get -y upgrade
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
```

**Install Script:**
```bash
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing ServiceName"
$STD apt-get install -y packagename packagename2

cat > /etc/systemd/system/servicename.service <<EOF
[Unit]
Description=ServiceName
After=network.target

[Service]
Type=simple
User=servicename
WorkingDirectory=/opt/servicename
ExecStart=/usr/bin/servicename start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable -q --now servicename
msg_ok "Installed ServiceName"

motd_ssh
customize
cleanup_lxc
```

### Key Characteristics

- **Package Manager**: APT
- **Init System**: systemd
- **Installation**: APT packages
- **Updates**: Via APT
- **Service Management**: systemctl
- **Configuration**: /etc/application/config.d/

### Best Practices

1. Use `$STD` prefix for non-verbose package installation
2. Enable systemd service immediately after installation
3. Use proper dependency declarations
4. Configure logging and monitoring if applicable
5. Test service start before cleanup

---

## Pattern 2: GitHub Release Download

### Description

Download pre-compiled binary or archive from GitHub releases and deploy to container.

### When to Use

- Official GitHub releases available
- No compilation required
- Application provides tar.gz or binary builds
- Common for tools and single-binary applications

### Implementation

**CT Script:**
```bash
APP="ServiceName"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-4}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  # Get latest release
  LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/owner/repo/releases/latest | \
    grep '"tag_name":' | cut -d'"' -f4)

  # Compare with installed version
  CURRENT_VERSION=$(cat /opt/service/version.txt 2>/dev/null)

  if [[ "$LATEST_RELEASE" != "$CURRENT_VERSION" ]]; then
    msg_info "Updating ${APP} to ${LATEST_RELEASE}"
    $STD rm -rf /opt/service
    CLEAN_INSTALL=1 fetch_and_deploy_gh_release "service" "owner/repo" "tarball" "latest" "/opt/service"
    msg_ok "Updated successfully!"
  else
    msg_ok "No update required. Already at ${LATEST_RELEASE}"
  fi

  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
```

**Install Script:**
```bash
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing ServiceName"

# Download latest release
LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/owner/repo/releases/latest | \
  grep '"tag_name":' | cut -d'"' -f4)

# Download and extract
curl -fsSL "https://github.com/owner/repo/releases/download/${LATEST_RELEASE}/service-linux-amd64.tar.gz" \
  -o /tmp/service.tar.gz
tar -xzf /tmp/service.tar.gz -C /opt/

# Make executable
chmod +x /opt/service/service

# Create systemd service (if needed)
# (same as Pattern 1)

# Clean up
rm -f /tmp/service.tar.gz

msg_ok "Installed ServiceName ${LATEST_RELEASE}"

motd_ssh
customize
cleanup_lxc
```

### Key Characteristics

- **Package Manager**: None (pre-compiled)
- **Init System**: systemd (optional)
- **Installation**: GitHub releases
- **Updates**: Custom update_script() logic
- **Service Management**: systemctl (if service file exists)
- **Configuration**: /opt/service/config or environment variables

### Best Practices

1. Use `fetch_and_deploy_gh_release()` helper from tools.func
2. Implement proper version comparison
3. Backup configuration before upgrades
4. Verify checksums if provided
5. Test service functionality after update

---

## Pattern 3: Docker Compose Within LXC

### Description

Install Docker Engine, then use Docker Compose to deploy multi-container application.

### When to Use

- Application consists of multiple services
- Each service is a Docker container
- Services communicate via Docker networking
- Configuration managed via docker-compose.yml

### Implementation

**CT Script:**
```bash
APP="AppSuite"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-4096}"
var_disk="${var_disk:-8}"
var_nesting="${var_nesting:-1}"  # Required for Docker-in-LXC
var_gpu="${var_gpu:-no}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  # Update Docker Engine
  $STD apt-get update
  $STD apt-get --only-upgrade install -y docker-ce docker-ce-cli containerd.io

  # Update Docker Compose if installed
  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_BIN="/usr/local/lib/docker/cli-plugins/docker-compose"
    COMPOSE_LATEST=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | \
      grep '"tag_name":' | cut -d'"' -f4)

    CURRENT_VERSION=$(docker-compose --version 2>/dev/null)

    if [[ "$COMPOSE_LATEST" != "$CURRENT_VERSION" ]]; then
      msg_info "Updating Docker Compose to ${COMPOSE_LATEST}"
      curl -fsSL "https://github.com/docker/compose/releases/download/${COMPOSE_LATEST}/docker-compose-linux-x86_64" \
        -o "$COMPOSE_BIN"
      chmod +x "$COMPOSE_BIN"
      msg_ok "Updated Docker Compose"
    else
      msg_ok "Docker Compose already up to date"
    fi
  fi

  # Restart Docker to load new Compose
  systemctl restart docker
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
```

**Install Script:**
```bash
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Docker"
# Install Docker Engine
setup_docker

# Create app directory
mkdir -p /opt/appsuite

# Copy docker-compose.yml
cat > /opt/appsuite/docker-compose.yml <<EOF
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./data:/data

  database:
    image: postgres:15
    volumes:
      - dbdata:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=\${POSTGRES_PASSWORD:-}

  cache:
    image: redis:latest
    ports:
      - "6379:6379"
    volumes:
      - cache:/data
EOF

# Start services
docker-compose -f /opt/appsuite/docker-compose.yml up -d

msg_ok "Docker Compose application deployed"

motd_ssh
customize
cleanup_lxc
```

### Key Characteristics

- **Package Manager**: Docker
- **Init System**: Docker (manages services)
- **Installation**: Docker images from Docker Hub
- **Updates**: Separate updates for Docker and individual images
- **Service Management**: docker-compose, docker commands
- **Configuration**: docker-compose.yml, environment variables
- **Networking**: Docker bridge networks, volume mapping

### Best Practices

1. Use `setup_docker()` helper function for consistent installation
2. Create appropriate docker-compose.yml for application architecture
3. Use named volumes for data persistence
4. Use environment variables in docker-compose.yml for configuration
5. Separate concerns into different services
6. Expose only necessary ports to minimize attack surface
7. Use Docker healthchecks for critical services
8. Document docker-compose.yml structure for users

---

## Pattern 4: Single Binary Deployment

### Description

Download a pre-compiled binary from GitHub and create simple systemd service.

### When to Use

- Application is a single Go/Rust/Python executable
- No complex dependencies
- Simple to deploy and manage
- Provides CLI interface

### Implementation

**CT Script:**
```bash
APP="ToolName"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-512}"
var_disk="${var_disk:-2}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  # Get latest release
  LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/owner/repo/releases/latest | \
    grep '"tag_name":' | cut -d'"' -f4)

  # Compare with installed version
  if command -v /usr/local/bin/toolname --version >/dev/null 2>&1; then
    CURRENT_VERSION=$(/usr/local/bin/toolname --version)
  else
    CURRENT_VERSION="not installed"
  fi

  if [[ "$LATEST_RELEASE" != "$CURRENT_VERSION" ]]; then
    msg_info "Updating ${APP} to ${LATEST_RELEASE}"
    CLEAN_INSTALL=1 fetch_and_deploy_gh_release "toolname" "owner/repo" "binary" "latest" "/usr/local/bin"
    msg_ok "Updated successfully!"
  else
    msg_ok "Already at latest version"
  fi

  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
```

**Install Script:**
```bash
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing ToolName"

# Download binary
LATEST_RELEASE=$(curl -fsSL https://api.github.com/repos/owner/repo/releases/latest | \
  grep '"tag_name":' | cut -d'"' -f4)

# Download and deploy
CLEAN_INSTALL=1 fetch_and_deploy_gh_release "toolname" "owner/repo" "singlefile" "latest" "/usr/local/bin"

# Create systemd service
cat > /etc/systemd/system/toolname.service <<EOF
[Unit]
Description=ToolName
After=network.target

[Service]
Type=simple
User=toolname
ExecStart=/usr/local/bin/toolname start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable -q --now toolname

msg_ok "Installed ToolName"

motd_ssh
customize
cleanup_lxc
```

### Key Characteristics

- **Package Manager**: None (pre-compiled)
- **Init System**: systemd (simple service)
- **Installation**: Single binary file
- **Updates**: New binary download
- **Service Management**: systemctl
- **Configuration**: Command-line arguments or config file
- **Networking**: May bind ports or use sockets

### Best Practices

1. Use `fetch_and_deploy_gh_release()` helper with "singlefile" type
2. Verify binary checksums if available
3. Set proper permissions (chmod +x)
4. Create appropriate systemd service type (simple, forking, oneshot)
5. Use /usr/local/bin/ for self-contained tools
6. Consider adding man pages or documentation
7. Test binary execution with --help or --version flags

---

## Pattern 5: Source Build from GitHub

### Description

Clone repository from GitHub, compile from source, install application.

### When to Use

- No pre-compiled binary available
- Need custom configuration
- Want specific version or modifications
- Application has build dependencies

### Implementation

**CT Script:**
```bash
APP="CustomApp"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-8}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  # Pull latest changes
  cd /opt/customapp
  git pull

  # Check for update logic (compare tags/commits)
  # ... build and install logic ...

  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
```

**Install Script:**
```bash
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing CustomApp"

# Install build dependencies
$STD apt-get install -y build-essential git make

# Clone repository
git clone https://github.com/owner/customapp.git /opt/customapp

# Build
cd /opt/customapp
make install

# Create systemd service (if needed)
# ... (similar to Pattern 1)

msg_ok "Installed CustomApp"

motd_ssh
customize
cleanup_lxc
```

### Key Characteristics

- **Package Manager**: None (self-built)
- **Init System**: systemd (if service needed) or manual start
- **Installation**: make, configure, install
- **Updates**: git pull, rebuild, reinstall
- **Service Management**: make commands or systemctl
- **Configuration**: build flags, config files, environment variables
- **Networking**: Standard application networking

### Best Practices

1. Install all build dependencies consistently
2. Use make install rather than make for reproducible builds
3. Document build options if available
4. Run make check for configuration
5. Consider using checkinstall or similar tools
6. Keep source in /opt/appname for easy updates
7. Document update procedure for users
8. Test build artifacts before deployment

---

## Pattern 6: External Installer

### Description

Use third-party installation script provided by service vendor.

### When to Use

- Service provides official installation script
- No APT packages available
- Complex installation with vendor-specific configuration

### Implementation

**CT Script:**
```bash
APP="ExternalApp"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-8192}"  # Often high for external installers
var_disk="${var_disk:-30}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  msg_warn "WARNING: External installer will run"
  msg_warn "The following code is NOT maintained or audited by our repository."

  # Download and execute installer
  curl -fsSL "https://www.vendor.com/download/installer.sh" -o /tmp/installer.sh
  bash /tmp/installer.sh

  msg_ok "Installation completed"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
```

**Install Script:**
```bash
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing ExternalApp"

# Download external installer
curl -fsSL "https://www.vendor.com/download/installer.sh" -o /tmp/installer.sh
chmod +x /tmp/installer.sh

# Run installer (with confirmation prompt)
read -r -p "${TAB3}Do you want to continue? [y/N]: " CONFIRM
if [[ ! "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  msg_error "Installation aborted by user"
  exit 10
fi

bash /tmp/installer.sh

msg_ok "ExternalApp installation completed"

motd_ssh
customize
cleanup_lxc
```

### Key Characteristics

- **Package Manager**: External installer
- **Init System**: Vendor-specific (may be systemd, init.d, or custom)
- **Installation**: External installer script
- **Updates**: Re-run external installer or built-in update mechanism
- **Service Management**: Vendor-specific
- **Configuration**: Installer prompts, vendor config files
- **Networking**: May configure specific ports, protocols

### Best Practices

1. Always display warning about external code not being audited
2. Test installer in safe environment first
3. Document installer behavior for users
4. Capture installer output for troubleshooting
5. Consider creating wrapper script to manage external installation
6. Provide clear instructions for updates and removal
7. Verify installer integrity before execution (checksums, signatures)
8. Document all installer prompts and their default values

---

## Decision Framework

### Choosing the Right Pattern

```
Service Requirements Analysis
         ↓
    Does it have APT packages?
    ↓ Yes            No
    ↓                 ↓
Use APT          Check:           Check:
Pattern 1?     - Native support   - GitHub releases
                 - Debian         - Pre-compiled
                 - Stable version - Official binary
    ↓                 ↓
    Is it single binary?
    ↓ Yes            No
    ↓                 ↓
Use GitHub          Check:           Check:
Release Pattern?  - Docker Compose  - APT + systemd
                 - Multi-tier app - Source build
    ↓                 ↓
    Is it a complex
    ↓ No             Yes
    ↓                 ↓
                    Use External
                    Installer
```

### Quick Reference

| Pattern | Complexity | Update Mechanism | Resource Needs | Use When |
|---------|-------------|----------------|--------------|-----------|
| APT + Systemd | Low | APT upgrade | Minimal | Native apps with simple deps |
| GitHub Release | Medium | Custom update_script() | Low-Medium | Tools, CLI apps, some servers |
| Docker Compose | Medium-High | Separate updates | Moderate-High | Multi-tier apps |
| Single Binary | Medium | Custom update_script() | Low-Medium | CLI tools, some servers |
| Source Build | High | git pull + rebuild | High | Custom/modded apps |
| External Installer | Very High | External installer | Very High | Complex vendor apps |

---

## Best Practices Across All Patterns

1. **Use helper functions** - Always prefer `fetch_and_deploy_gh_release()`, `setup_docker`, database setup functions
2. **Implement update_script()** - All patterns should have update mechanism
3. **Clean up properly** - Remove temporary files, install with cleanup_lxc
4. **Service management** - Use systemctl for all patterns except Docker Compose (use docker-compose directly)
5. **Version tracking** - Store version in file for comparison (/opt/app/version.txt)
6. **Error handling** - Use try/catch, check command exits, provide clear error messages
7. **Logging** - Use application's built-in logging if available
8. **Testing** - Verify service is running, accessible, functional before reporting success
9. **Documentation** - Comment complex installation steps, explain configuration
10. **Resource monitoring** - Be aware of application's resource usage during operation

---

## Next Steps

1. **Use service analysis** from `dependency-analysis.md` to identify appropriate pattern
2. **Choose OS** using `os-selection.md` decision tree
3. **Plan resources** using `resource-planning.md` guidelines
4. **Follow pattern implementation** from this document
5. **Use templates** from `template-guide.md` as starting point
6. **Test thoroughly** - Verify installation and update procedures
