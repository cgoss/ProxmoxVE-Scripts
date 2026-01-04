#!/usr/bin/env bash

# list-ct-scripts.sh - List all CT scripts for automation

set -e

# Directories
SCRIPT_DIR="ct"
OUTPUT_DIR=".llm-context/scripts"
CHANGELOG=".llm-context/CHANGELOG.md"

# Colors
CREATING='\033[0;32m'
GN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CL='\033[0;37m'

# Counters
TOTAL_SCRIPTS=0
PROCESSED=0
FAILED=0
SKIPPED=0

# Helper functions
log_info() {
  echo -e "${INFO}[INFO] $*"
}

log_success() {
  echo -e "${GN}[SUCCESS] $*"
}

log_warn() {
  echo -e "${YELLOW}[WARN] $*"
}

log_error() {
  echo -e "${RED}[ERROR] $*"
}

# Check if script already has context
has_context() {
  local script="$1"
  local context_file="$OUTPUT_DIR/${script%.sh}.md"

  [[ -f "$context_file" ]] && return 0 || return 1
}

# Get all CT scripts
get_all_scripts() {
  ls -1 "$SCRIPT_DIR"/*.sh | sed 's/\.sh$//' | sort
}

# Get all existing context files
get_existing_contexts() {
  [[ ! -d "$OUTPUT_DIR" ]] && return 1

  local existing_contexts=($(ls -1 "$OUTPUT_DIR"/*.md 2>/dev/null | sed 's/\.md$//' | wc -l))

  if [[ ${existing_contexts[*]} -eq 0 ]]; then
    log_info "No existing context files found in $OUTPUT_DIR"
  fi

  echo "${existing_contexts[@]}"
}

# Generate context file for a script
generate_context() {
  local script="$1"
  local context_file="$OUTPUT_DIR/${script%.sh}.md"

  # Check if already exists
  if has_context "$script"; then
    log_warn "Context file already exists: $context_file"
    return 1
  fi

  log_info "Generating context for: $script"

  # Parse CT script header
  local app_name=""
  local tags=""
  local cpu=""
  local ram=""
  local disk=""
  local os=""
  local version=""
  local unprivileged=""
  local gpu=""
  local fuse=""
  local tun=""
  local nesting=""

  local line_num=0
  while IFS= read -r line; do
    ((line_num++))

    case "$line" in
      *APP=*)
        app_name="${line#*=}"
        ;;
      *var_tags=*)
        tags="${line#*=}"
        ;;
      *var_cpu=*)
        cpu="${line#*=}"
        ;;
      *var_ram=*)
        ram="${line#*=}"
        ;;
      *var_disk=*)
        disk="${line#*=}"
        ;;
      *var_os=*)
        os="${line#*=}"
        ;;
      *var_version=*)
        version="${line#*=}"
        ;;
      *var_unprivileged=*)
        unprivileged="${line#*=}"
        ;;
      *var_gpu=*)
        gpu="${line#*=}"
        ;;
      *var_fuse=*)
        fuse="${line#*=}"
        ;;
      *var_tun=*)
        tun="${line#*=}"
        ;;
      *var_nesting=*)
        nesting="${line#*=}"
        ;;
    esac

    # Stop after reading header (lines 1-17 for typical scripts)
    [[ $line_num -ge 17 ]] && break
  done

  # Check for install script
  local install_script="$INSTALL_DIR/${script%.sh}-install.sh"
  local interactive_prompts=""

  if [[ -f "$install_script" ]]; then
    # Parse install script for interactive prompts
    local line_num=0
    while IFS= read -r line; do
      ((line_num++))

      # Stop at end of script or when we reach header again
      [[ $line == "header_info \"$APP\"" ]] && break

      # Detect read -p prompts
      if [[ "$line" =~ read\ -r\ -p.*\" ]]; then
        prompt_text=$(echo "$line" | sed -E 's/.*read -r -p[[:space:]]+(.+)//' | sed -E 's/^[[:space:]]+//')

        if [[ -n "$prompt_text" ]]; then
          interactive_prompts+="$prompt_text"$'\n'
        fi
      fi

      ((line_num++))
    done
  fi

  # Get JSON metadata if exists
  local json_file="$METADATA_DIR/${script%.sh}.json"
  local json_description=""
  local json_categories=""
  local json_interface_port=""
  local json_install_methods=""

  if [[ -f "$json_file" ]]; then
    json_description=$(jq -r '.description' "$json_file" 2>/dev/null || echo "")
    json_categories=$(jq -r '.categories[]' "$json_file" 2>/dev/null || echo "")
    json_interface_port=$(jq -r '.interface_port // empty' "$json_file" 2>/dev/null || echo "")

    if [[ "$json_interface_port" == "null" ]]; then
      json_interface_port="null"
    fi

    # Get install methods
    json_install_methods=$(jq -r '.install_methods // empty' "$json_file" 2>/dev/null || echo "")
  fi

  # Check for Alpine variant
  local alpine_script="$SCRIPT_DIR/alpine-${script}.sh"
  if [[ -f "$alpine_script" ]]; then
    json_install_methods+=", Alpine variant: ${alpine_script}"
    fi
  fi

  # Count interactive prompts
  local prompt_count=$(echo "$interactive_prompts" | grep -c '^$' | wc -l)
  [[ -z "$prompt_count" ]] && prompt_count="0"
  fi
  fi

  # Generate context file
  cat > "$context_file" << CTXTEMPLATE
# ${script%.sh} Context

## Basic Information

- **Name**: ${app_name}
- **Slug**: ${script%.sh}
- **Categories**: [${json_categories}]
- **Tags**: ${tags}

## Description

${json_description}

## Resources by Install Method

### Default Install

- **CPU**: ${cpu} cores
- **RAM**: ${ram} MB (${ram} MB = $((ram / 1024)) GB)
- **Disk**: ${disk} GB
- **OS**: ${os} ${version}
- **Privileged**: ${unprivileged}

### ${json_install_methods%%:*, Alpine Variant: ${alpine_script:-} Not applicable}

## Access Information

EOF

  # Add access information if available
  if [[ "$json_interface_port" != "null" ]]; then
    cat >> "$context_file" << EOF

## Access Information

- **Interface Port**: ${json_interface_port}
- **Access URL**: http://\${IP}:${json_interface_port}

EOF
  fi

  # Add special requirements
  cat >> "$context_file" << EOF

## Special Requirements

EOF

  if [[ -n "$gpu" ]]; then
    cat >> "$context_file" << EOF

- **GPU Passthrough**: Required
  - **Environment Variable**: \`var_gpu=yes\`

EOF
  fi

  if [[ -n "$fuse" ]]; then
    cat >> "$context_file" << EOF

- **FUSE Support**: Required
  - **Environment Variable**: \`var_fuse=yes\`

EOF
  fi

  if [[ -n "$tun" ]] || [[ "$tun" == "1" ]]; then
    cat >> "$context_file" << EOF

- **TUN/TAP Support**: Required
  - **Environment Variable**: \`var_tun=yes\`

EOF
  fi

  if [[ "$nesting" == "1" ]]; then
    cat >> "$context_file" << EOF

- **LXC Nesting**: Required (implicit for Docker-in-LXC)
  - **Environment Variable**: \`var_nesting=1\`

EOF
  fi

  # Add interactive prompts section
  if [[ -n "$interactive_prompts" ]]; then
    cat >> "$context_file" << EOF

## Interactive Prompts (install/${script%.sh}-install.sh)

The install script contains \`${prompt_count}\` interactive prompts:

EOF

    local prompt_num=1
    echo "$interactive_prompts" | while IFS= read -r line; do
      echo "  $prompt_num. ${line#*\"}" | sed 's/^[[:space:]]*//' | sed 's/"//'
      ((prompt_num++))
    done >> "$context_file"
  fi

  # Add OS support section
  cat >> "$context_file" << EOF

## OS Support

EOF

  if [[ "$os" == "debian" ]]; then
    cat >> "$context_file" << EOF
- **Debian 12 (bookworm)**: Current stable LTS
- **Debian 13 (trixie)**: Testing branch

EOF
  elif [[ "$os" == "ubuntu" ]]; then
    cat >> "$context_file" << EOF
- **Ubuntu 22.04 (jammy)**: LTS (April 2027, supported to 2032)
- **Ubuntu 24.04 (noble)**: Current stable LTS (April 2024, supported to 2029)

EOF
  elif [[ "$os" == "alpine" ]]; then
    cat >> "$context_file" << EOF
- **Alpine 3.20**: Current stable
- **Alpine 3.21**: Testing branch
- **Alpine 3.22**: Development branch

EOF
  fi

  # Add update procedure section
  cat >> "$context_file" << EOF

## Update Procedure

The CT script includes an update_script() function. To update, run:

\`\`bash
/usr/bin/update ${script}
\`\`

This will:
1. Check for existing installation
2. Backup configuration and data
3. Download and install latest version
4. Restore configuration and data
5. Restart service

EOF

  # Add related scripts section
  cat >> "$context_file" << EOF

## Related Scripts

EOF

  if [[ -f "$alpine_script" ]]; then
    cat >> "$context_file" << EOF
- **Alpine Variant**: ct/alpine-${script}.sh

EOF
  fi

  log_success "Context file created: $context_file"
  ((CONTEXT_CREATED++))
}

# Process all scripts
process_scripts() {
  local scripts=($(get_all_scripts))
  local count=0

  for script in "${scripts[@]}"; do
    ((count++))

    # Skip if already has context
    if has_context "$script"; then
      log_warn "Context already exists, skipping: $script"
      ((SKIPPED++))
      continue
    fi

    log_info "Processing ($count/$total_scripts): $script"

    # Generate context
    if generate_context "$script"; then
      ((PROCESSED++))
    else
      ((FAILED++))
    fi
  done

  log_success "Processed all scripts"
}

# Update index
update_index() {
  log_info "Updating index.md with all scripts..."

  # This would scan all context files and update index.md
  # Not implementing for now - can be done manually after Phase 5
}

# Main
main() {
  check_dirs

  # Get all scripts
  local scripts=($(get_all_scripts))
  local total=${#scripts[@]}

  if [[ ${#scripts[@]} -eq 0 ]]; then
    log_error "No CT scripts found in $SCRIPT_DIR"
    exit 1
  fi

  log_info "Found $total scripts to process"
  log_info "Starting context generation..."

  # Process all scripts
  process_scripts

  # Update index (would update index.md here)
  update_index

  # Summary
  echo ""
  echo "--------"
  log_success "Context generation complete!"
  echo "--------"
  echo ""
  echo "Total Scripts:     $total"
  echo "  Generated Contexts:  $PROCESSED"
  echo "  Failed:          $FAILED"
  echo "  Skipped:         $SKIPPED"
  echo "--------"

  # Check for unmapped scripts
  log_info ""
  log_info "Unmapped scripts check:"
  echo "The following CT scripts exist but have no context files:"

  local has_context_count=0
  local unmapped_scripts=()

  for script in "${scripts[@]}"; do
    if ! has_context "$script"; then
      unmapped_scripts+=("$script")
      ((has_context_count++))
    fi
  done

  if [[ ${#unmapped_scripts[@]} -gt 0 ]]; then
    log_warn "Found $has_context_count scripts without context files:"
    for script in "${unmapped_scripts[@]}"; do
      echo "  - $script"
    done

    log_warn ""
    log_warn "REMINDER: To create context for unmapped scripts, run:"
    echo ""
    echo "  bash .llm-context/automation/generate-context.sh $script"

    echo ""
  else
    log_info "All scripts have context files"
  fi

  echo "--------"
}

# Run script
if [[ "${1:-}" == "--full" ]]; then
  process_scripts
elif [[ "${1:-}" == "--update-index" ]]; then
  update_index
elif [[ "${1:-}" == "--check" ]]; then
  # Show unmapped scripts
  has_context_count=0
  unmapped_scripts=($(get_existing_contexts | sed 's/\.md$//' | wc -l))

  if [[ ${#unmapped_scripts[@]} -eq 0 ]]; then
    log_info "No unmapped scripts found"
  else
    log_warn "Found ${#unmapped_scripts[@]} scripts without context:"
    for script in "${unmapped_scripts[@]}"; do
      echo "  - $script"
    done
  fi
else
  echo "Usage: $0 [--full] [--update-index] [--check]"
  exit 1
fi
