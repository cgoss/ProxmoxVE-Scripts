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
msg_info "Setting up PostgreSQL (13) – required by GitLab"
PG_VERSION="13" setup_postgresql
msg_ok "PostgreSQL ready"

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
EXTERNAL_URL="http://${IPADDRESS}"
sed -i "s|^external_url .*|external_url '${EXTERNAL_URL}'|g" /etc/gitlab/gitlab.rb

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
echo -e "${INFO}${YW} Open your browser at:${CL} ${TAB}${GATEWAY}${BGN}${EXTERNAL_URL}${CL}"

motd_ssh
customize
cleanup_lxc
