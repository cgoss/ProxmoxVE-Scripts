#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

# Copyright (c) 2021-2025 community-scripts ORG
# Author: opencode
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://gitlab.com/gitlab-org/gitlab

APP="GitLab"
var_tags="${var_tags:-git}"

# Resource allocation based on expected usage:
# Minimum (1-5 users):  1 CPU,  2GB RAM, 10GB disk (memory-constrained)
# Small (5-100 users):  2 CPU,  4GB RAM, 20GB disk
# Medium (100-500):     4 CPU,  8GB RAM, 50GB disk
# Large (500-1000):     8 CPU, 16GB RAM, 100GB disk
# Enterprise (1000+):   16 CPU, 32GB RAM, 250GB disk

var_cpu="${var_cpu:-2}"      # Small installation (default)
var_ram="${var_ram:-4096}"   # Small installation (default)
var_disk="${var_disk:-20}"   # Adjust based on expected repo size
var_os="${var_os:-debian}"
var_version="${var_version:-12}"  # Debian 12 (bookworm) – stable and GitLab-supported
var_unprivileged="${var_unprivileged:-1}"
var_nesting="${var_nesting:-1}"  # needed for Docker‑in‑LXC (GitLab uses Docker‑like services)

header_info "$APP"
variables
color
catch_errors

#########################
#   UPDATE ROUTINE      #
#########################
function update_script() {
  header_info
  check_container_storage
  check_container_resources

  # Verify that GitLab is actually installed
  if ! dpkg -l | grep -qE '^ii\s+gitlab-'; then
    msg_error "No ${APP} installation found!"
    exit 1
  fi

  # Check GitLab status before updating
  msg_info "Checking GitLab health before update"
  if ! gitlab-rake gitlab:check SANITIZE=true; then
    msg_warn "GitLab health check failed. Review issues before updating."
    read -r -p "Continue anyway? [y/N]: " CONTINUE
    [[ ! "$CONTINUE" =~ ^([yY][eE][sS]|[yY])$ ]] && exit 0
  fi
  msg_ok "GitLab health check passed"

  # Backup configuration
  msg_info "Creating configuration backup"
  $STD gitlab-ctl backup-etc
  msg_ok "Configuration backed up"

  # Update package list
  msg_info "Updating ${APP} package list"
  $STD apt-get update

  # Show available version
  CURRENT=$(gitlab-rake gitlab:env:info | grep "GitLab information" -A 20 | grep "GitLab:" | awk '{print $2}')
  AVAILABLE=$(apt-cache policy gitlab-ce gitlab-ee | grep Candidate | head -1 | awk '{print $2}')
  msg_info "Current version: ${CURRENT}"
  msg_info "Available version: ${AVAILABLE}"

  if [ "$CURRENT" = "$AVAILABLE" ]; then
    msg_ok "Already on latest version"
    exit 0
  fi

  read -r -p "${TAB3}Proceed with upgrade to ${AVAILABLE}? [y/N]: " CONFIRM
  [[ ! "$CONFIRM" =~ ^([yY][eE][sS]|[yY])$ ]] && exit 0

  # Perform upgrade
  msg_info "Upgrading GitLab (this may take several minutes)"
  $STD apt-get install -y --only-upgrade gitlab-ee gitlab-ce
  msg_ok "GitLab upgraded successfully!"

  # Verify upgrade
  msg_info "Running post-upgrade health check"
  if gitlab-rake gitlab:check SANITIZE=true; then
    msg_ok "Health check passed"
  else
    msg_warn "Post-upgrade health check reported issues. Review with 'gitlab-rake gitlab:check'"
  fi

  exit 0
}
#########################

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:80${CL}"
