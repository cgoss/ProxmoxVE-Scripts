# Error Handling - Common Errors and Recovery

## Overview

This document provides common error codes, symptoms, causes, and solutions for ProxmoxVE script execution.

---

## Container Creation Errors (CT Scripts)

### Error 100: Root Access Required

**Symptoms:**
- Error: "You need to be root to run this script"
- Script exits immediately

**Cause:** Script not executed as root user

**Solution:**
```bash
# Re-run with sudo or as root
sudo bash ct/docker.sh
# Or
su -
bash ct/docker.sh
```

**LLM Action:**
- Verify user has root privileges before executing
- Add sudo to command if needed

---

### Error 101: Proxmox Version Incompatible

**Symptoms:**
- Error: "This script requires Proxmox VE version 8.0 or higher"
- Error: "Proxmox VE version 9.0/9.1 is required"

**Cause:** Proxmox host version too old for script

**Solution:**
```bash
# Check Proxmox version
pveversion

# Upgrade Proxmox VE (see Proxmox documentation)
```

**LLM Action:**
- Check Proxmox version before recommending scripts
- Suggest upgrading Proxmox if version is too old
- Offer alternative scripts compatible with current version

---

### Error 102: Invalid CT ID

**Symptoms:**
- Error: "Invalid CT ID: 999999999"
- Error: "CT ID already exists"

**Cause:** var_ctid is out of range or already in use

**Solution:**
```bash
# List existing containers
pct list

# Use available ID range (100-999999999)
```

**LLM Action:**
- Don't specify var_ctid in non-interactive mode (let Proxmox auto-assign)
- If user specifies ID, verify it's available
- Show user list of existing IDs

---

### Error 103: Invalid Storage

**Symptoms:**
- Error: "Storage not found: storage-name"
- Error: "Insufficient disk space on storage"

**Cause:** var_storage value doesn't match available storage

**Solution:**
```bash
# Check available storage
pvesm status

# Re-run with correct storage name
var_storage=local-lvm bash ct/script.sh
```

**LLM Action:**
- Always run `pvesm status` before asking user to choose
- Validate user's storage choice against available options
- Re-ask for storage if invalid

---

### Error 104: Invalid Network Configuration

**Symptoms:**
- Error: "Invalid IP address"
- Error: "Invalid gateway"
- Error: "Bridge not found: vmbr10"

**Cause:** var_net/var_ip/var_gateway/var_brg values are invalid

**Solution:**
```bash
# Validate IP format (for static)
# Example: 192.168.1.100

# Check available bridges
ls /etc/pve/qemu-server/
```

**LLM Action:**
- Validate network inputs before execution
- Show available bridges if user specifies custom bridge
- Use DHCP if user is unsure about static IP

---

### Error 105: Template Download Failed

**Symptoms:**
- Error: "Failed to download template"
- Error: "Template not found: debian-12-standard_12.2-1_amd64.tar.zst"

**Cause:** Network issue, Proxmox template repository unavailable, invalid template name

**Solution:**
```bash
# Test connectivity
ping -c 3 download.proxmox.com

# Retry script execution
bash ct/script.sh

# Or manually download template
pveamtl available
pveamtl update
pveamtl local debian-12-standard_12.2-1_amd64.tar.zst
```

**LLM Action:**
- Check internet connectivity before execution
- Verify Proxmox VE version compatibility
- Suggest manual template download if persistent failure

---

### Error 106: Container Creation Failed

**Symptoms:**
- Error: "Failed to create container"
- Error: "Command 'pct create' failed"

**Cause:** Various (resource limits, storage issues, template corruption)

**Solution:**
```bash
# Check Proxmox logs
journalctl -u pveved -n 50

# Check available resources
pvesm status

# Try with VERBOSE=yes
VERBOSE=yes bash ct/script.sh
```

**LLM Action:**
- Enable verbose mode to see detailed error
- Check resource availability (CPU/RAM/Disk)
- Suggest reducing resource requirements if hitting limits

---

## Installation Script Errors (Inside Container)

### Error: "No Installation Found"

**Symptoms:**
- Error: "No Docker Installation Found!"
- Error: "No PostgreSQL Installation Found!"
- Script exits immediately

**Cause:** update_script or application check fails to detect installation

**Solution:**
```bash
# Check if application is installed
docker --version
systemctl status postgresql

# Reinstall if missing
bash ct/docker.sh  # Will reinstall
```

**LLM Action:**
- Inform user if this is expected (reinstall vs update)
- Check if install script actually completed successfully
- Suggest reinstalling if update was intended but app not found

---

### Error: Network Check Failed

**Symptoms:**
- Error: "Network check failed"
- Error: "DNS resolution failed"
- Error: "Cannot reach GitHub"

**Cause:** Network issues inside container

**Solution:**
```bash
# From Proxmox host:
pct exec <ctid> ping -c 3 8.8.8.8

# Check container network settings
pct config <ctid>

# Fix network issues then re-run install script
pct exec <ctid> bash /path/to/install-script.sh
```

**LLM Action:**
- Verify container has network connectivity
- Check firewall rules
- Ensure DNS is configured correctly
- Re-run installation script from inside container if needed

---

### Error: Package Installation Failed

**Symptoms:**
- Error: "Unable to locate package"
- Error: "Package installation failed"
- APT errors during install

**Cause:** Repository issues, package not found, dependency conflicts

**Solution:**
```bash
# Update package lists
pct exec <ctid> apt-get update

# Fix broken packages
pct exec <ctid> apt-get -f install

# Retry installation
pct exec <ctid> bash /path/to/install-script.sh
```

**LLM Action:**
- Enable verbose mode inside container
- Check if correct OS version is being used (Debian vs Ubuntu)
- Verify repository URLs are correct

---

### Error: Service Start Failed

**Symptoms:**
- Error: "Failed to start service"
- Error: "Service active but dead"
- systemctl shows failed status

**Cause:** Configuration errors, port conflicts, missing dependencies

**Solution:**
```bash
# Check service status
pct exec <ctid> systemctl status docker

# View service logs
pct exec <ctid> journalctl -u docker -n 50

# Check for port conflicts
pct exec <ctid> netstat -tulpn | grep 3000

# Restart service
pct exec <ctid> systemctl restart docker
```

**LLM Action:**
- Check service logs for specific error messages
- Verify no port conflicts with other containers
- Ensure all dependencies are installed
- Suggest checking configuration file

---

## Resource-Related Errors

### Error: Out of Memory

**Symptoms:**
- Container creation succeeds but container won't start
- System becomes slow or unresponsive
- OOM (Out of Memory) killer messages in logs

**Cause:** Allocating more RAM than available on Proxmox host

**Solution:**
```bash
# Check available memory on Proxmox host
free -h

# Reduce RAM allocation
var_ram=2048 bash ct/script.sh  # Down from 4096
```

**LLM Action:**
- Check Proxmox host memory before suggesting RAM amounts
- Warn user if requested amount exceeds available memory
- Recommend reducing resource requirements

---

### Error: CPU Overcommit

**Symptoms:**
- All containers slow
- High CPU load on Proxmox host
- Containers taking long time to start

**Cause:** Allocating more CPU cores than physically available

**Solution:**
```bash
# Check CPU information
lscpu

# List existing containers and their CPU allocation
pct list

# Reduce CPU allocation
var_cpu=2 bash ct/script.sh  # Down from 4
```

**LLM Action:**
- Verify CPU requirements before execution
- Check existing container allocations
- Suggest reducing CPU count if host is overloaded

---

### Error: Disk Space Exhausted

**Symptoms:**
- Error: "No disk space left on storage"
- Container creation fails
- Container starts but can't write data

**Cause:** Storage drive full

**Solution:**
```bash
# Check storage space
pvesm status

# Clean up old containers/templates
pct list
qm list

# Use different storage drive with available space
var_storage=local-lvm bash ct/script.sh
```

**LLM Action:**
- Always check available space before recommending disk size
- Suggest disk cleanup if storage is full
- Offer alternative storage drives

---

## Advanced Feature Errors

### Error: GPU Passthrough Failed

**Symptoms:**
- Error: "No GPU available"
- Error: "GPU passthrough failed"
- Container starts but GPU not detected

**Cause:** No GPU available, incorrect GPU ID, incompatible GPU

**Solution:**
```bash
# Check available GPUs on Proxmox host
lspci | grep -i vga
qm list

# Use correct GPU ID if multiple available
var_gpu=yes  # Auto-detects and passes all GPUs
```

**LLM Action:**
- Verify GPU availability before recommending GPU-required scripts
- Check if GPU is already in use by another VM/CT
- Warn user if GPU passthrough requires specific configuration

---

### Error: Nesting Failed

**Symptoms:**
- Error: "LXC nesting not supported"
- Container starts but can't create nested containers

**Cause:** Missing var_nesting=1 or kernel module not loaded

**Solution:**
```bash
# Enable nesting
var_nesting=1 bash ct/docker.sh

# Check nesting is supported
pct config <ctid> | grep nesting
```

**LLM Action:**
- Always set var_nesting=1 for Docker scripts
- Verify nesting is supported on Proxmox host
- Inform user if nesting requires host configuration changes

---

## Script-Specific Error Patterns

### Docker Scripts

**Common Errors:**
1. "Cannot connect to Docker daemon"
2. "Docker service failed to start"
3. "Permission denied on docker.sock"

**Solutions:**
```bash
# Enable nesting for Docker-in-LXC
var_nesting=1 bash ct/docker.sh

# Check Docker status
pct exec <ctid> systemctl status docker

# Restart Docker
pct exec <ctid> systemctl restart docker

# Check Docker logs
pct exec <ctid> journalctl -u docker -n 20
```

### Database Scripts (PostgreSQL, MySQL, MariaDB)

**Common Errors:**
1. "Database not accessible on port 5432/3306/3307"
2. "Authentication failed"
3. "Database initialization failed"

**Solutions:**
```bash
# Check service status
pct exec <ctid> systemctl status postgresql

# Check port is listening
pct exec <ctid> netstat -tulpn | grep 5432

# Check firewall settings (if applicable)
pct exec <ctid> iptables -L -n | grep 5432

# Check database logs
pct exec <ctid> tail -f /var/log/postgresql/*.log
```

### Media Scripts (Plex, Jellyfin, Emby)

**Common Errors:**
1. "GPU not detected"
2. "Transcoding failed"
3. "Media library not accessible"

**Solutions:**
```bash
# Verify GPU passthrough is working
pct exec <ctid> lspci | grep -i vga

# Check media server logs
pct exec <ctid> tail -f /var/lib/plexmediaserver/Library/Application\ Support/Plex\ Media\ Server/Logs/Plex\ Media\ Server.log

# Check storage mount points
pct exec <ctid> df -h

# Restart media server
pct exec <ctid> systemctl restart plexmediaserver
```

---

## Recovery Strategies

### Strategy 1: Clean and Retry

**When to use:** Simple errors, network blips

**Steps:**
1. Stop and delete failed container
2. Wait for cleanup to complete
3. Retry with same configuration

```bash
pct stop <ctid>
pct destroy <ctid>
sleep 5
var_cpu=2 var_ram=2048 bash ct/script.sh
```

### Strategy 2: Debug Mode

**When to use:** Persistent failures, unclear errors

**Steps:**
1. Enable verbose mode
2. Capture logs
3. Analyze output

```bash
VERBOSE=yes bash ct/script.sh 2>&1 | tee /tmp/script-debug.log
```

### Strategy 3: Reduce Resources

**When to use:** Out of memory, CPU overcommit

**Steps:**
1. Reduce CPU cores (e.g., 4 → 2)
2. Reduce RAM (e.g., 4096 → 2048)
3. Retry with reduced resources

```bash
var_cpu=2 var_ram=2048 bash ct/script.sh
```

### Strategy 4: Manual Verification

**When to use:** Script succeeds but application doesn't work

**Steps:**
1. Enter container manually
2. Check if application is installed
3. Check application logs
4. Test application functionality

```bash
pct enter <ctid>

# Check installation
docker --version
systemctl status <service>

# Check logs
tail -f /var/log/<service>.log
```

---

## LLM Best Practices for Error Handling

1. **Always check prerequisites first** - Root access, Proxmox version
2. **Validate all inputs** - IP addresses, storage names, resource values
3. **Provide clear error messages** - Explain what went wrong and how to fix
4. **Offer recovery options** - Retry, reduce resources, manual cleanup
5. **Enable verbose mode when troubleshooting** - Use VERBOSE=yes
6. **Check logs systematically** - Proxmox logs, container logs, service logs
7. **Document errors** - Keep track of what went wrong for future reference
8. **Communicate clearly with user** - Explain impact and next steps
9. **Don't guess** - Suggest verifying before assuming solution
10. **Know when to escalate** - Some errors require manual intervention or Proxmox admin access

---

## Exit Code Reference

For complete exit code reference, see `EXIT_CODES.md` in the main repository.

**Common exit codes:**
- 0: Success
- 1-99: Various script errors
- 100-199: Container creation errors
- 200-299: Installation script errors

**Checking Exit Codes:**
```bash
# After script execution
echo $?

# Compare against EXIT_CODES.md
```

---

## Next Steps

1. Use this guide to identify and resolve common errors
2. Always enable verbose mode when troubleshooting
3. Check Proxmox and container logs for detailed information
4. Verify prerequisites before script execution
5. Use recovery strategies appropriate to the error type
