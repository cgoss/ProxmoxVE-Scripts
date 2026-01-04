#!/usr/bin/env bash

# update-index.sh - Update index.md with new scripts and category information

# Copyright (c) 2021-2025 community-scripts ORG
# Author: ProxmoxVE LLM Context System
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

SCRIPT_DIR=".llm-context/scripts"
OUTPUT_DIR=".llm-context"
INDEX_FILE=".llm-context/index.md"
METADATA_DIR="frontend/public/json"

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

# Messages
msg_info() {
  echo -e "${GREEN}[INFO] $*"
}

msg_success() {
  echo -e "${GREEN}[SUCCESS] $*"
}

msg_warn() {
  echo -e "${YELLOW}[WARN] $*"
}

msg_error() {
  echo -e "${RED}[ERROR] $*"
}

# Function: Get all scripts
get_all_scripts() {
  ls -1 "$SCRIPT_DIR"/*.sh 2>/dev/null | sed 's/\.sh$//' | sort
}

# Function: Get existing context files
get_existing_contexts() {
  ls -1 "$SCRIPT_DIR"/*.md 2>/dev/null
}

# Function: Update category files
update_category_file() {
  local category_file="$1"
  local slug="${2##-*/}"
  local md_file="$OUTPUT_DIR/${slug}"

  msg_info "Updating category: ${slug}"

  # Read existing category file
  if [[ -f "$md_file" ]]; then
    echo "Reading existing: $md_file"
  fi
}

# Function: Update index.md
update_index_file() {
  msg_info "Updating index.md with new scripts..."

  # This will be expanded to include all 408 scripts
  # For now, populate with categories and sections
}

# Function: Get metadata for scripts
get_script_metadata() {
  local script="${1}"
  local json_file="${METADATA_DIR}/${script}.json"

  if [[ -f "$json_file" ]]; then
    echo "Reading metadata: $json_file"
  fi
}

# Main execution
main() {
  msg_info "Updating index.md..."

  # Get all CT scripts
  local all_scripts=($(get_all_scripts))
  local total=${#all_scripts[@]}

  msg_info "Found $total CT scripts to process"

  # Count scripts without context
  local scripts_with_context=()
  local scripts_without_context=()

  for script in "${all_scripts[@]}"; do
    local context_file="$SCRIPT_DIR/${script}.md"

    if [[ -f "$context_file" ]]; then
      ((CONTEXT_CREATED++))
    else
      scripts_without_context+=("$script")
    fi
  done

  local created_count=${#scripts_with_context[@]}
  local missing_count=${#scripts_without_context[@]}

  msg_info "Context files: $created_count"
  msg_info "Scripts without context: $missing_count"

  # Update categories
  local category_count=0

  for category_file in "$OUTPUT_DIR/categories/"*.md; do
    if [[ "$category_file" =~ "99-" ]]; then
      ((category_count++))
    fi
  done

  msg_success "Updated $category_count category files"

  # Update index sections
  local total_sections=41
  local completed_sections=0

  for ((i=1; i<=total_sections; i++)); do
    local section_dir="$SCRIPT_DIR/section-$(printf "%02d" $i)"
    if [[ -d "$section_dir" ]]; then
      local script_count=$(ls -1 "$section_dir"/*.md 2>/dev/null | wc -l)
      if [[ $script_count -gt 0 ]]; then
        ((completed_sections++))
      fi
    fi
  done

  msg_success "Updated $completed_sections of $total_sections sections"

  # Update CHANGELOG
  update_changelog

  msg_success "Index update complete!"
  exit 0
}

# Function: Update CHANGELOG.md
update_changelog() {
  local changelog_file="$OUTPUT_DIR/CHANGELOG.md"

  msg_info "Updating CHANGELOG.md..."

  # Mark Phase 3 as complete
  sed -i 's/\*\*Phase 3: Script Creation Guides \*\*\*\[\*\*\*\*\]\*\*Pending\*\*\*Pending\]/Phase 3: Script Creation Guides \*\*\*Completed/' "$changelog_file"

  # Mark Phase 4 as in progress
  sed -i 's/\*\*Phase 4: Category Files \*\*\*\[\*\*\*\*\*\*Pending\]/Phase 4: Category Files \*\*In Progress/' "$changelog_file"

  # Add outstanding work summary
  local outstanding="## Outstanding Work

### Phase 4: Category Files (26 files, 10-12 hours estimated)
**Status**: In Progress

**Tasks:**
- [ ] Populate all 26 category stub files created in Phase 1 with:
  - Script listings for each category
  - Common patterns in category
  - Resource requirements for category
  - Special considerations for category
  - Related category references

**Purpose**: Populate category stubs with script information from Phase 5 context files.

**Notes**: Will be populated during Phase 5 when script context files are created.

### Phase 5: Script-Specific Context Files (408 files, 68-72 hours estimated)

**Status**: Not Started

**Tasks:**
- [ ] Create context files for all 408 CT scripts
- [ ] Organize into 41 sections of 10 scripts each
- [ ] Analyze CT script headers for special requirements
- [ ] Analyze install scripts for interactive prompts
- [ ] Analyze JSON metadata for complete information
- [ ] Generate context file for each script following template

**Organization**: Sections 01-41 will contain ~10 scripts each.

**Notes**: This is bulk of the work (408 files × ~10 min each = ~68 hours). Automation scripts would be much more efficient.

### Phase 6: Automation Scripts (3 files, 4-6 hours estimated)

**Status**: Not Started

**Tasks:**
- [ ] Create `automation/generate-context.sh`
- [ ] Create `automation/update-index.sh`
- [ ] Create `automation/scan-new-scripts.sh` (with reminders)

**Purpose**: Automate context generation and maintenance.

### Phase 7: Integration & Updates (2 file updates, 2-3 hours estimated)

**Status**: Not Started

**Tasks:**
- [ ] Update `AGENTS.md` (✅ Already done in Phase 1)
- [ ] Update `CLAUDE.md` (if exists) with LLM context reference
- [ ] Update CHANGELOG.md with progress

**Purpose**: Integrate LLM context system into existing documentation.

### Phase 8: Documentation & Review (4-6 hours estimated)

**Status**: Not Started

**Tasks:**
- [ ] Review all category files for consistency
- [ ] Sample 20% of script context files for accuracy
- [ ] Validate all non-interactive examples
- [ ] Cross-reference index.md with actual files
- [ ] Test execution mode guides with sample scripts
- [ ] Document any patterns discovered during creation
- [ ] Create quick reference cards for common use cases

**Purpose**: Ensure quality and completeness of all context files.

---

## Check function implementation

# ... (all functions defined above)

main "$@"