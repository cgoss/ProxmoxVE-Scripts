#!/usr/bin/env bash

function default_settings() {
  CT_TYPE="1"  # Unprivileged
  PW=""
  CT_ID=""
  HN="$NSAPP"
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  FUSE="no"
  NESTING="yes"  # Required for Docker-like services
}
