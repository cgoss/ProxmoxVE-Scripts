#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

# Copyright (c) 2021-2025 community-scripts ORG
# Author: opencode
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://gitlab.com/gitlab-org/gitlab

APP="GitLab"
var_tags="${var_tags:-git}"
var_cpu="${var_cpu:-4}"
var_ram="${var_ram:-8192}"
var_disk="${var_disk:-20}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"  # Debian 13 (bookworm) – current stable base
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

  msg_info "Updating ${APP} package list"
  $STD apt-get update

  msg_info "Upgrading GitLab packages"
  $STD apt-get install -y --only-upgrade gitlab-ee gitlab-ce   # whichever is present will be upgraded
  msg_ok "GitLab updated successfully!"

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
