# Automation Scripts Workflow

This document describes the automation scripts for the LLM Context System and how to use them.

## Overview

The LLM Context System includes three automation scripts that help maintain context files as the repository grows:

1. **generate-context.sh** - Generate context files for all CT scripts
2. **update-index.sh** - Update master index and category files
3. **scan-new-scripts.sh** - Detect scripts without context files

## Scripts Location

All automation scripts are located in:
```
.llm-context/automation/
├── generate-context.sh
├── update-index.sh
└── scan-new-scripts.sh
```

## Script 1: generate-context.sh

### Purpose

Analyze all 408 CT scripts, parse their headers and JSON metadata, and generate individual context files for each script.

### Usage

```bash
cd /path/to/ProxmoxVE
bash .llm-context/automation/generate-context.sh
```

### Requirements

- **jq** - JSON processor (required for parsing metadata)
  - Install: `curl -L -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/latest/download/jq-linux64`
  - Windows: Download from https://github.com/stedolan/jq/releases
- **Bash 4.0+** - For modern features and patterns

### What It Does

1. **Scans all CT scripts** in `ct/` directory
2. **Parses script headers** to extract:
   - APP name
   - var_tags (extracts default value)
   - var_cpu, var_ram, var_disk (extracts defaults)
   - var_os, var_version (extracts defaults)
   - var_unprivileged
   - Special variables: var_gpu, var_fuse, var_tun, var_nesting
3. **Reads JSON metadata** from `frontend/public/json/{script_name}.json`:
   - name, description, categories
   - resources (CPU/RAM/disk/OS/version) from install_methods[0]
   - interface_port, website, documentation, config_path
4. **Generates context files** in `.llm-context/scripts/section-{01-41}/{script_name}.md`:
   - Basic information (name, description, categories)
   - Resources by install method
   - Access information (port, URLs, config path)
   - OS support information
   - Install script interactive prompts
   - Non-interactive execution examples

### Output Structure

```
.llm-context/scripts/
├── section-01/    # Scripts: 2fauth, actualbudget, adguard, etc.
├── section-02/    # Scripts: adventurelog, agentdvr, alpine-garage, etc.
├── section-03/    # Scripts: alpine-gatus, alpine-gitea, etc.
...
└── section-41/    # Scripts: zerotier-one, zigbee2mqtt, etc.
```

Each section contains ~10 script context files.

### Execution Time

- **First run**: ~10-15 minutes (408 scripts)
- **Subsequent runs**: ~10 minutes (if jq is installed)

### Error Handling

The script handles various error scenarios:

1. **Missing JSON file**: Uses default values from CT script header
2. **Missing jq**: Shows error and exits with instructions
3. **Missing install script**: Generates context without interactive prompts section
4. **Invalid metadata**: Falls back to defaults

### Example Output

```bash
$ bash .llm-context/automation/generate-context.sh

2026-01-04 11:20:00
no_prompts
no_prompts
Created context for: adguard
2026-01-04 11:20:01
no_prompts
Created context for: adventurelog
...
[SUCCESS] Created 408 context files, skipped 0, encountered 0 errors

Summary:
--------
Scripts analyzed: 408
Contexts created: 408
Scripts skipped: 0
Errors encountered: 0

Next:
- Populate category files with script listings
- Update CHANGELOG.md with Phase 4 completion
```

### Context File Format

Each generated context file follows this structure:

```markdown
# {script_name} Context

## Basic Information
- **Name**: {app_name}
- **Slug**: {script_name}
- **Categories**: [{categories}]

## Description
{description from JSON}

## Resources by Install Method

### Default Install
- **CPU**: {cpu} cores
- **RAM**: {ram} MB ({ram_gb} GB)
- **Disk**: {disk} GB
- **OS**: {os} {version}
- **Privileged**: {unprivileged}
- **Updateable**: Yes

## Access Information
- **Interface Port**: {port}
- **Web URL**: {website}
- **Documentation**: {documentation}
- **Configuration Path**: {config_path}

## OS Support
- **Debian 12/13**: Full package ecosystem, best compatibility
- **Ubuntu 22.04/24.04**: Latest software, 9-month support cycle

## Install Script: {script_name}-install.sh

### Interactive Prompts
{list of interactive prompts or "None"}

## Non-Interactive Execution Examples

### Default Settings (Use Script Defaults)
```bash
var_cpu={cpu} var_ram={ram} var_disk={disk} bash ct/{script_name}.sh
```

### With Resource Overrides
```bash
var_cpu=4 var_ram=8192 var_disk=20 bash ct/{script_name}.sh
```

### With Storage Selection
```bash
var_storage=local-lvm bash ct/{script_name}.sh
```

## Related Scripts
- **Alpine Variant**: Check for {script_name} if exists
```

### Known Issues

1. **Single categories show trailing comma**: `[5,]` instead of `[5]`
   - **Impact**: Cosmetic only
   - **Fix needed**: Refine jq output to trim trailing comma
   - **Status**: Deferred to Phase 8

2. **Bash arithmetic not expanding in heredocs**: `$((default_ram / 1024))`
   - **Impact**: GB calculation shows expression instead of value
   - **Fix needed**: Calculate before heredoc or use separate variable
   - **Status**: Deferred to Phase 8

## Script 2: update-index.sh

### Purpose

Update the master index file (`index.md`) and category files with new scripts and their metadata.

### Usage

```bash
cd /path/to/ProxmoxVE
bash .llm-context/automation/update-index.sh
```

### What It Does

1. **Scans all context files** in `.llm-context/scripts/section-*/`
2. **Updates index.md**:
   - Adds new scripts to alphabetical lists
   - Updates popular scripts section
   - Updates special requirements sections
3. **Updates category files**:
   - Adds scripts to appropriate category lists
   - Updates category statistics (script count, resource averages)
   - Links to script context files

### When to Run

Run this script when:
- Adding new scripts to the repository
- Modifying existing script categories
- Updating script metadata
- After running generate-context.sh to ensure index is up-to-date

## Script 3: scan-new-scripts.sh

### Purpose

Detect CT scripts that don't have corresponding context files and remind maintainers to generate context.

### Usage

```bash
cd /path/to/ProxmoxVE
bash .llm-context/automation/scan-new-scripts.sh
```

### What It Does

1. **Lists all CT scripts** in `ct/` directory
2. **Checks for context files** in `.llm-context/scripts/section-*/`
3. **Reports missing contexts**:
   ```
   ⚠️ Scripts without context files:
   - ct/newscript1.sh
   - ct/newscript2.sh
   
   Run: bash .llm-context/automation/generate-context.sh
   ```

### When to Run

Run this script when:
- Adding new scripts (to verify context was generated)
- As part of CI/CD pipeline (to catch missing contexts)
- Before releases (to ensure completeness)

### CI/CD Integration

Add to `.github/workflows/` workflow:

```yaml
name: Check LLM Context Files
on: [push, pull_request]
jobs:
  check-contexts:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install jq
        run: curl -L -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/latest/download/jq-linux64
      - name: Run scan
        run: bash .llm-context/automation/scan-new-scripts.sh
        continue-on-error: true
```

## Maintenance Workflow

### For New Scripts

When adding a new script:

1. **Create CT script**: `ct/myapp.sh`
2. **Create install script**: `install/myapp-install.sh`
3. **Create JSON metadata**: `frontend/public/json/myapp.json`
   - Include: name, description, categories, resources, ports, URLs
   - Use JSON Generator: https://community-scripts.github.io/ProxmoxVE/json-editor
4. **Generate context**: `bash .llm-context/automation/generate-context.sh`
5. **Verify output**: Check `.llm-context/scripts/section-*/myapp.md`
6. **Update index** (if needed): `bash .llm-context/automation/update-index.sh`

### For Script Updates

When updating an existing script:

1. **Update script files**: `ct/myapp.sh`, `install/myapp-install.sh`
2. **Update JSON metadata**: `frontend/public/json/myapp.json`
3. **Regenerate context**: `bash .llm-context/automation/generate-context.sh`
4. **Verify changes**: Review generated context file

### For Bulk Updates

When making changes that affect multiple scripts:

1. **Make changes**: Edit script files and JSON metadata
2. **Regenerate all contexts**: `bash .llm-context/automation/generate-context.sh`
3. **Update index**: `bash .llm-context/automation/update-index.sh`
4. **Test sample scripts**: Validate context accuracy

## Troubleshooting

### jq not found

**Error**: `jq: command not found`

**Solution**:
```bash
# Linux/Mac
curl -L -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/latest/download/jq-linux64
chmod +x /usr/local/bin/jq

# Windows
# Download from https://github.com/stedolan/jq/releases
# Add to PATH
```

### Permission denied

**Error**: `Permission denied when writing to .llm-context/scripts/`

**Solution**:
```bash
chmod +x .llm-context/automation/generate-context.sh
```

### No context files generated

**Possible causes**:
1. jq not installed
2. CT scripts don't have proper headers
3. JSON metadata missing or invalid

**Solution**: Run with verbose output:
```bash
VERBOSE=yes bash .llm-context/automation/generate-context.sh
```

## Best Practices

1. **Always generate contexts after adding scripts**: Ensures consistency
2. **Keep JSON metadata up-to-date**: Used for context generation
3. **Test generated contexts**: Verify accuracy before committing
4. **Use scan-new-scripts.sh**: Catch missing contexts early
5. **Document custom patterns**: If scripts have special requirements, ensure they're captured

## Performance

- **generate-context.sh**: ~10-15 minutes for 408 scripts
- **update-index.sh**: ~2-5 minutes
- **scan-new-scripts.sh**: <1 minute

## Related Documentation

- **[generate-context.sh source](../generate-context.sh)** - Automation script source
- **[Context System README](../README.md)** - System overview
- **[Script Creation Guide](../script-creation/overview.md)** - How scripts are structured
- **[Non-Interactive Execution](../execution/overview.md)** - How to use contexts
