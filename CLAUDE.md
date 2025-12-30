# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

ProxmoxVE Helper-Scripts is a community-driven repository providing 300+ automation scripts for Proxmox Virtual Environment management. Originally created by tteck, now maintained by the community-scripts organization. The project consists of container (LXC) creation scripts, installation scripts, VM provisioning, a Next.js frontend, and a Go API backend.

## Repository Structure

```
ProxmoxVE/
├── ct/              # Container creation scripts (run on Proxmox host)
├── install/         # Installation scripts (run inside containers)
├── vm/              # Virtual machine provisioning scripts
├── turnkey/         # TurnKey Linux templates
├── misc/            # Function libraries (9 core libraries)
├── tools/           # Management utilities and add-ons
├── frontend/        # Next.js website (helper-scripts.com)
├── api/             # Go API backend for telemetry
├── docs/            # Comprehensive documentation
└── .github/         # CI/CD workflows
```

## Common Commands

### Testing Scripts

```bash
# Test a container creation script
bash ct/docker.sh

# Test with verbose output
VERBOSE=yes bash ct/docker.sh

# Test installation script (runs inside container automatically)
# The ct/ script will call the corresponding install/ script
```

### Frontend Development

```bash
cd frontend

# Install dependencies
bun install  # or npm install, yarn, pnpm

# Start development server
bun dev

# Build for production
bun run build

# Type checking
bun run typecheck

# Linting
bun run lint

# Format code
bun run format:write

# Deploy to GitHub Pages
bun run deploy
```

### API Development

```bash
cd api

# Install dependencies
go mod download

# Run the API server
go run main.go

# Build
go build -o api-server main.go
```

### CI/CD Testing

```bash
# Format check for shell scripts
.github/workflows/scripts/script_format.yml

# Test scripts in CI environment
.github/workflows/scripts/app-test/pr-create-lxc.sh
```

## Architecture

### Script Execution Flow

```
User runs ct/ script on Proxmox host
    ↓
ct/ script sources misc/build.func (container orchestration)
    ↓
build.func creates LXC container with specified OS/resources
    ↓
ct/ script downloads and executes corresponding install/ script INSIDE container
    ↓
install/ script sources misc/tools.func or misc/alpine-tools.func
    ↓
Installation completes and container is configured
```

### Key Patterns

1. **Container Scripts (ct/)**:
   - Run on Proxmox host
   - Source `misc/build.func` for container creation
   - Define variables: `APP`, `var_cpu`, `var_ram`, `var_disk`, `var_os`, `var_version`
   - Include `update_script()` function for updates
   - Call `start`, `build_container`, `description`

2. **Installation Scripts (install/)**:
   - Run inside the container
   - Source function library via: `source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"`
   - Use helper functions from `misc/tools.func` or `misc/alpine-tools.func`
   - Follow 10-phase pattern: setup → network → update → install → configure → cleanup
   - Use message functions: `msg_info`, `msg_ok`, `msg_error`

3. **Function Libraries (misc/)**:
   - `build.func`: Container orchestration, 7000+ lines
   - `tools.func`: Package installation helpers (Debian/Ubuntu)
   - `alpine-tools.func`: Package installation for Alpine
   - `core.func`: Utilities and messaging
   - `error_handler.func`: Error handling and exit codes
   - `install.func`: Container setup functions
   - `api.func`: Telemetry integration
   - `cloud-init.func`: VM provisioning

### Frontend Architecture

- **Framework**: Next.js 15.2.4 with App Router
- **Language**: TypeScript 5.8.2
- **Styling**: Tailwind CSS 3.4.17 + shadcn/ui components
- **State**: TanStack Query 5.71.1 for data fetching
- **Build**: Static export for GitHub Pages (`output: "export"`)
- **Base Path**: `/ProxmoxVE` for GitHub Pages deployment
- **Key Directories**:
  - `src/app/`: Next.js app router pages
  - `src/components/`: React components
  - `src/lib/`: Utilities and helpers
  - `public/json/`: Script metadata

### API Architecture

- **Language**: Go
- **Framework**: gorilla/mux for routing
- **Database**: MongoDB for telemetry data
- **Purpose**: Collects installation telemetry (optional, privacy-focused)
- **Endpoints**: Upload JSON data, query statistics

## Development Guidelines

### Template Files

The repository provides comprehensive templates in `docs/contribution/`:

- **Container template**: `docs/contribution/templates_ct/AppName.sh`
- **Install template**: `docs/contribution/templates_install/AppName-install.sh`
- **JSON template**: `docs/contribution/templates_json/AppName.json`

**Always use these templates** as your starting point - they include:
- Complete helper function reference with examples
- Proper error handling patterns
- Update script implementation
- Database setup examples (MariaDB, PostgreSQL)
- Runtime setup examples (Node.js, Python, PHP, Go, Rust)
- Service creation patterns

### Creating New Container Scripts

1. **Start with the template**: `cp docs/contribution/templates_ct/AppName.sh ct/myapp.sh`
2. Update the header with: shebang, source line, copyright, author, license, source URL
3. Set variables: `APP`, `var_tags`, `var_cpu`, `var_ram`, `var_disk`, `var_os`, `var_version`, `var_unprivileged`
4. Call standard functions: `header_info "$APP"`, `variables`, `color`, `catch_errors`
5. Implement `update_script()` function for post-installation updates (template includes example)
6. Call `start`, `build_container`, `description`
7. Add completion message with access URL if applicable

### Creating Installation Scripts

1. **Start with the template**: `cp docs/contribution/templates_install/AppName-install.sh install/myapp-install.sh`
2. Source functions: `source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"`
3. Initialize: `color`, `verb_ip6`, `catch_errors`, `setting_up_container`, `network_check`, `update_os`
4. **Use helper functions** (documented in template):
   - `NODE_VERSION="22" setup_nodejs` for Node.js apps
   - `PYTHON_VERSION="3.13" setup_uv` for Python apps
   - `setup_go` for Go apps
   - `setup_rust` for Rust apps
   - `PHP_VERSION="8.4" PHP_FPM="YES" PHP_MODULE="mysqli,gd" setup_php` for PHP
   - `setup_mariadb` and `MARIADB_DB_NAME="mydb" MARIADB_DB_USER="myuser" setup_mariadb_db` for databases
   - `fetch_and_deploy_gh_release "appname" "owner/repo"` for downloading from GitHub (preferred)
5. Configure application and create systemd services
6. Call `motd_ssh`, `customize`, `cleanup_lxc` at the end
7. Use `msg_info`, `msg_ok`, `msg_error` for user feedback
8. Use `$STD` prefix for silent command execution

### Function Library Usage

**Always use helper functions** from `misc/tools.func` or `misc/alpine-tools.func`:

- `install_nodejs <version>` - Install specific Node.js version
- `install_python <version>` - Install Python with pip
- `install_go <version>` - Install Go
- `install_rust` - Install Rust toolchain
- `prepare_repository_setup <tool>` - Clean and prepare repositories
- `install_packages_with_retry <packages...>` - Robust package installation
- `get_latest_release <repo>` - Get latest GitHub release tag

**Never manually install languages** - always use the provided helpers for consistency and reliability.

### Code Standards

1. **Shebang**: All scripts must start with `#!/usr/bin/env bash`
2. **Error Handling**: Use `catch_errors` function and proper exit codes
3. **Silent Execution**: Use `$STD` for non-critical commands
4. **Variables**: Use lowercase with underscores, except standard vars like `APP`
5. **Services**: Always create systemd service files for applications
6. **Cleanup**: Remove unnecessary packages and files before container completion
7. **Updates**: Include update logic in `update_script()` function
8. **Versioning**: Track and display installed versions

### Frontend Development

1. **Components**: Use functional components with TypeScript
2. **Styling**: Use Tailwind utility classes, mobile-first approach
3. **State**: Use TanStack Query for server state, nuqs for URL params
4. **Types**: Define proper TypeScript interfaces
5. **Images**: Use `unoptimized: true` for static export compatibility
6. **Paths**: Account for `/ProxmoxVE` base path in navigation
7. **Accessibility**: Follow WCAG guidelines, use semantic HTML
8. **Testing**: Write tests with Vitest and React Testing Library

## Testing

### Manual Testing

1. Test scripts on a Proxmox VE installation (versions 8.4.x, 9.0.x, or 9.1.x)
2. Verify container creation and application installation
3. Check update functionality via `update_script()`
4. Test on both privileged and unprivileged containers where applicable
5. Verify networking and IPv6 handling

### Frontend Testing

```bash
cd frontend
bun run typecheck  # Type safety
bun run lint       # Code quality
bun run build      # Production build test
```

### CI/CD

- GitHub Actions automatically test PRs
- Script formatting is validated
- Frontend deploys to GitHub Pages on main branch updates
- API deployments are manual

## Documentation

Comprehensive documentation is in the `docs/` directory:

- `docs/contribution/README.md` - Contribution guide
- `docs/ct/DETAILED_GUIDE.md` - Container script reference
- `docs/install/DETAILED_GUIDE.md` - Installation script reference
- `docs/TECHNICAL_REFERENCE.md` - Architecture deep-dive
- `docs/EXIT_CODES.md` - Exit code reference
- `docs/DEV_MODE.md` - Debugging guide
- `docs/misc/` - Function library documentation

## Common Patterns

### Retrieving Latest Version

```bash
get_latest_release() {
  curl -fsSL https://api.github.com/repos/"$1"/releases/latest | grep '"tag_name":' | cut -d'"' -f4
}

LATEST_VERSION=$(get_latest_release "owner/repo")
```

### Installing Node.js Application

```bash
# Use helper function instead of manual installation
install_nodejs 20

# Clone and setup
git clone https://github.com/user/app.git /opt/app
cd /opt/app
npm install --production

# Create systemd service
create_service "app" "node server.js" "/opt/app"
```

### Creating Systemd Service

```bash
cat <<EOF >/etc/systemd/system/myapp.service
[Unit]
Description=MyApp Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/node server.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now myapp
```

### Error Messages

```bash
msg_info "Installing application"
if ! install_application; then
  msg_error "Failed to install application"
  exit 1
fi
msg_ok "Installed application"
```

## Important Notes

- **Alpine vs Debian**: Separate function libraries and patterns
- **Unprivileged Containers**: Preferred for most applications (set `var_unprivileged=1`)
- **Resource Defaults**: Adjust `var_cpu`, `var_ram`, `var_disk` based on app requirements
- **IPv6**: Handle with `verb_ip6` and test both enabled/disabled scenarios
- **Telemetry**: API telemetry is optional and privacy-focused
- **Community**: Active Discord server and GitHub Discussions for support
- **Legacy**: Project continues in memory of original creator tteck

## File Naming Conventions

- Container scripts: `ct/appname.sh` (lowercase, hyphens for multi-word)
- Install scripts: `install/appname-install.sh` (matches container script name)
- Headers: `ct/headers/appname.sh` (application metadata)
- JSON: `frontend/public/json/appname.json` (metadata for website)
