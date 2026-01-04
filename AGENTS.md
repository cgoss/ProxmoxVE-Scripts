# Agent Guidelines for ProxmoxVE Helper-Scripts

This file provides essential build commands and code style guidelines for agents working in this repository.

## Build, Lint, and Test Commands

### Frontend (Next.js/TypeScript)
```bash
cd frontend

# Development server
bun dev            # or npm run dev

# Type checking
bun run typecheck   # or npm run typecheck

# Linting
bun run lint        # or npm run lint (auto-fixes issues)

# Production build
bun run build       # or npm run build
```

**Note**: No test framework is currently configured for the frontend.

### API (Go)
```bash
cd api

# Run development server
go run main.go

# Build executable
go build -o api-server main.go

# Download dependencies
go mod download
```

**Note**: No test framework is currently configured for the API.

### Shell Scripts (ct/ and install/)
```bash
# Test a container creation script
bash ct/docker.sh

# Test with verbose output
VERBOSE=yes bash ct/docker.sh

# The ct/ script will automatically run the corresponding install/ script
# No separate unit tests - scripts are validated via CI/CD
```

## Code Style Guidelines

### Frontend (TypeScript/React)
- **Imports**: Sorted by line length (descending) using `perfectionist/sort-imports`
- **Type definitions**: Use `type` instead of `interface` (`ts/consistent-type-definitions: ["error", "type"]`)
- **Quotes**: Double quotes only
- **Semicolons**: Required
- **Indentation**: 2 spaces
- **Filenames**: kebab-case (e.g., `query-provider.tsx`, `text-copy-block.tsx`)
- **Component patterns**: Functional components with TypeScript, use shadcn/ui components
- **Styling**: Tailwind CSS utility classes, mobile-first approach
- **State**: TanStack Query for server state, nuqs for URL params
- **Images**: Use `unoptimized: true` for static export compatibility

### Shell Scripts (ct/*.sh and install/*.sh)
**Container Scripts (ct/) must have this exact header:**
```bash
#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 community-scripts ORG
# Author: [YourUsername]
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: [SOURCE_URL]

APP="[AppName]"
var_tags="${var_tags:-category}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-4}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors
```

**Install Scripts (install/) must have this exact header:**
```bash
#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: [YourUsername]
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: [SOURCE_URL]

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os
```

**Additional Shell Guidelines:**
- Always use `source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"` in install scripts
- Use helper functions from `misc/tools.func` or `misc/alpine-tools.func`
- Use `$STD` prefix for silent command execution
- Use message functions: `msg_info`, `msg_ok`, `msg_error`
- Include `update_script()` function in ct/ scripts
- Use template files: `docs/contribution/templates_ct/AppName.sh` and `docs/contribution/templates_install/AppName-install.sh`

### API (Go)
- **Imports**: Standard library first, then third-party
- **Logging**: Use standard `log` package
- **Error handling**: Check errors explicitly, don't panic
- **Naming**: CamelCase for exported, camelCase for unexported

### General EditorConfig Rules
- **Charset**: UTF-8
- **Line endings**: LF (Unix style)
- **Indentation**: 2 spaces (no tabs)
- **Line length**: 120 characters max
- **Final newline**: Required
- **Trailing whitespace**: Not trimmed for bash files until cleaned up

## Error Handling

- **Shell**: Always call `catch_errors` after initialization, use proper exit codes
- **TypeScript**: Type-safe error handling with try/catch, show error messages with Toaster
- **Go**: Check all errors explicitly, return errors for caller to handle

## LLM Context System

**Purpose**: Enable AI/LLM agents to navigate, execute, and create ProxmoxVE Helper-Scripts

**Location**: `.llm-context/` directory

**Key Files**:
- `.llm-context/README.md` - Complete system overview and how to find context files
- `.llm-context/index.md` - Master index with 6 navigation methods (category, keyword, port, popular, special requirements, sections)
- `.llm-context/execution/` - Non-interactive execution guides
- `.llm-context/script-creation/` - New script development guides
- `.llm-context/categories/` - 26 category-specific guides
- `.llm-context/scripts/` - 408 individual script context files (organized in 41 sections)

**How to Use**:

1. **To find a script**: Read `.llm-context/README.md` for context finding methods
2. **To execute non-interactively**: Read `.llm-context/execution/overview.md` first
3. **To create new script**: Read `.llm-context/script-creation/` guides
4. **Track progress**: See `.llm-context/CHANGELOG.md`

**Important**: LLM agents should ALWAYS use non-interactive mode because they cannot interact with whiptail UI. See `.llm-context/execution/ui-mimicry.md` for how to ask users for settings.

---

## LLM Context System

**Purpose**: Enable AI/LLM agents to navigate, execute, and create ProxmoxVE Helper-Scripts

**Location**: `.llm-context/` directory

**Key Files**:
- `.llm-context/README.md` - Complete system overview and how to find context files
- `.llm-context/index.md` - Master index with 6 navigation methods
- `.llm-context/execution/` - Non-interactive execution guides
- `.llm-context/script-creation/` - New script development guides
- `.llm-context/categories/` - 26 category-specific guides
- `.llm-context/scripts/` - 408 individual script context files

**How to Use:**

1. **To find a script**: Read `.llm-context/README.md` for context finding methods
2. **To execute non-interactively**: Read `.llm-context/execution/overview.md` first
3. **To create new script**: Read `.llm-context/script-creation/overview.md` first

**Important**: LLM agents should ALWAYS use non-interactive mode because they cannot interact with whiptail UI. See `.llm-context/execution/ui-mimicry.md` for how to ask users for settings.

1. Run `bun run lint` in frontend directory and fix all issues
2. Run `bun run typecheck` in frontend directory
3. Test shell scripts with `bash ct/appname.sh`
4. Ensure all files have correct headers and follow templates
5. Never commit `misc/build.func` or `misc/install.func` changes (reset them before PR)

## Key File Locations

- Frontend config: `frontend/package.json`, `frontend/eslint.config.mjs`, `frontend/tsconfig.json`
- Shell function libraries: `misc/tools.func`, `misc/alpine-tools.func`, `misc/build.func`
- Templates: `docs/contribution/templates_ct/AppName.sh`, `docs/contribution/templates_install/AppName-install.sh`
- Shell scripts: `ct/*.sh` (container creation), `install/*.sh` (installation)
