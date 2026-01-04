# Testing Validation - Script Testing Procedures

## Overview

This document provides comprehensive testing procedures for ProxmoxVE Helper-Scripts.

---

## Testing Philosophy

### Testing Levels

**1. Syntax Testing** (Before Execution)
- Check shebang format
- Validate header structure
- Verify required variables are present
- Check function syntax

**2. Logic Testing** (Dry Run)
- Run with VERBOSE=yes to see all commands
- Check conditional logic without executing
- Validate error handling paths

**3. Integration Testing** (Full Script Run)
- Test container creation
- Test installation script execution
- Verify service startup
- Test update_script() function

**4. Functionality Testing** (Application)
- Verify service is accessible
- Test configuration loading
- Test data persistence
- Test backup/restore operations
- Test update mechanism

---

## Testing Environment

### Test Node (Proxmox Host)

```bash
# Check Proxmox VE version
pveversion
# Should be 8.0-9.1

# Check available resources
pvesm status
free -h
lscpu
```

### Test Container Environment

```bash
# Enter test container
pct enter <ctid> bash

# Check container OS
cat /etc/os-release
hostname -I

# Check available resources
free -h
lscpu

# Verify network
ping -c 1 8.8.8.8
```

---

## CT Script Testing Procedures

### Phase 1: Syntax Validation

#### Test 1: Shebang Format
```bash
# Verify shebang
head -1 ct/appname.sh

# Expected: #!/usr/bin/env bash
```

#### Test 2: Header Structure
```bash
# Check header exists and has 7 lines
sed -n '1,7p' ct/appname.sh
```

**Expected structure:**
```bash
Line 1: #!/usr/bin/env bash
Line 2: source <(curl -fsSL ...)
Line 3: # Copyright (c) 2021-2025 community-scripts ORG
Line 4: # Author: [YourUsername]
Line 5: # License: MIT | https://github.com/...
Line 6: # Source: [SOURCE_URL]
Line 7: (empty line)
```

#### Test 3: Required Variables
```bash
# Check all required variables are defined
grep -E "^APP=|^var_tags=|^var_cpu=|^var_ram=|^var_disk=|^var_os=|^var_version=|^var_unprivileged" ct/appname.sh
```

**Variables must be defined.**

#### Test 4: Function Calls
```bash
# Check function calls are in correct order
grep -E "^header_info\(\)|^variables\(\)|^color\(\)|^catch_errors\(\)|^function update_script\(\)|^start\(\)|^build_container\(\)|^description" ct/appname.sh
```

**Required order:** header_info → variables → color → catch_errors → update_script() → start → build_container → description

#### Test 5: Function Syntax
```bash
# Check bash syntax without executing
bash -n ct/appname.sh
```

---

### Phase 2: Local Testing

#### Test 6: Variable Initialization
```bash
# Test variables function
# Create test script
cat > /tmp/test-variables.sh << 'EOF'
#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
APP="Test"
header_info "$APP"
variables
echo "APP: $APP"
echo "NSAPP: $NSAPP"
echo "var_cpu: $var_cpu"
echo "var_ram: $var_ram"
echo "var_disk: $var_disk"
EOF

chmod +x /tmp/test-variables.sh
bash /tmp/test-variables.sh
```

#### Test 7: Advanced Settings Wizard (if applicable)

```bash
# Test advanced_settings function
# Create script with all special variables
cat > /tmp/test-advanced.sh << 'EOF'
#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
APP="Test"
var_gpu="yes"
var_fuse="yes"
var_tun="yes"
var_nesting="1"
header_info "$APP"
variables
color
catch_errors
echo "GPU: $var_gpu"
echo "FUSE: $var_fuse"
echo "TUN: $var_tun"
echo "Nesting: $var_nesting"
EOF

chmod +x /tmp/test-advanced.sh
bash /tmp/test-advanced.sh
```

---

## Install Script Testing Procedures

### Phase 1: Syntax Validation

#### Test 8: Header Structure
```bash
# Check install script header
head -10 install/appname-install.sh
```

**Expected structure:**
```bash
Line 1: #!/usr/bin/env bash
Line 2: (empty)
Line 3: # Copyright (c) 2021-2025 community-scripts ORG
Line 4: # Author: [YourUsername]
Line 5: # License: MIT | ...
Line 6: # Source: [SOURCE_URL]
Line 7: (empty)
Line 8: source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
Line 9: color
Line 10: verb_ip6
Line 11: catch_errors
Line 12: setting_up_container
Line 13: network_check
Line 14: update_os
```

#### Test 9: Function Calls Order
```bash
# Check install script calls functions in correct order
grep -E "^(color|verb_ip6|catch_errors|setting_up_container|network_check|update_os)" install/appname-install.sh
```

**Required order:** color → verb_ip6 → catch_errors → setting_up_container → network_check → update_os

---

### Phase 2: Logic Validation

#### Test 10: Dependency Check
```bash
# Test script checks for dependencies before installing
# Create test script with dependencies
cat > /tmp/test-deps.sh << 'EOF'
#!/usr/bin/env bash
source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors

check_dependencies() {
  if ! command -v postgresql >/dev/null 2>&1; then
    msg_error "PostgreSQL not installed"
    exit 1
  fi
  msg_ok "All dependencies available"
}

check_dependencies
EOF

chmod +x /tmp/test-deps.sh
bash /tmp/test-deps.sh
```

---

## Integration Testing Procedures

### Test 11: Full Script Execution

#### Step 1: Create Test Container

```bash
# Create test container with minimal resources
var_cpu=1 var_ram=512 var_disk=2 bash ct/test-appname.sh

# Verify container created
pct list | grep test-appname
```

#### Step 2: Verify Installation

```bash
# Enter container and verify installation
pct enter <ctid> bash

# Check app directory
pct exec <ctid> ls -la /opt/appname

# Check service status
pct exec <ctid> systemctl status appname

# Check logs
pct exec <ctid> journalctl -u appname -n 20
```

#### Step 3: Test Service Functionality

```bash
# Test application access
pct exec <ctid> curl -s http://localhost:PORT
# Test API endpoints
pct exec <ctid> /opt/appname/app --help
```

#### Step 4: Test update_script() Function

```bash
# Update container first time
var_cpu=2 var_ram=2048 var_disk=4 bash ct/test-appname.sh

# Enter container and run update
pct enter <ctid> bash -c "/usr/bin/update"

# Check for update
pct exec <ctid> cat /opt/appname/version.txt

# Run update again
pct enter <ctid> bash -c "/usr/bin/update"

# Verify no errors
```

#### Step 5: Cleanup

```bash
# Stop and remove test container
pct stop <ctid>
pct destroy <ctid>
```

---

## Validation Checklist

### CT Script Validation

- [ ] Shebang format correct (#!/usr/bin/env bash)
- [ ] Source line present and correct
- [ ] Copyright comment with correct year and author
- [ ] Source URL present
- [ ] APP variable defined
- [ ] All var_* variables defined with defaults
- [ ] update_script() function present
- [ ] Function calls in correct order
- [ ] start() function called
- [ ] build_container() function called
- [ ] description() function called
- [ ] No syntax errors (bash -n check passes)
- [ ] Variables initialized correctly (APP, NSAPP, etc.)

### Install Script Validation

- [ ] Shebang format correct
- [ ] Copyright comment with correct year and author
- [ ] Source URL present
- [ ] Source line correct (source /dev/stdin <<<"$FUNCTIONS_FILE_PATH")
- [ ] Function calls in correct order
- [ ] setting_up_container called
- [ ] network_check called
- [ ] update_os called
- [ ] motd_ssh called
- [ ] customize called
- [ ] cleanup_lxc called
- [ ] No syntax errors (bash -n check passes)
- [ ] All helper functions used correctly ($STD, msg_info, etc.)

### Integration Validation

- [ ] Container creates successfully
- [ ] Install script executes without errors
- [ ] Service starts successfully
- [ ] Service is accessible on correct port
- [ ] Data persists correctly
- [ ] update_script() function works
- [ ] Container cleanup works
- [ ] No resource exhaustion errors

---

## Testing Tools & Commands

### Diagnostic Commands

#### Container Information
```bash
# List all containers
pct list

# Show container details
pct config <ctid>

# Show container resources
pct resources <ctid>

# Show container status
pct status <ctid>
```

#### Container Management
```bash
# Stop container
pct stop <ctid>

# Start container
pct start <ctid>

# Restart container
pct restart <ctid>

# Enter container
pct enter <ctid> bash

# Execute command in container
pct exec <ctid> <command>

# Run in container with specific user
pct exec <ctid> -u www-data bash

# View console
pct console <ctid>

# Monitor resources
pct top <ctid>

# List running processes
pct exec <ctid> ps aux
```

#### Resource Monitoring
```bash
# Check memory usage
pct exec <ctid> free -h

# Check disk usage
pct exec <ctid> df -h

# Check CPU usage
pct exec <ctid> top -n 1
```

---

## Debugging Mode

### Using VERBOSE=yes

```bash
# Enable verbose output
VERBOSE=yes bash ct/appname.sh

# This shows:
# - All APT commands
# - All file operations
# - Service status changes
# - Error messages
```

### Capturing Output

```bash
# Save script output to file
bash ct/appname.sh 2>&1 | tee /tmp/script-output.log

# Save install script output
pct exec <ctid> bash /path/to/install-script.sh 2>&1 | tee /tmp/install-output.log

# View logs
cat /tmp/script-output.log
cat /tmp/install-output.log
```

---

## Common Issues and Solutions

### Issue 1: Container Won't Start

**Symptoms:**
- pct status shows status: stopped
- Container exits immediately after creation

**Solutions:**
1. Check container logs: `pct exec <ctid> journalctl -n 20`
2. Check OS compatibility: Ensure script OS matches template OS
3. Verify resources: Ensure enough memory and disk space available
4. Try without advanced settings first
5. Check Proxmox VE logs: `tail -f /var/log/pve/tasks/active`

### Issue 2: Install Script Fails

**Symptoms:**
- Installation completes but service won't start
- Application not accessible on expected port
- Configuration errors

**Solutions:**
1. Check install script logs: View script output
2. Check service logs: `journalctl -u <service> -n 50`
3. Verify installation: Check if all files in place
4. Test manually: Run install commands inside container
5. Check dependencies: Verify all required packages installed

### Issue 3: Update Script Fails

**Symptoms:**
- Update exits with error
- Application breaks after update
- Version mismatch

**Solutions:**
1. Check update logic: Verify version comparison logic
2. Test without update: Run script twice to ensure it works initially
3. Verify network: Ensure container has internet for updates
4. Check backup status: Verify backup was created
5. Test in test environment: Try update in fresh container

---

## Testing Best Practices

### Before Testing

1. **Always backup existing configurations** - Don't break production setups
2. **Use test containers** - Create dedicated test LXC containers
3. **Document expected behavior** - Know what success looks like
4. **Test incrementally** - Test each component separately
5. **Use verbose mode** - Enable VERBOSE=yes to see detailed output
6. **Monitor resources** - Keep an eye on CPU/RAM/disk during testing

### During Testing

1. **Test all paths** - Verify all code paths are correct
2. **Test with different configurations** - Default, advanced, custom resources
3. **Test error scenarios** - Simulate failures and verify handling
4. **Test edge cases** - Empty storage, minimal resources, special features
5. **Verify cleanup** - Ensure no temporary files remain
6. **Check logs** - Review all logs for issues or warnings

### After Testing

1. **Document issues** - Keep track of all problems found
2. **Record solutions** - Document how each issue was resolved
3. **Update templates** - Improve templates based on test results
4. **Share findings** - Report issues to maintainers if relevant
5. **Clean up test environments** - Remove test containers when done

---

## Pre-Commit Testing Checklist

### Syntax Checks
- [ ] Script passes bash -n (syntax validation)
- [ ] All required variables defined
- [ ] All required function calls present
- [ ] Function call order is correct
- [ ] Header follows template format exactly

### Logic Checks
- [ ] Variables initialize correctly
- [ ] update_script() logic handles all cases
- [ ] Error handling catches exceptions
- [ ] Service management logic is sound

### Integration Checks
- [ ] Container creates with correct resources
- [ ] Install script runs without errors
- [ ] Service starts successfully
- [ ] Service is accessible on expected port
- [ ] update_script() function works correctly
- [ ] All cleanup functions called
- [ ] Container removes cleanly

### Functionality Checks
- [ ] Application works as expected
- [ ] Configuration persists correctly
- [ ] Data is stored in correct location
- [ ] Service can be started and stopped
- [ ] update mechanism works as documented
- [ ] All features from var_* work as expected
- [ ] Interactive prompts (if any) are correct

---

## Regression Testing

### What to Test After Updates

1. **Container creation** - Test with different resource combinations
2. **Installation** - Test fresh install vs. install-update
3. **Update function** - Test with no update needed, with update available, with version mismatch
4. **Service management** - Test start/stop/restart with different states
5. **Configuration changes** - Test with different variables set

### Version Compatibility Testing

1. **Debian 12** - Standard target, test all scripts
2. **Debian 13** - Test critical services that may break
3. **Ubuntu 22.04** - LTS version, test compatibility
4. **Ubuntu 24.04** - Latest LTS, verify all features work
5. **Alpine 3.20** - Minimal version, test lightweight services

---

## Performance Testing

### Resource Usage Patterns

**Measure during testing:**

1. **Memory Usage**
```bash
# Check before and after
pct exec <ctid> free -h

# Expected increase: +200-400MB for base system + application
```

2. **Disk I/O**
```bash
# Monitor disk activity
pct exec <ctid> iostat -x 1

# Check disk space over time
watch -n 1 "pct exec <ctid> df -h /opt/appname"
```

3. **CPU Load**
```bash
# Monitor CPU usage
pct exec <ctid> top -n 1

# Check if CPU cores are sufficient
lscpu | grep "^CPU(s):"
```

---

## Next Steps

1. **Test syntax** before execution (bash -n)
2. **Test with VERBOSE=yes** for debugging
3. **Test all script variants** (default, advanced, user-specified)
4. **Verify service startup** with systemctl status
5. **Test update mechanism** thoroughly
6. **Test cleanup** to ensure no remnants remain
7. **Document test results** - Keep records of all tests
8. **Report bugs** - Fix issues before committing
