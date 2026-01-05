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

#########################
#   SSL CONFIGURATION   #
#########################
echo
read -r -p "${TAB3}Enable HTTPS with self-signed certificate? [y/N]: " ENABLE_SSL

if [[ "$ENABLE_SSL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  EXTERNAL_URL="https://${IPADDRESS}"
  msg_info "HTTPS will be configured with self-signed certificate"
else
  EXTERNAL_URL="http://${IPADDRESS}"
  msg_info "HTTP will be used (not recommended for production)"
fi

#########################
#   INSTALL GITLAB      #
#########################
msg_info "Installing GitLab Community Edition (this may take several minutes)"
msg_info "GitLab omnibus includes PostgreSQL, Redis, Nginx, and all required components"
EXTERNAL_URL="${EXTERNAL_URL}" apt-get install -y gitlab-ce
msg_ok "GitLab packages installed"

#########################
#   POST-INSTALL CONFIG #
#########################
if [[ "$ENABLE_SSL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  msg_info "Configuring self-signed SSL certificate"
  cat >> /etc/gitlab/gitlab.rb <<EOF

# SSL Configuration
letsencrypt['enable'] = false
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/${IPADDRESS}.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/${IPADDRESS}.key"
EOF

  msg_info "Reconfiguring GitLab for SSL"
  gitlab-ctl reconfigure
  msg_ok "HTTPS enabled with self-signed certificate"
  msg_warn "Browsers will show security warning. Configure Let's Encrypt for trusted cert."
fi

# Optimize GitLab settings for LXC container (4GB RAM default)
msg_info "Applying performance optimizations for LXC container"
cat >> /etc/gitlab/gitlab.rb <<EOF

# Performance Tuning for 4GB RAM LXC Container
puma['worker_processes'] = 2
sidekiq['max_concurrency'] = 10
gitaly['ruby_num_workers'] = 2
postgresql['shared_buffers'] = "128MB"
EOF

gitlab-ctl reconfigure
msg_ok "Performance optimizations applied"

#########################
#   EMAIL SETUP         #
#########################
echo
msg_info "Email/SMTP Configuration (optional)"
read -r -p "${TAB3}Do you want to configure email/SMTP now? [y/N]: " SETUP_EMAIL

if [[ "$SETUP_EMAIL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  read -r -p "${TAB3}SMTP server (e.g., smtp.gmail.com): " SMTP_SERVER
  read -r -p "${TAB3}SMTP port (usually 587): " SMTP_PORT
  read -r -p "${TAB3}SMTP username: " SMTP_USER
  read -r -s -p "${TAB3}SMTP password: " SMTP_PASS
  echo
  read -r -p "${TAB3}From email address: " FROM_EMAIL

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

  msg_info "Applying email configuration"
  gitlab-ctl reconfigure
  msg_ok "Email configured"
else
  msg_ok "Skipped email configuration (can be configured later)"
fi

#########################
#   SERVICE ENABLE      #
#########################
msg_info "Ensuring GitLab services are enabled"
systemctl enable -q --now gitlab-runsvdir
msg_ok "GitLab services enabled"

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
