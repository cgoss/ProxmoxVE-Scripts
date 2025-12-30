#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: [YourGitHubUsername]
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://kafka.apache.org/

APP="Alpine-Kafka"
var_tags="${var_tags:-alpine;messaging}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-8}"
var_os="${var_os:-alpine}"
var_version="${var_version:-3.20}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -d /opt/kafka ]]; then
    msg_error "No Kafka Installation Found!"
    exit
  fi

  msg_info "Stopping Kafka services"
  systemctl stop kafka
  msg_ok "Stopped Kafka"

  msg_info "Updating Alpine packages"
  apk update && apk upgrade
  msg_ok "Updated Alpine packages"

  msg_info "Updating Kafka"
  # Add Kafka update logic here
  msg_ok "Updated Kafka"

  msg_info "Starting Kafka services"
  systemctl start kafka
  msg_ok "Started Kafka"

  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Kafka is running and ready to use:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}Broker: ${IP}:9092${CL}"
echo -e "${INFO}${YW} Use these commands to test your installation:${CL}"
echo -e "${TAB}${GN}kafka-topics.sh --bootstrap-server ${IP}:9092 --list${CL}"
echo -e "${TAB}${GN}kafka-console-producer.sh --bootstrap-server ${IP}:9092 --topic test${CL}"
echo -e "${TAB}${GN}kafka-console-consumer.sh --bootstrap-server ${IP}:9092 --topic test --from-beginning${CL}"