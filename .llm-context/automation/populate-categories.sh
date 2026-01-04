#!/usr/bin/env bash

# Script to populate category files with script information

set -e

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
# Remove .llm-context from path since we want repo root
REPO_DIR="$(dirname "$REPO_DIR")"
JSON_DIR="$REPO_DIR/frontend/public/json"
CATEGORIES_DIR="$REPO_DIR/.llm-context/categories"

# Create a temporary file for collecting scripts by category
SCRIPTS_BY_CATEGORY=$(mktemp)

echo "Collecting scripts by category..."
echo "JSON_DIR: $JSON_DIR"
ls "$JSON_DIR"/*.json | head -5

# Process all JSON files
json_count=0
for json_file in "$JSON_DIR"/*.json; do
  if [[ ! -f "$json_file" ]]; then
    continue
  fi

  json_count=$((json_count + 1))

  # Extract script name and categories
  script_name=$(basename "$json_file" .json)
  categories=$(PATH="$HOME:$PATH" jq -r '.categories[] // empty' "$json_file" 2>/dev/null || echo "")

  # Get metadata
  app_name=$(jq -r '.name // empty' "$json_file" 2>/dev/null || echo "")
  description=$(jq -r '.description // empty' "$json_file" 2>/dev/null | head -c 100 || echo "")
  cpu=$(jq -r '.install_methods[0].resources.cpu // 2' "$json_file" 2>/dev/null || echo "2")
  ram=$(jq -r '.install_methods[0].resources.ram // 2048' "$json_file" 2>/dev/null || echo "2048")
  disk=$(jq -r '.install_methods[0].resources.hdd // 4' "$json_file" 2>/dev/null || echo "4")

  # Add each category association
  if [[ -n "$categories" ]]; then
    while IFS= read -r cat_num; do
      echo "  Adding association: $cat_num|$script_name"
      echo "$cat_num|$script_name|$app_name|$description|$cpu|$ram|$disk" >> "$SCRIPTS_BY_CATEGORY"
    done < <(PATH="$HOME:$PATH" jq -r '.categories[]' "$json_file" 2>/dev/null)
  else
    echo "  No categories for $script_name"
  fi
done

echo "Found $(wc -l < "$SCRIPTS_BY_CATEGORY") script-category associations"

# Now populate each category file
for cat_file in "$CATEGORIES_DIR"/*.md; do
  if [[ ! -f "$cat_file" ]]; then
    continue
  fi

  cat_name=$(basename "$cat_file" .md)
  cat_num=$(echo "$cat_name" | cut -d'-' -f1)

  echo "Processing category: $cat_name (ID: $cat_num)"

  # Get scripts for this category
  scripts_in_cat=$(grep "^$cat_num|" "$SCRIPTS_BY_CATEGORY" 2>/dev/null || true)

  if [[ -z "$scripts_in_cat" ]]; then
    echo "  No scripts found for this category"
    continue
  fi

  # Read the category file (preserving header and description)
  cat "$cat_file" > "${cat_file}.tmp"

  # Remove stub note and add actual content
  sed -i '/^\*Note: This section will be populated during Phase 5/d' "${cat_file}.tmp"
  sed -i '/^\*Note: Common installation patterns/d' "${cat_file}.tmp"
  sed -i '/^\*Note: Typical CPU, RAM, and disk requirements/d' "${cat_file}.tmp"
  sed -i '/^\*Note: Special considerations and requirements/d' "${cat_file}.tmp"
  sed -i '/^\*Related categories will be documented/d' "${cat_file}.tmp"

  # Add scripts list
  echo "## Scripts in This Category" >> "${cat_file}.tmp"
  echo "" >> "${cat_file}.tmp"
  echo "The following scripts are included in this category:" >> "${cat_file}.tmp"
  echo "" >> "${cat_file}.tmp"
  echo "| Script | Description | CPU | RAM | Disk |" >> "${cat_file}.tmp"
  echo "|--------|-------------|-----|-----|------|" >> "${cat_file}.tmp"

  script_count=0
  total_cpu=0
  total_ram=0
  total_disk=0

  while IFS='|' read -r f_cat_num f_script_name f_app_name f_description f_cpu f_ram f_disk; do
    # Convert RAM to GB
    ram_gb=$((f_ram / 1024))

    echo "| [$f_script_name](../../scripts/\*/${f_script_name}.md) | $f_description | $f_cpu | ${ram_gb}GB | ${f_disk}GB |" >> "${cat_file}.tmp"

    script_count=$((script_count + 1))
    total_cpu=$((total_cpu + f_cpu))
    total_ram=$((total_ram + f_ram))
    total_disk=$((total_disk + f_disk))
  done < <(echo "$scripts_in_cat")

  echo "" >> "${cat_file}.tmp"
  echo "**Total scripts in category**: $script_count" >> "${cat_file}.tmp"

  # Calculate averages
  if [[ $script_count -gt 0 ]]; then
    avg_cpu=$((total_cpu / script_count))
    avg_ram=$((total_ram / script_count))
    avg_disk=$((total_disk / script_count))
    avg_ram_gb=$((avg_ram / 1024))

    echo "" >> "${cat_file}.tmp"
    echo "## Typical Resource Requirements" >> "${cat_file}.tmp"
    echo "" >> "${cat_file}.tmp"
    echo "Based on scripts in this category:" >> "${cat_file}.tmp"
    echo "" >> "${cat_file}.tmp"
    echo "- **CPU**: ${avg_cpu} cores (average)" >> "${cat_file}.tmp"
    echo "- **RAM**: ${avg_ram} MB (${avg_ram_gb} GB) (average)" >> "${cat_file}.tmp"
    echo "- **Disk**: ${avg_disk} GB (average)" >> "${cat_file}.tmp"
  fi

  # Update status checklist
  sed -i 's/- \[ \] Scripts listed/- [x] Scripts listed/' "${cat_file}.tmp"
  sed -i 's/- \[ \] Resources documented/- [x] Resources documented/' "${cat_file}.tmp"

  # Replace original file
  mv "${cat_file}.tmp" "$cat_file"

  echo "  Updated with $script_count scripts"
done

# Clean up
rm -f "$SCRIPTS_BY_CATEGORY"

echo ""
echo "Category files populated successfully!"
