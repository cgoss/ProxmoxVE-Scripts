# Best Practices - Common Pitfalls and Solutions

## Overview

This document provides best practices for creating ProxmoxVE Helper-Scripts, avoiding common pitfalls.

---

## Script Creation Best Practices

### DO's

1. **Always start from templates** - Don't create scripts from scratch
2. **Use helper functions** - Leverage tools.func and alpine-tools.func functions
3. **Implement update_script()** - All CT scripts must have update capability
4. **Follow naming conventions** - APP, var_tags, var_cpu, etc.
5. **Set reasonable defaults** - Don't overallocate resources
6. **Use proper error handling** - Use catch_errors, msg_error, msg_ok, msg_info
7. **Document clearly** - Comment complex logic, explain decisions
8. **Use $STD prefix** - Suppress unnecessary output
9. **Clean up properly** - Remove temporary files, use cleanup_lxc

### DON'Ts

1. **Don't hardcode paths** - Use `/opt/$APP` for applications
2. **Don't use world-writable permissions** - Only what's necessary
3. **Don't skip error handling** - Always wrap in try/catch where appropriate
4. **Don't ignore user input** - Always validate and prompt for confirmation
5. **Don't hardcode passwords** - Generate secure random passwords
6. **Don't modify templates unnecessarily** - Templates work as-is
7. **Don't skip helper functions** - Use setup_postgresql, setup_docker, etc.
8. **Don't ignore Alpine differences** - Handle apk vs apt differences
9. **Don't forget cleanup_lxc** - Always call at end of install script
10. **Don't disable critical security** - Don't use root when not needed

---

## Dependency Management

### DO's

1. **Use helper functions for databases** - setup_postgresql, setup_mariadb, setup_mongodb
2. **Use setup_docker for Docker-based apps** - Don't install Docker manually
3. **Use language runtime helpers** - setup_nodejs, setup_uv for Python
4. **Install dependencies at once** - Single apt-get install command preferred
5. **Use ensure_dependencies** - For critical packages
6. **Check Alpine compatibility** - Some packages don't work on Alpine

### DON'Ts

1. **Don't install from source** - Use APT packages when available
2. **Don't use pip without virtualenv** - Use setup_uv or system Python
3. **Don't compile from tarballs** - Use pre-compiled binaries when available
4. **Don't mix package managers** - Don't use pip and apt for same language
5. **Don't ignore version constraints** - Respect supported versions
6. **Don't forget build dependencies** - Install build-essential for source builds

---

## Resource Allocation

### DO's

1. **Start with minimal resources** - Can always scale up
2. **Consider use case** - Development vs production requirements
3. **Account for OS overhead** - Debian/Ubuntu: ~400MB, Alpine: ~200MB
4. **Consider container isolation** - Each container has own kernel space
5. **Don't overallocate for "just in case"** - Use sensible defaults

### DON'Ts

1. **Don't allocate maximum by default** - Default to 2 CPUs, 2GB RAM
2. **Don't ignore Proxmox host limits** - Check available resources first
3. **Don't set unrealistic disk sizes** - 50GB default is excessive for most services
4. **Don't use privileged when unprivileged works** - Security risk
5. **Don't allocate GPU unless needed** - GPU passthrough reduces host resources
6. **Don't ignore Alpine memory savings** - But still account for overhead
7. **Don't allocate resources blindly** - Research service requirements first

---

## Security Best Practices

### DO's

1. **Use unprivileged by default** - Security best practice
2. **Only use privileged when necessary** - Docker, GPU passthrough, FUSE
3. **Don't run as root inside container** - Use non-root user when possible
4. **Generate secure passwords** - Use random strings, not dictionary words
5. **Don't expose unnecessary ports** - Only bind what service needs
6. **Use TLS/SSL for public services** - Don't use plain HTTP
7. **Keep credentials secret** - Store in /opt/$APP/.env file, not in scripts
8. **Use AppArmor/SELinux if applicable** - Security hardening
9. **Follow principle of least privilege** - Minimum access required

### DON'Ts

1. **Don't disable AppArmor/SELinux** - Don't override security policies
2. **Don't run services as root** - Creates security vulnerabilities
3. **Don't hardcode credentials in scripts** - Use environment variables or .env files
4. **Don't log passwords** - Never include in logs or debug output
5. **Don't expose ports unnecessarily** - Use firewall rules instead
6. **Don't use default passwords** - Always force user to change on first run
7. **Don't allow public access** - Default to localhost or internal network
8. **Don't ignore known vulnerabilities** - Stay updated on security patches
9. **Don't use insecure protocols** - Avoid HTTP, use HTTPS with valid certificates
10. **Don't bind to all interfaces** - Bind to specific IP or localhost

---

## Service Configuration

### DO's

1. **Use proper configuration files** - /etc/$APP/config or .env files
2. **Use environment variables for secrets** - Not hardcoded in scripts
3. **Create proper systemd services** - Don't use one-shot scripts
4. **Set appropriate file permissions** - 644 for files, 755 for directories
5. **Use proper logging** - Journal, not files
6. **Configure data persistence** - Use volumes or bind mounts appropriately
7. **Use correct umask** - Default to 022 (files: 644, dirs: 755)
8. **Document configuration** - Explain all settings in README or docs

### DON'Ts

1. **Don't use root filesystem** - Run as service user
2. **Don't write to system directories** - Use /opt or /var/lib
3. **Don't modify system configs** - Don't edit /etc files unnecessarily
4. **Don't hardcode configuration** - Make it configurable
5. **Don't mix data directories** - Keep app data in /opt/$APP
6. **Don't use world-writable data** - Sensitive data needs restricted permissions
7. **Don't ignore backup requirements** - Plan for data loss protection
8. **Don't modify running services** - Edit config files and restart, don't restart during operation

---

## Update Mechanism

### DO's

1. **Always implement update_script()** - Critical for long-term maintenance
2. **Version tracking** - Store version in /opt/$APP/version.txt
3. **Graceful updates** - Stop service before updating, backup data
4. **Database migrations** - Handle schema changes in updates
5. **Rollback capability** - Keep previous version if update fails
6. **Update notifications** - Inform user of available updates
7. **Testing in production** - Test in dev environment first

### DON'Ts

1. **Don't break existing installations** - Check before updating
2. **Don't lose data on updates** - Always backup first
3. **Don't update without testing** - Test in container or test environment
4. **Don't force critical updates** - Allow users to schedule updates
5. **Don't ignore update failures** - Log errors, provide clear guidance
6. **Don't skip compatibility checks** - Verify OS versions, dependencies
7. **Don't auto-restart services** - Let user decide when to restart

---

## Documentation

### DO's

1. **Document installation** - Provide clear setup instructions
2. **Document configuration** - Explain all settings and options
3. **Document access** - URLs, ports, default credentials, how to change
4. **Document dependencies** - List all required packages and versions
5. **Document update procedure** - How to check for and apply updates
6. **Document common issues** - Provide troubleshooting section with FAQs
7. **Document special requirements** - GPU, FUSE, TUN, storage, network
8. **Document permissions** - What's needed for file access
9. **Include examples** - Show common usage patterns
10. **Document ports** - List all ports service uses

### DON'Ts

1. **Don't document obvious things** - Users know how to install
2. **Don't document without testing** - Verify all instructions work
3. **Don't use jargon** - Explain technical terms clearly
4. **Don't assume knowledge** - Users may be new to Linux/ProxmoxVE
5. **Don't create empty sections** - Every section should have content
6. **Don't make assumptions** - Don't assume user's environment or expertise
7. **Don't hide critical information** - Clearly note limitations and requirements
8. **Don't document features incorrectly** - Test before documenting
9. **Don't skip configuration examples** - Show realistic use cases
10. **Don't ignore edge cases** - Document how to handle them

---

## Common Mistakes

### Mistake 1: Missing update_script()

**Symptom:** CT script doesn't implement update_script()

**Impact:** Users can't update application, must reinstall entire container

**Solution:**
```bash
function update_script() {
  header_info
  check_container_storage
  check_container_resources

  # Check for updates
  # ... update logic

  msg_ok "Updated successfully!"
  exit
}
```

### Mistake 2: Not Using $STD Prefix

**Symptom:** Excessive output during installation, cluttering logs

**Impact:** Hard to read logs, confusing for users

**Solution:**
```bash
# Always use $STD prefix for package installs
$STD apt-get install -y package

# Only show important messages with msg_info/msg_ok
msg_info "Installing important package..."
msg_ok "Package installed successfully"
```

### Mistake 3: Incorrect File Permissions

**Symptom:** Service can't write data, can't access files

**Impact:** Application doesn't function properly

**Solution:**
```bash
# Application directory should be owned by service user
mkdir -p /opt/$APP/data
chown -R $APP:$APP /opt/$APP/data

# Logs directory
mkdir -p /var/log/$APP
chown -R $APP:$APP /var/log/$APP

# Configuration files
chmod 644 /opt/$APP/config.ini
```

### Mistake 4: Service Won't Start

**Symptom:** systemctl start fails, service exits immediately

**Impact:** Installation appears to succeed but service is dead

**Solution:**
```bash
# Check service status
systemctl status $APP

# Check journal logs
journalctl -u $APP -n 50

# Check for errors
systemctl is-failed $APP
```

### Mistake 5: Container Resource Exhaustion

**Symptom:** Container uses all RAM, host becomes slow, OOM killer

**Impact:** All containers on host affected, system becomes unresponsive

**Solution:**
```bash
# Reduce resource allocation
var_cpu=2 var_ram=2048 var_disk=4 bash ct/appname.sh

# Monitor resources
pct resources <ctid>
```

### Mistake 6: Network Configuration Errors

**Symptom:** Container has no network, DNS resolution fails

**Impact:** Application can't function, can't be accessed

**Solution:**
```bash
# Test DNS resolution
pct exec <ctid> ping -c 3 8.8.8.8

# Check DNS configuration
pct exec <ctid> cat /etc/resolv.conf

# Restart networking
pct exec <ctid> systemctl restart systemd-networkd
```

### Mistake 7: Database Connection Failures

**Symptom:** Application can't connect to database

**Impact:** Multi-tier applications don't function

**Solution:**
```bash
# Check if database is running
systemctl status postgresql

# Check database logs
journalctl -u postgresql -n 20

# Verify connection string
pct exec <ctid> psql -U appuser -d appdb -h localhost

# Test from inside container
pct enter <ctid>
```

### Mistake 8: Storage Issues

**Symptom:** Container creation fails with "storage not found" or "insufficient space"

**Impact:** Can't deploy service, wasting time

**Solution:**
```bash
# Check available storage before setting
pvesm status

# Verify storage name exactly
var_storage=local-lvm  # Not local, local-lvm, etc.

# Check available space
df -h /path/to/storage
```

### Mistake 9: Missing Dependencies

**Symptom:** Application fails to start, missing library or command

**Impact:** Installation appears complete but service is broken

**Solution:**
```bash
# Check what's missing
pct exec <ctid> which command

# Install missing dependency
$STD apt-get install -y missing-library

# Reconfigure service
# Or run installation script again
```

### Mistake 10: Conflicting Services

**Symptom:** Two services try to use same port

**Impact:** One or both services fail to start

**Solution:**
```bash
# Check what's using port
netstat -tulpn | grep :PORT

# Choose different ports or stop conflicting service
```

---

## Quality Assurance

### Pre-Commit Checklist

- [ ] Script follows template format
- [ ] All required variables defined
- [ ] Header is correct and complete
- [ ] update_script() implemented
- [ ] Error handling is robust
- [ ] Uses helper functions appropriately
- [ ] Service files are systemd native
- [ ] Permissions are correct
- [ ] Documentation is comprehensive
- [ ] Tested in test environment
- [ ] No hardcoded credentials or paths
- [ ] Clean up is implemented (cleanup_lxc)
- [ ] Follows coding standards

### Code Review Criteria

1. **Bash script compatibility** - POSIX compliant, works with bash 4.4+
2. **Error handling** - All failures caught and reported clearly
3. **Security** - No hardcoded secrets, proper permissions
4. **Maintainability** - Clear comments, logical structure
5. **Consistency** - Follows repository patterns and conventions
6. **Testing** - Can be tested independently
7. **Documentation** - Clear, comprehensive, up to date

---

## Performance Optimization

### DO's

1. **Use $STD prefix** - Reduces log clutter
2. **Minimize package installations** - Install all dependencies at once
3. **Use efficient package lists** - Avoid unnecessary packages
4. **Disable unnecessary services** - Don't start services not needed
5. **Use proper database configurations** - Tune for workloads
6. **Optimize logging** - Don't log debug info in production
7. **Use systemd-native services** - More efficient than init scripts

### DON'Ts

1. **Don't optimize prematurely** - Correct code first, then optimize
2. **Don't disable important security features** - They protect against real threats
3. **Don't skip error checking** - Proper error handling is worth the performance cost
4. **Don't make complex caching layers** - Simple is often better
5. **Don't use experimental features** - Stick to stable, tested approaches
6. **Don't ignore user feedback** - Performance should not compromise usability

---

## Next Steps

1. **Follow all best practices** - This document covers the essentials
2. **Test thoroughly** - Always test before committing
3. **Get peer review** - Have other developers review your scripts
4. **Update documentation** - Keep docs in sync with code changes
5. **Learn from existing scripts** - Study similar services for patterns
6. **Report security issues** - Report vulnerabilities responsibly
7. **Monitor user feedback** - Track and respond to issues
8. **Stay updated** - Keep up with ProxmoxVE changes and best practices
