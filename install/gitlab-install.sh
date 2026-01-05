#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: opencode
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://gitlab.com/gitlab-org/gitlab

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

#########################
#   PRE‑INSTALL WARN    #
#########################
msg_warn "WARNING: This script will add the official GitLab APT repository and install the"
msg_warn "GitLab Community Edition omnibus package. The installer script is maintained by"
msg_warn "GitLab, not by this repository. Review the upstream installer if you have concerns."
msg_custom "${TAB3}${GATEWAY}${BGN}${CL}" "\e[1;34m" "→  https://docs.gitlab.com/install/package/debian/"
echo
read -r -p "${TAB3}Do you want to continue? [y/N]: " CONFIRM
if [[ ! "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  msg_error "Aborted by user. No changes made."
  exit 10
fi

#########################
#   DEPENDENCIES       #
#########################
msg_info "Installing curl (required for repository setup)"
$STD apt-get install -y curl
msg_ok "Prerequisites installed"

#########################
#   GITLAB REPO SETUP  #
#########################
msg_info "Adding GitLab CE APT repository"
curl -sSf https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash
msg_ok "GitLab repository added"

#########################
#   CONFIGURATION       #
#########################
msg_info "Configuring GitLab URL"
IPADDRESS=$(hostname -I | awk '{print $1}')

# Ask about SSL BEFORE installation
echo
read -r -p "${TAB3}Enable HTTPS with self-signed certificate? [y/N]: " ENABLE_SSL

if [[ "$ENABLE_SSL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  EXTERNAL_URL="https://${IPADDRESS}"
else
  EXTERNAL_URL="http://${IPADDRESS}"
fi

# Ask about email BEFORE installation
echo
read -r -p "${TAB3}Configure email/SMTP now? [y/N]: " SETUP_EMAIL
if [[ "$SETUP_EMAIL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  read -r -p "${TAB3}SMTP server (e.g., smtp.gmail.com): " SMTP_SERVER
  read -r -p "${TAB3}SMTP port (usually 587): " SMTP_PORT
  read -r -p "${TAB3}SMTP username: " SMTP_USER
  read -r -s -p "${TAB3}SMTP password: " SMTP_PASS
  echo
  read -r -p "${TAB3}From email address: " FROM_EMAIL
fi

# PRE-CONFIGURE gitlab.rb BEFORE package installation
msg_info "Pre-configuring GitLab settings"
mkdir -p /etc/gitlab
cat > /etc/gitlab/gitlab.rb <<EOF
# GitLab configuration file
# This file is managed by the gitlab-ce package
# Any changes will be applied during package installation

external_url '${EXTERNAL_URL}'
EOF

# Add SSL configuration if enabled
if [[ "$ENABLE_SSL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  cat >> /etc/gitlab/gitlab.rb <<EOF

# SSL Configuration
letsencrypt['enable'] = false
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/${IPADDRESS}.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/${IPADDRESS}.key"
EOF
fi

# Add performance tuning for 4GB RAM LXC container
cat >> /etc/gitlab/gitlab.rb <<EOF

# Performance Tuning for 4GB RAM LXC Container
puma['worker_processes'] = 2
sidekiq['max_concurrency'] = 10
gitaly['ruby_num_workers'] = 2
postgresql['shared_buffers'] = "128MB"
EOF

# Add email configuration if requested
if [[ "$SETUP_EMAIL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  cat >> /etc/gitlab/gitlab.rb <<EOF

# Email Configuration
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "${SMTP_SERVER}"
gitlab_rails['smtp_port'] = ${SMTP_PORT}
gitlab_rails['smtp_user_name'] = "${SMTP_USER}"
gitlab_rails['smtp_password'] = "${SMTP_PASS}"
gitlab_rails['smtp_domain'] = "${SMTP_SERVER}"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['gitlab_email_from'] = "${FROM_EMAIL}"
EOF
fi

msg_ok "GitLab pre-configured"

#########################
#   INSTALL GITLAB      #
#########################
msg_info "Installing GitLab Community Edition (this may take 5-10 minutes)"
msg_info "GitLab omnibus includes PostgreSQL, Redis, Nginx, and all components"

# Set Debian frontend to noninteractive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Install GitLab CE package
# The package will automatically run 'gitlab-ctl reconfigure' using our pre-configured gitlab.rb
if ! apt-get install -y -o DPkg::Options::="--force-confold" gitlab-ce 2>&1 | tee /tmp/gitlab-install.log; then
  msg_error "GitLab installation failed - check /tmp/gitlab-install.log for details"
  exit 1
fi

msg_ok "GitLab package installed"

# Verify installation succeeded
if ! command -v gitlab-ctl &> /dev/null; then
  msg_error "gitlab-ctl command not found - installation failed"
  msg_info "Check /tmp/gitlab-install.log for errors"
  exit 1
fi

msg_ok "GitLab installation verified"

#########################
#   SERVICE ENABLE      #
#########################
msg_info "Verifying GitLab services"

# Wait a moment for services to be created
sleep 5

# Check if gitlab-runsvdir service exists
if ! systemctl list-unit-files | grep -q gitlab-runsvdir; then
  msg_error "gitlab-runsvdir service not found - installation incomplete"
  msg_info "Running manual reconfigure attempt..."
  gitlab-ctl reconfigure
fi

# Enable and start GitLab services
msg_info "Enabling GitLab services"
if systemctl enable --now gitlab-runsvdir 2>&1; then
  msg_ok "GitLab services enabled and started"
else
  msg_error "Failed to enable GitLab services"
  msg_info "Check status with: gitlab-ctl status"
  exit 1
fi

# Wait for services to start
msg_info "Waiting for GitLab services to start (this may take 2-5 minutes)"
sleep 15

# Verify services are running
if gitlab-ctl status | grep -q "run:"; then
  msg_ok "GitLab services are running"
else
  msg_warn "Some GitLab services may not be running yet"
  msg_info "Check status with: gitlab-ctl status"
fi

#########################
#   FINAL VERIFICATION  #
#########################
msg_info "Running final verification"

# Check if GitLab is responding
RETRY_COUNT=0
MAX_RETRIES=30

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost" 2>/dev/null || echo "000")
  if echo "$HTTP_CODE" | grep -q "200\|302"; then
    msg_ok "GitLab web interface is responding"
    break
  fi
  RETRY_COUNT=$((RETRY_COUNT + 1))
  sleep 10
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
  msg_warn "GitLab web interface not responding yet - may need more time to start"
  msg_info "Monitor startup with: gitlab-ctl tail"
fi

#########################
#   FINISH DISPLAY      #
#########################
msg_ok "GitLab installed successfully"

# Extract and display the initial root password
if [ -f /etc/gitlab/initial_root_password ]; then
  INITIAL_PASSWORD=$(grep 'Password:' /etc/gitlab/initial_root_password | cut -d' ' -f2)
  echo
  echo -e "${INFO}${YW} Initial Login Credentials:${CL}"
  echo -e "${TAB}${GATEWAY}${BGN}Username: root${CL}"
  echo -e "${TAB}${GATEWAY}${BGN}Password: ${INITIAL_PASSWORD}${CL}"
  echo
  echo -e "${WARN}${RD}IMPORTANT: This password file will be deleted in 24 hours!${CL}"
  echo -e "${INFO}${YW}Please log in and change your password immediately.${CL}"
  echo
fi

echo -e "${INFO}${YW} GitLab Web Interface:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}${EXTERNAL_URL}${CL}"
echo
echo -e "${INFO}${YW} GitLab may take 2-5 minutes to fully start. Wait for the login page.${CL}"
echo
echo -e "${INFO}${YW} Next Steps:${CL}"
echo -e "${TAB}1. Log in and change the root password${CL}"
echo -e "${TAB}2. Create additional admin/user accounts${CL}"
echo -e "${TAB}3. Configure CI/CD runners if needed${CL}"
echo -e "${TAB}4. Review email settings for notifications${CL}"
echo
echo -e "${INFO}${YW} Useful Commands:${CL}"
echo -e "${TAB}gitlab-ctl status          # Check service status${CL}"
echo -e "${TAB}gitlab-ctl tail            # View logs${CL}"
echo -e "${TAB}gitlab-rake gitlab:check   # Run health check${CL}"
echo -e "${TAB}gitlab-ctl reconfigure     # Apply configuration changes${CL}"
echo -e "${TAB}gitlab-ctl restart         # Restart all services${CL}"
echo
echo -e "${INFO}${YW} NOTE: Monitor disk usage as repositories grow.${CL}"
echo -e "${TAB}Use 'df -h' to check disk space regularly.${CL}"

#########################
#   CUSTOM MOTD         #
#########################
msg_info "Configuring custom MOTD with GitLab status"
cat > /usr/local/bin/gitlab-status-motd <<'EOF'
#!/usr/bin/env bash
echo -e "\n=== GitLab Status ==="
gitlab-ctl status 2>/dev/null | grep -E "(run:|down:)" | head -5
echo ""
EOF
chmod +x /usr/local/bin/gitlab-status-motd

# Add to MOTD
echo "/usr/local/bin/gitlab-status-motd" >> /etc/update-motd.d/99-gitlab
chmod +x /etc/update-motd.d/99-gitlab
msg_ok "Custom MOTD configured"

motd_ssh
customize
cleanup_lxc
