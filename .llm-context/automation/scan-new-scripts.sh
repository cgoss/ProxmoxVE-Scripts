#!/usr/bin/env bash

# scan-new-scripts.sh - Scan for scripts by other users

# Copyright (c) 2021-2025 community-scripts ORG
# Author: ProxmoxVE LLM Context System
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

SCRIPT_DIR="ct"
METADATA_DIR="frontend/public/json"
OUTPUT_DIR=".llm-context/scripts"
INDEX_FILE=".llm-context/index.md"
CHANGELOG_FILE=".llm-context/CHANGELOG.md"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

# Messages
msg_info() {
  echo -e "${GREEN}[INFO] $*"
}

msg_warn() {
  echo -e "${YELLOW}[WARN] $*"
}

msg_error() {
  echo -e "${RED}[ERROR] $*"
}

msg_success() {
  echo -e "${GREEN}[SUCCESS] $*"
}

# Get all CT scripts
get_all_scripts() {
  ls -1 "$SCRIPT_DIR"/*.sh | sed 's/\.sh$//' | sort
}

# Get all context files
get_existing_contexts() {
  local contexts=($(ls -1 "$OUTPUT_DIR"/*.md 2>/dev/null | sed 's/\.md$//' | sort))
  echo "${contexts[@]}"
}

# Scan for scripts without context
scan_missing_contexts() {
  local all_scripts=($(get_all_scripts))
  local all_contexts=($(get_existing_contexts))
  local missing_scripts=()
  local found_count=0
  local missing_count=0

  msg_info "Scanning for scripts without context files..."

  for script in "${all_scripts[@]}"; do
    local context_file="$OUTPUT_DIR/${script%.sh}.md"

    if [[ -f "$context_file" ]]; then
      ((found_count++))
      msg_ok "Found context for: $script"
    else
      ((missing_count++))
      msg_warn "MISSING context for: $script"
      missing_scripts+=("$script")
    fi
  done

  # Output summary
  msg_info "Found: $found_count scripts with context files"
  msg_warn "MISSING: $missing_count scripts without context files"

  if [[ ${missing_count[@]} -gt 0 ]]; then
    msg_warn "⚠  Scripts by other users detected:"
    echo ""
    for script in "${missing_scripts[@]}"; do
      echo "  - $script"
    done
    echo ""
    msg_warn "REMINDER: These scripts may have been added by other users who didn't run context-aware updater."
    echo ""
    echo "REMINDER: Run bash .llm-context/automation/generate-context.sh to generate context for these scripts."
  else
    msg_success "All CT scripts have context files."
  fi
}

# Check for scripts with context but missing CT script
check_orphan_contexts() {
  local all_contexts=($(get_existing_contexts))
  local orphans=()

  for context_file in "${all_contexts[@]}"; do
    local script_name="${context_file%.md}"
    local ct_script="$SCRIPT_DIR/${script_name}.sh"

    if [[ ! -f "$ct_script" ]]; then
      orphans+=("$script_name")
      msg_warn "Context exists but CT script missing: $script_name"
    fi
  done

  if [[ ${orphans[@]} -gt 0 ]]; then
    msg_warn "Found ${#orphans[@]} orphans (context exists without CT script)"
    for orphan in "${orphans[@]}"; do
      echo "  - $orphan (CT script may have been deleted)"
    done
  fi
}

# Check for CT scripts with context but missing install script
check_missing_install_scripts() {
  local all_scripts=($(get_all_scripts))
  local missing=()

  for script in "${all_scripts[@]}"; do
    local install_script="${SCRIPT_DIR}/${script%.sh}-install.sh"

    if [[ ! -f "$install_script" ]]; then
      msg_warn "MISSING install script: ${script}-install.sh"
      missing+=("${script}-install.sh")
    fi
  done

  if [[ ${missing[@]} -gt 0 ]]; then
    msg_warn "Found ${#missing[@]} install scripts missing context files"
    for miss in "${missing[@]}"; do
      echo "  - $miss (requires CT script)"
    done
    fi
}

# Check for scripts with CT but missing JSON metadata
check_missing_metadata() {
  local all_contexts=($(get_existing_contexts))
  local missing_jsons=()

  for context_file in "${all_contexts[@]}"; do
    local script_name="${context_file%.md}"
    local json_file="$METADATA_DIR/${script_name}.json"

    if [[ ! -f "$json_file" ]]; then
      msg_warn "MISSING JSON metadata: $script.json"
      missing_jsons+=("$script.json")
    fi
  done

  if [[ ${missing_jsons[@]} -gt 0 ]]; then
    msg_warn "Found ${#missing_jsons[@]} JSON metadata files missing"
    for miss in "${missing_jsons[@]}"; do
      echo "  - $miss"
    done
  fi
}

# Main function
main() {
  msg_info "Scanning ProxmoxVE scripts..."

  # Check for required directories
  if [[ ! -d "$SCRIPT_DIR" ]]; then
    msg_error "Required directory not found: $SCRIPT_DIR"
    exit 1
  fi

  if [[ ! -d "$OUTPUT_DIR" ]]; then
    msg_error "Required directory not found: $OUTPUT_DIR"
    msg_info "Run .llm-context/automation/generate-context.sh first to create context files"
    exit 1
  fi

  if [[ ! -d "$METADATA_DIR" ]]; then
    msg_warn "Metadata directory not found: $METADATA_DIR"
    msg_info "JSON metadata checking will be skipped"
  fi

  # Get all scripts and contexts
  local all_scripts=($(get_all_scripts))
  local all_contexts=($(get_existing_contexts))

  msg_info "Total CT scripts: ${#all_scripts[@]}"
  msg_info "Total context files: ${#all_contexts[@]}"

  # Scan for missing context files
  scan_missing_contexts

  # Check for orphaned contexts
  check_orphan_contexts

  # Check for missing install scripts
  check_missing_install_scripts

  # Check for missing JSON metadata
  check_missing_metadata

  # Output summary
  msg_info "Scan complete!"
  msg_info "--------"
  msg_success "Next steps:"
  msg_info "1. Run bash .llm-context/automation/generate-context.sh to generate missing context files"
  msg_info "2. Populate category files with script listings"
  msg_info "3. Update index.md with new scripts"
  msg_info "4. Run bash .llm-context/automation/update-index.sh to update indexes"
  msg_info "5. Document any patterns discovered"
  msg_info "6. Review and validate generated context files"
  msg_info ""
  msg_info "--------"
  msg_info "REMINDER: This script helps identify scripts added by other users who didn't run context-aware updater."
  msg_info "Always scan before major updates to ensure coverage."
  exit 0
}

# Run main
main "$@"