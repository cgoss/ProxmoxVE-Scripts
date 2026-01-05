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
msg_warn "GitLab omnibus package (EE or CE). The installer script is maintained by GitLab, not"
msg_warn "by this repository. Review the upstream installer if you have concerns."
msg_custom "${TAB3}${GATEWAY}${BGN}${CL}" "\e[1;34m" "→  https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh"
echo
read -r -p "${TAB3}Do you want to continue? [y/N]: " CONFIRM
if [[ ! "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  msg_error "Aborted by user. No changes made."
  exit 10
fi

#########################
#   DEPENDENCIES       #
#########################
msg_info "Installing prerequisite packages"
$STD apt-get install -y curl ca-certificates gnupg2 lsb-release
msg_ok "Prerequisites installed"

#########################
#   GITLAB REPO SETUP  #
#########################
msg_info "Adding GitLab APT repository (CE edition)"
# The upstream script can install either EE or CE; we request CE via the package name later
curl -sSf https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | bash
msg_ok "GitLab repository added"

#########################
#   DATABASE (PostgreSQL) #
#########################
msg_info "Setting up PostgreSQL (15) – required by GitLab"
PG_VERSION="15" setup_postgresql
msg_ok "PostgreSQL ready"

#########################
#   PERFORMANCE TUNING  #
#########################
msg_info "Applying GitLab performance tuning"

# Tune PostgreSQL for GitLab workload (optimized for 4GB RAM default)
cat > /etc/postgresql/15/main/conf.d/gitlab.conf <<EOF
# GitLab Performance Tuning
shared_buffers = 128MB
effective_cache_size = 512MB
maintenance_work_mem = 64MB
checkpoint_completion_target = 0.9
wal_buffers = 8MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 4MB
min_wal_size = 512MB
max_wal_size = 2GB
EOF

systemctl restart postgresql
msg_ok "Performance tuning applied"

#########################
#   REDIS (optional)   #
#########################
msg_info "Installing Redis server (5) – required for Sidekiq"
$STD apt-get install -y redis-server
systemctl enable -q --now redis-server
msg_ok "Redis installed and started"

#########################
#   INSTALL GITLAB      #
#########################
msg_info "Installing GitLab Community Edition"
# The upstream repo provides both EE and CE packages; we install the CE meta‑package
$STD apt-get install -y gitlab-ce
msg_ok "GitLab packages installed"

#########################
#   CONFIGURATION       #
#########################
msg_info "Configuring GitLab URL"
IPADDRESS=$(hostname -I | awk '{print $1}')

#########################
#   SSL CONFIGURATION   #
#########################
msg_info "SSL/HTTPS Configuration"
read -r -p "${TAB3}Enable HTTPS with self-signed certificate? [y/N]: " ENABLE_SSL

if [[ "$ENABLE_SSL" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  EXTERNAL_URL="https://${IPADDRESS}"

  # Install certbot for future Let's Encrypt option
  $STD apt-get install -y certbot

  # Configure for self-signed cert (GitLab will generate it)
  cat >> /etc/gitlab/gitlab.rb <<EOF

# SSL Configuration
letsencrypt['enable'] = false
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/${IPADDRESS}.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/${IPADDRESS}.key"
EOF

  msg_ok "HTTPS enabled with self-signed certificate"
  msg_warn "Browsers will show security warning. Configure Let's Encrypt for trusted cert."
else
  EXTERNAL_URL="http://${IPADDRESS}"
  msg_ok "Using HTTP (not recommended for production)"
fi

sed -i "s|^external_url .*|external_url '${EXTERNAL_URL}'|g" /etc/gitlab/gitlab.rb

# Optimize GitLab settings for container (optimized for 4GB RAM default)
cat >> /etc/gitlab/gitlab.rb <<EOF

# Performance Tuning
postgresql['shared_buffers'] = "128MB"
puma['worker_processes'] = 2
sidekiq['max_concurrency'] = 10
gitaly['ruby_num_workers'] = 2
EOF

#########################
#   EMAIL SETUP         #
#########################
msg_info "Configuring email notifications (optional)"
read -r -p "${TAB3}Do you want to configure email/SMTP? [y/N]: " SETUP_EMAIL

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

  msg_ok "Email configured"
else
  msg_ok "Skipped email configuration (can be configured later)"
fi

msg_info "Reconfiguring GitLab (runs omnibus‑runner, creates DB, etc.)"
gitlab-ctl reconfigure
msg_ok "GitLab reconfigured"

#########################
#   SERVICE ENABLE      #
#########################
msg_info "Enabling GitLab service"
systemctl enable -q --now gitlab-runsvdir
msg_ok "GitLab service started"

#########################
#   FINISH DISPLAY      #
#########################
msg_ok "GitLab installed successfully"

# Extract and display the initial root password
if [ -f /etc/gitlab/initial_root_password ]; then
  INITIAL_PASSWORD=$(grep 'Password:' /etc/gitlab/initial_root_password | cut -d' ' -f2)
  echo -e "${INFO}${YW} Initial Login Credentials:${CL}"
  echo -e "${TAB}${GATEWAY}${BGN}Username: root${CL}"
  echo -e "${TAB}${GATEWAY}${BGN}Password: ${INITIAL_PASSWORD}${CL}"
  echo -e ""
  echo -e "${WARN}${RD}IMPORTANT: This password file will be deleted in 24 hours!${CL}"
  echo -e "${INFO}${YW}Please log in and change your password immediately.${CL}"
  echo -e ""
fi

echo -e "${INFO}${YW} GitLab Web Interface:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}${EXTERNAL_URL}${CL}"
echo -e ""
echo -e "${INFO}${YW} Initial setup may take 2-5 minutes. Wait for the login page.${CL}"
echo -e ""
echo -e "${INFO}${YW} Next Steps:${CL}"
echo -e "${TAB}1. Log in and change the root password${CL}"
echo -e "${TAB}2. Create additional admin/user accounts${CL}"
echo -e "${TAB}3. Configure CI/CD by installing GitLab Runner (separate script)${CL}"
echo -e "${TAB}4. Set up email notifications for password resets${CL}"
echo -e ""
echo -e "${INFO}${YW} Useful Commands:${CL}"
echo -e "${TAB}gitlab-ctl status          # Check service status${CL}"
echo -e "${TAB}gitlab-ctl tail            # View logs${CL}"
echo -e "${TAB}gitlab-rake gitlab:check   # Health check${CL}"
echo -e "${TAB}gitlab-ctl backup-etc      # Backup configuration${CL}"
echo -e ""
echo -e "${INFO}${YW} NOTE: Monitor disk usage as repositories grow.${CL}"
echo -e "${TAB}Use 'df -h' and consider expanding if usage exceeds 80%.${CL}"

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
