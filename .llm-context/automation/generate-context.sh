#!/usr/bin/env bash

# generate-context.sh - Auto-generate context for new scripts

# Copyright (c) 2021-2025 community-scripts ORG
# Author: ProxmoxVE LLM Context System
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: .llm-context/README.md

# Description:
# Analyzes CT and install scripts to automatically generate context files
# Uses existing templates to ensure consistency
# Updates index.md and category files with new scripts

set -e

SCRIPT_DIR="ct"
INSTALL_DIR="install"
OUTPUT_DIR=".llm-context/scripts"
METADATA_DIR="frontend/public/json"
CHANGELOG=".llm-context/CHANGELOG.md"
INDEX_FILE=".llm-context/index.md"

# Colors for output
CREATING='\033[0;32m'
GN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CL='\033[0;37m'

# Counter
CONTEXT_CREATED=0
CONTEXTS_SKIPPED=0
ERRORS=0

# Helper functions
msg() {
  echo -e "${2}$(date '+%Y-%m-%d %H:%M:%S')"
}

info() {
  echo -e "${INFO}[INFO] $*"
}

success() {
  echo -e "${GN}[SUCCESS] $*"
}

warn() {
  echo -e "${YELLOW}[WARN] $*"
}

error() {
  echo -e "${RED}[ERROR] $*"
}

# Check if directories exist
check_dirs() {
  if [[ ! -d "$SCRIPT_DIR" ]]; then
    error "Script directory not found: $SCRIPT_DIR"
    return 1
  fi
  if [[ ! -d "$INSTALL_DIR" ]]; then
    error "Install script directory not found: $INSTALL_DIR"
    return 1
  fi
  if [[ ! -d "$METADATA_DIR" ]]; then
    error "Metadata directory not found: $METADATA_DIR"
    return 1
  fi
}

# Get all CT scripts
get_all_scripts() {
  local scripts=($(ls -1 "$SCRIPT_DIR"/*.sh 2>/dev/null | sed 's/\.sh$//'))
  echo "${scripts[@]}"
}

# Get script names without extension
get_script_names() {
  local scripts=($(get_all_scripts))
  local names=()
  for script in "${scripts[@]}"; do
    names+=("$(basename "$script")")
  done
  echo "${names[@]}"
}

# Parse CT script header
parse_ct_header() {
  local script="$1"

  if [[ ! -f "$script" ]]; then
    return 1
  fi

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

  while IFS= read -r line; do
    # Debug: Print first few lines
    # [[ ${line_count:-0} -lt 10 ]] && echo "DEBUG Line: $line" >&2
    # line_count=$((line_count + 1))

    # APP variable
    if [[ "$line" =~ ^APP= ]]; then
      app_name="${line#*=\"}"
      app_name="${app_name%\"}"
      #echo "DEBUG: APP matched, app_name=$app_name" >&2
    fi

    # var_tags - extract default value from ${var_tags:-value} pattern
    if [[ "$line" =~ ^var_tags= ]]; then
      tags="${line#*=\"}"
      tags="${tags%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$tags" =~ \$\{[^}]*:-(.*)\} ]]; then
        tags="${BASH_REMATCH[1]}"
      fi
    fi

    # var_cpu - extract default value from ${var_cpu:-value} pattern
    if [[ "$line" =~ ^var_cpu= ]]; then
      cpu="${line#*=\"}"
      cpu="${cpu%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$cpu" =~ \$\{[^}]*:-(.*)\} ]]; then
        cpu="${BASH_REMATCH[1]}"
      fi
    fi

    # var_ram - extract default value from ${var_ram:-value} pattern
    if [[ "$line" =~ ^var_ram= ]]; then
      ram="${line#*=\"}"
      ram="${ram%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$ram" =~ \$\{[^}]*:-(.*)\} ]]; then
        ram="${BASH_REMATCH[1]}"
      fi
    fi

    # var_disk - extract default value from ${var_disk:-value} pattern
    if [[ "$line" =~ ^var_disk= ]]; then
      disk="${line#*=\"}"
      disk="${disk%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$disk" =~ \$\{[^}]*:-(.*)\} ]]; then
        disk="${BASH_REMATCH[1]}"
      fi
    fi

    # var_os - extract default value from ${var_os:-value} pattern
    if [[ "$line" =~ ^var_os= ]]; then
      os="${line#*=\"}"
      os="${os%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$os" =~ \$\{[^}]*:-(.*)\} ]]; then
        os="${BASH_REMATCH[1]}"
      fi
    fi

    # var_version - extract default value from ${var_version:-value} pattern
    if [[ "$line" =~ ^var_version= ]]; then
      version="${line#*=\"}"
      version="${version%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$version" =~ \$\{[^}]*:-(.*)\} ]]; then
        version="${BASH_REMATCH[1]}"
      fi
    fi

    # var_unprivileged - extract default value from ${var_unprivileged:-value} pattern
    if [[ "$line" =~ ^var_unprivileged= ]]; then
      unprivileged="${line#*=\"}"
      unprivileged="${unprivileged%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$unprivileged" =~ \$\{[^}]*:-(.*)\} ]]; then
        unprivileged="${BASH_REMATCH[1]}"
      fi
    fi

    # Check for special variables
    if [[ "$line" =~ ^var_gpu= ]]; then
      gpu="${line#*=\"}"
      gpu="${gpu%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$gpu" =~ \$\{[^}]*:-(.*)\} ]]; then
        gpu="${BASH_REMATCH[1]}"
      fi
    fi

    if [[ "$line" =~ ^var_fuse= ]]; then
      fuse="${line#*=\"}"
      fuse="${fuse%\"}"
      # Extract default value if in ${var:-default} format
      if [[ "$fuse" =~ \$\{[^}]*:-(.*)\} ]]; then
        fuse="${BASH_REMATCH[1]}"
      fi
    fi

    if [[ "$line" =~ ^var_tun= ]] || [[ "$line" =~ ^var_tun=1 ]]; then
      tun="yes"
    fi

    if [[ "$line" =~ ^var_nesting= ]]; then
      nesting="yes"
    fi
  done

  # Debug: Print values
  echo "DEBUG: app_name=$app_name, tags=$tags, cpu=$cpu, ram=$ram, disk=$disk, os=$os, version=$version" >&2

  echo "$app_name|$tags|$cpu|$ram|$disk|$os|$version|$unprivileged|$gpu|$fuse|$tun|$nesting"
}

# Check for install script
check_install_script() {
  local script_name="${1%.sh}"

  if [[ ! -f "$INSTALL_DIR/$script_name-install.sh" ]]; then
    # No install script, no interactive prompts
    echo "no_install"
    return 0
  fi

  # Parse install script for prompts
  local prompts=()

  while IFS= read -r line; do
    # Stop when we reach the main logic (after source functions)
    [[ "$line" =~ ^source\ /dev/stdin ]] && break

    # Check for read -p prompts (interactive)
    if [[ "$line" =~ read\ -r\ -p ]]; then
      prompts+=("${line#*=\"} ")
    fi
  done

  if [[ ${#prompts[@]} -gt 0 ]]; then
    echo "has_prompts"
  else
    echo "no_prompts"
  fi
}

# Generate context file
generate_context() {
  local script="$1"
  local script_name=$(basename "$script" .sh)

  msg "Generating context for: $script_name"

  # Parse CT header
  local ct_header=$(parse_ct_header "$script")
  IFS='|' read -r app tags cpu ram disk os version unprivileged gpu fuse tun nesting <<< "$ct_header"

  # Check for install script
  local has_install="no"
  local install_exists="no"
  local interactive_prompts=""

  if check_install_script "$script_name"; then
    install_exists="yes"
  fi

  if check_install_script "$script_name"; then
    interactive_prompts=$(check_install_script "$script_name")
  fi

  # Determine section
  local sorted_scripts=($(get_all_scripts | sort))
  local script_index=0
  for s in "${sorted_scripts[@]}"; do
    if [[ "$s" == "$script" ]]; then
      script_index=$script_index
      break
    fi
    ((script_index++))
  done

  local section_num=$((script_index / 10 + 1))
  local section_dir="$OUTPUT_DIR/section-$(printf "%02d" $section_num)"

  mkdir -p "$section_dir"

  # Find corresponding JSON metadata
  local json_file="$METADATA_DIR/${script_name}.json"
  local app_description=""
  local categories=""
  local app_name=""
  local default_cpu=""
  local default_ram=""
  local default_disk=""
  local default_os=""
  local default_version=""

  if [[ -f "$json_file" ]]; then
    # Get all metadata from JSON
    app_description=$(jq -r '.description' "$json_file" 2>/dev/null || echo "")
    categories=$(jq -r '.categories[]' "$json_file" 2>/dev/null | tr '\n' ',' || echo "")
    app_name=$(jq -r '.name' "$json_file" 2>/dev/null || echo "")
    
    # Get default install method resources
    default_cpu=$(jq -r '.install_methods[0].resources.cpu // 2' "$json_file" 2>/dev/null || echo "2")
    default_ram=$(jq -r '.install_methods[0].resources.ram // 2048' "$json_file" 2>/dev/null || echo "2048")
    default_disk=$(jq -r '.install_methods[0].resources.hdd // 4' "$json_file" 2>/dev/null || echo "4")
    default_os=$(jq -r '.install_methods[0].resources.os // "debian"' "$json_file" 2>/dev/null || echo "debian")
    default_version=$(jq -r '.install_methods[0].resources.version // "12"' "$json_file" 2>/dev/null || echo "12")
    
    # Fix categories formatting (remove trailing comma if single category)
    categories="${categories%,}"
  else
    app_description="${script_name} service"
    categories="0"  # Default to miscellaneous
    app_name="${script_name}"
    default_cpu="2"
    default_ram="2048"
    default_disk="4"
    default_os="debian"
    default_version="12"
  fi

  # Determine install methods
  local install_methods=""
  if [[ "$default_os" =~ alpine ]]; then
    install_methods="Alpine variant available"
  fi
  install_methods="Default ($default_os $default_version)${install_methods:+, $install_methods}"

  # Calculate GB value for display
  local ram_gb=$((default_ram / 1024))

  # Create context file
  cat > "$section_dir/${script_name}.md" << EOF
# ${script_name} Context

## Basic Information

- **Name**: ${app_name}
- **Slug**: ${script_name}
- **Categories**: [${categories}]

## Description

${app_description}

## Resources by Install Method

 ### Default Install
 - **CPU**: ${default_cpu} cores
 - **RAM**: ${default_ram} MB (${default_ram} MB = ${ram_gb} GB)
 - **Disk**: ${default_disk} GB
 - **OS**: ${default_os} ${default_version}
 - **Privileged**: ${unprivileged}
 - **Updateable**: Yes
 EOF

   # Add OS section if Alpine variant exists
   if [[ "$default_os" =~ alpine ]]; then
     cat >> "$section_dir/${script_name}.md" << EOF
 
 ### Alpine Install
 - **CPU**: 1 core (typical for Alpine)
 - **RAM**: 512 MB ($((default_ram / 2)) MB = $((default_ram / 2048)) GB - Alpine typically uses ~50% less RAM
 - **Disk**: 2 GB (typical for Alpine)
 - **OS**: Alpine ${default_version}
 - **Privileged**: ${unprivileged}
 - **Updateable**: Yes
 EOF
   fi

  # Add access information if available
  local interface_port=$(jq -r '.interface_port // empty' "$json_file" 2>/dev/null)
  local web_url=$(jq -r '.website // empty' "$json_file" 2>/dev/null)
  local doc_url=$(jq -r '.documentation // empty' "$json_file" 2>/dev/null)
  local config_path=$(jq -r '.config_path // empty' "$json_file" 2>/dev/null)

  if [[ "$interface_port" != "null" && "$interface_port" != "false" ]]; then
    cat >> "$section_dir/${script_name}.md" << EOF

## Access Information

- **Interface Port**: ${interface_port}
- **Web URL**: ${web_url}
- **Documentation**: ${doc_url}
- **Configuration Path**: ${config_path}
EOF
  fi

  # Add special requirements if any
  if [[ -n "$gpu" ]] || [[ -n "$fuse" ]] || [[ -n "$tun" ]]; then
    cat >> "$section_dir/${script_name}.md" << EOF

## Special Requirements

EOF

    if [[ -n "$gpu" ]]; then
      echo "- **GPU Passthrough**: Required for this service" >> "$section_dir/${script_name}.md"
    fi
    if [[ -n "$fuse" ]]; then
      echo "- **FUSE Support**: Required for this service" >> "$section_dir/${script_name}.md"
    fi
    if [[ -n "$tun" ]]; then
      echo "- **TUN/TAP Support**: Required for this service" >> "$section_dir/${script_name}.md"
    fi

  cat >> "$section_dir/${script_name}.md" << EOF
- var_gpu="${gpu}" (set in environment)
EOF
  fi

  # Add OS support information
  cat >> "$section_dir/${script_name}.md" << EOF

## OS Support

- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle
EOF

  if [[ "$os" =~ alpine ]]; then
    cat >> "$section_dir/${script_name}.md" << EOF

- **Alpine ${version}: Minimal, secure, ~200MB less RAM, limited packages
EOF
  fi

  # Add install script information
  cat >> "$section_dir/${script_name}.md" << EOF

## Install Script: ${script_name}-install.sh

### Interactive Prompts

EOF

  if [[ "$interactive_prompts" == "has_prompts" ]]; then
    echo "Detected interactive prompts" >> "$section_dir/${script_name}.md"

    # List prompts (simplified)
    grep -n "read -r -p" "$INSTALL_DIR/$script_name-install.sh" | head -20 | \
    while IFS= read -r line; do
      # Extract prompt text
      if [[ "$line" =~ read\ -r\ -p ]]; then
        prompt_text="${line#*=\"}"
        # Remove leading prompt text
        prompt_text="${prompt_text#*}"
        prompt_text="${prompt_text%\"*}"  # Remove trailing quotes
        echo "- ${prompt_text}" >> "$section_dir/${script_name}.md"
      fi
    done
  fi

  cat >> "$section_dir/${script_name}.md" << EOF

## Non-Interactive Execution Examples
 
### Default Settings (Use Script Defaults)
\`\`\`bash
var_cpu=${default_cpu} var_ram=${default_ram} var_disk=${default_disk} bash ${SCRIPT_DIR}/${script_name}.sh
\`\`\`

### With Resource Overrides
\`\`\`bash
var_cpu=4 var_ram=8192 var_disk=20 bash ${SCRIPT_DIR}/${script_name}.sh
\`\`\`

### With Storage Selection
\`\`\`bash
var_storage=local-lvm bash ${SCRIPT_DIR}/${script_name}.sh
\`\`\`

### Providing Script-Specific Answers (via stdin)
\`\`\`bash
# If script has interactive prompts, provide answers line by line:
echo -e "y\nn\ny" | var_cpu=2 var_ram=2048 bash ${SCRIPT_DIR}/${script_name}.sh
\`\`\`

### Combined Example (Full Configuration)
\`\`\`bash
var_cpu=4 var_ram=8192 var_disk=20 var_storage=local-lvm bash ${SCRIPT_DIR}/${script_name}.sh <<< "n\nn\nn"
\`\`\`


## Related Scripts

- **Alpine Variant**: Check for ${script_name/alpine.sh} if exists

EOF

  # Update counters
  ((CONTEXT_CREATED++))
  echo "Created context for: $script_name"

  return 0
}

# Main execution
main() {
  msg "Starting context generation..."

  check_dirs

  # Get all scripts
  local scripts=($(get_all_scripts))
  local total=${#scripts[@]}

  msg "Found $total CT scripts to process"

  # Process each script
  for script in "${scripts[@]}"; do
    # Skip if already has context
    if [[ -f "$OUTPUT_DIR/${script%.sh}.md" ]]; then
      ((CONTEXTS_SKIPPED++))
      warn "Context already exists, skipping: $script"
      continue
    fi

    # Check for errors
    if ! generate_context "$script"; then
      ((ERRORS++))
      error "Failed to generate context for: $script"
    fi

  done

  msg "Context generation complete!"
  success "Created $CONTEXT_CREATED context files, skipped $CONTEXTS_SKIPPED, encountered $ERRORS errors"

  msg "Next steps:"
  echo "1. Run: .llm-context/automation/update-index.sh to update master index with new scripts"
  msg "2. Review generated context files for accuracy"
  msg "3. Populate category files with script listings"
  msg "4. Update CHANGELOG.md with Phase 4 completion"
  msg "5. Consider creating script-specific contexts for high-priority services"

  # Final summary
  echo ""
  echo "Summary:"
  echo "--------"
  echo "Scripts analyzed: $total"
  echo "Contexts created: $CONTEXT_CREATED"
  echo "Scripts skipped: $CONTEXTS_SKIPPED"
  echo "Errors encountered: $ERRORS"
  echo ""
  echo "Next:"
  echo "- Populate category files with script listings"
  echo "- Create script-specific contexts manually for important services"
  echo "- Update CHANGELOG.md with Phase 4 completion"

  exit 0
}

# Run main if executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
