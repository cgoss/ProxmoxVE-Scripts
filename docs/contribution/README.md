# 🤝 Contributing to ProxmoxVE

Complete guide to contributing to the ProxmoxVE project - from your first fork to submitting your pull request.

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Setting Up Your Fork](#setting-up-your-fork)
- [Coding Standards](#coding-standards)
- [Code Audit](#code-audit)
- [Guides & Resources](#guides--resources)
- [FAQ](#faq)

---

## 🚀 Quick Start

### 60 Seconds to Contributing

```bash
# 1. Fork on GitHub
# Visit: https://github.com/community-scripts/ProxmoxVE → Fork (top right)

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/ProxmoxVE.git
cd ProxmoxVE

# 3. Auto-configure your fork
bash docs/contribution/setup-fork.sh

# 4. Create a feature branch
git checkout -b feature/my-awesome-app

# 5. Read the guides
cat docs/README.md              # Documentation overview
cat docs/ct/DETAILED_GUIDE.md   # For container scripts
cat docs/install/DETAILED_GUIDE.md  # For install scripts

# 6. Create your contribution
cp ct/example.sh ct/myapp.sh
cp install/example-install.sh install/myapp-install.sh
# ... edit files ...

# 7. Test and commit
bash ct/myapp.sh
git add ct/myapp.sh install/myapp-install.sh
git commit -m "feat: add MyApp"
git push origin feature/my-awesome-app

# 8. Create Pull Request on GitHub
```

---

## 🍴 Setting Up Your Fork

### Automatic Setup (Recommended)

When you clone your fork, run the setup script to automatically configure everything:

```bash
bash docs/contribution/setup-fork.sh
```

This will:

- Auto-detect your GitHub username
- Update all documentation links to point to your fork
- Create `.git-setup-info` with recommended git workflows

**See**: [FORK_SETUP.md](FORK_SETUP.md) for detailed instructions

### Manual Setup

If the script doesn't work, manually configure:

```bash
# Set git user
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Add upstream remote for syncing
git remote add upstream https://github.com/community-scripts/ProxmoxVE.git

# Verify remotes
git remote -v
```

---

## 📖 Coding Standards

All scripts and configurations must follow our coding standards to ensure consistency and quality.

### Available Guides

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Essential coding standards and best practices
- **[CODE_AUDIT.md](CODE_AUDIT.md)** - Code review checklist and audit procedures
- **[GUIDE.md](GUIDE.md)** - Comprehensive contribution guide
- **[HELPER_FUNCTIONS.md](HELPER_FUNCTIONS.md)** - Reference for all tools.func helper functions
- **Container Scripts** - `/ct/` templates and guidelines
- **Install Scripts** - `/install/` templates and guidelines
- **JSON Configurations** - `/json/` structure and format

### Quick Checklist

- ✅ Use `/ct/example.sh` as template for container scripts
- ✅ Use `/install/example-install.sh` as template for install scripts
- ✅ Follow naming conventions: `appname.sh` and `appname-install.sh`
- ✅ Include proper shebang: `#!/usr/bin/env bash`
- ✅ Add copyright header with author
- ✅ Handle errors properly with `msg_error`, `msg_ok`, etc.
- ✅ Test before submitting PR
- ✅ Update documentation if needed

---

## 🔍 Code Audit

Before submitting a pull request, ensure your code passes our audit:

**See**: [CODE_AUDIT.md](CODE_AUDIT.md) for complete audit checklist

Key points:

- Code consistency with existing scripts
- Proper error handling
- Correct variable naming
- Adequate comments and documentation
- Security best practices

---

## 📚 Guides & Resources

### Documentation

- **[docs/README.md](../README.md)** - Main documentation hub
- **[docs/ct/README.md](../ct/README.md)** - Container scripts overview
- **[docs/install/README.md](../install/README.md)** - Installation scripts overview
- **[docs/ct/DETAILED_GUIDE.md](../ct/DETAILED_GUIDE.md)** - Complete ct/ script reference
- **[docs/install/DETAILED_GUIDE.md](../install/DETAILED_GUIDE.md)** - Complete install/ script reference
- **[docs/TECHNICAL_REFERENCE.md](../TECHNICAL_REFERENCE.md)** - Architecture deep-dive
- **[docs/EXIT_CODES.md](../EXIT_CODES.md)** - Exit codes reference
- **[docs/DEV_MODE.md](../DEV_MODE.md)** - Debugging guide

### AI/LLM Context System

**For AI Agents and LLMs** - Complete context system for understanding and automating ProxmoxVE scripts:

- **[.llm-context/README.md](../.llm-context/README.md)** - LLM Context System overview
- **[.llm-context/index.md](../.llm-context/index.md)** - Master navigation index (6 search methods)
- **[.llm-context/categories/](../.llm-context/categories/)** - 26 category-based guides
- **[.llm-context/scripts/](../.llm-context/scripts/)** - 408 individual script contexts
- **[.llm-context/execution/](../.llm-context/execution/)** - Non-interactive execution guides
- **[.llm-context/script-creation/](../.llm-context/script-creation/)** - Script development guides
- **[AGENTS.md](../AGENTS.md)** - Agent guidelines and build commands

**Quick Start for AI Agents:**
```bash
# Find a script by category
cat .llm-context/categories/13-media-streaming.md

# Execute non-interactively
var_cpu=2 var_ram=2048 var_disk=4 bash ct/jellyfin.sh

# Create new script using guides
cat .llm-context/script-creation/overview.md
```

**Automation Scripts for Context Generation:**

For maintainers and contributors working with multiple scripts:

1. **Generate All Context Files**:
   ```bash
   # Run automation script to generate/refresh all 408 context files
   bash .llm-context/automation/generate-context.sh
   ```

2. **Update Index and Categories**:
   ```bash
   # Update master index and category files with new scripts
   bash .llm-context/automation/update-index.sh
   ```

3. **Scan for Missing Contexts**:
   ```bash
   # Check for scripts without context files
   bash .llm-context/automation/scan-new-scripts.sh
   ```

**Context Generation Workflow:**

When adding or updating a script:
1. Create/update CT script: `ct/myapp.sh`
2. Create/update install script: `install/myapp-install.sh`
3. Create/update JSON metadata: `frontend/public/json/myapp.json`
4. Run: `bash .llm-context/automation/generate-context.sh`
5. Verify: Check `.llm-context/scripts/section-*/myapp.md`
6. Update index: `bash .llm-context/automation/update-index.sh` (if needed)

**For full automation documentation, see:**
- **[automation/README.md](../.llm-context/automation/README.md)** - Complete automation script guide
- **[AGENTS.md](../AGENTS.md)** - Agent guidelines with LLM Context System section

### Community Guides

See [USER_SUBMITTED_GUIDES.md](USER_SUBMITTED_GUIDES.md) for excellent community-written guides:

- Home Assistant installation and configuration
- Frigate setup on Proxmox
- Docker and Portainer installation
- Database setup and optimization
- And many more!

### Templates

Use these templates when creating new scripts:

```bash
# Container script template
cp docs/contribution/templates_ct/AppName.sh ct/my-app.sh

# Installation script template
cp docs/contribution/templates_install/AppName-install.sh install/my-app-install.sh

# JSON configuration template
cp docs/contribution/templates_json/AppName.json frontend/public/json/my-app.json
```

**Template Features:**

- Updated to match current codebase patterns
- Includes all available helper functions from `tools.func`
- Examples for Node.js, Python, PHP, Go applications
- Database setup examples (MariaDB, PostgreSQL)
- Proper service creation and cleanup

---

## 🔄 Git Workflow

### Keep Your Fork Updated

```bash
# Fetch latest from upstream
git fetch upstream

# Rebase your work on latest main
git rebase upstream/main

# Push to your fork
git push -f origin main
```

### Create Feature Branch

```bash
# Create and switch to new branch
git checkout -b feature/my-feature

# Make changes...
git add .
git commit -m "feat: description of changes"

# Push to your fork
git push origin feature/my-feature

# Create Pull Request on GitHub
```

### Before Submitting PR

1. **Sync with upstream**

   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Test your changes**

   ```bash
   bash ct/my-app.sh
   # Follow prompts and test the container
   ```

3. **Check code standards**

   - [ ] Follows template structure
   - [ ] Proper error handling
   - [ ] Documentation updated (if needed)
   - [ ] No hardcoded values
   - [ ] Version tracking implemented

4. **Push final changes**
   ```bash
   git push origin feature/my-feature
   ```

---

## 📋 Pull Request Checklist

Before opening a PR:

- [ ] Code follows coding standards (see CONTRIBUTING.md)
- [ ] All templates used correctly
- [ ] Tested on Proxmox VE
- [ ] Error handling implemented
- [ ] Documentation updated (if applicable)
- [ ] No merge conflicts
- [ ] Synced with upstream/main
- [ ] Clear PR title and description
- [ ] **LLM Context files generated** (for new scripts):
  - JSON metadata created: `frontend/public/json/{script}.json`
  - Run: `bash .llm-context/automation/generate-context.sh`
  - Verify: `.llm-context/scripts/section-*/{script}.md` exists
- [ ] **Index updated** (if multiple scripts):
  - Run: `bash .llm-context/automation/update-index.sh` (optional)
- [ ] **Category populated** (if applicable):
  - Script added to appropriate category file
  - Documentation: `.llm-context/categories/` guides

---

## ❓ FAQ

### How do I test my changes?

```bash
# For container scripts
bash ct/my-app.sh

# For install scripts (runs inside container)
# The ct script will call it automatically

# For advanced debugging
VERBOSE=yes bash ct/my-app.sh
```

### What if my PR has conflicts?

```bash
# Sync with upstream
git fetch upstream
git rebase upstream/main

# Resolve conflicts in your editor
git add .
git rebase --continue
git push -f origin your-branch
```

### How do I keep my fork updated?

See "Keep Your Fork Updated" section above, or run:

```bash
bash docs/contribution/setup-fork.sh
```

### Where do I ask questions?

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For general questions
- **Discord**: Community-scripts server

---

## 🎓 Learning Resources

### For First-Time Contributors

1. Read: [docs/README.md](../README.md) - Documentation overview
2. Read: [docs/contribution/FORK_SETUP.md](FORK_SETUP.md) - Fork setup guide
3. Choose your path:
   - Containers → [docs/ct/DETAILED_GUIDE.md](../ct/DETAILED_GUIDE.md)
   - Installation → [docs/install/DETAILED_GUIDE.md](../install/DETAILED_GUIDE.md)
4. Study existing scripts in same category
5. Create your contribution

### For Experienced Developers

1. Review [CONTRIBUTING.md](CONTRIBUTING.md) - Coding standards
2. Review [CODE_AUDIT.md](CODE_AUDIT.md) - Audit checklist
3. Check templates in `/ct/` and `/install/`
4. Submit PR with confidence

### For Reviewers/Maintainers

1. Use [CODE_AUDIT.md](CODE_AUDIT.md) as review guide
2. Reference [docs/TECHNICAL_REFERENCE.md](../TECHNICAL_REFERENCE.md) for architecture
3. Check [docs/EXIT_CODES.md](../EXIT_CODES.md) for error handling

---

## 🚀 Ready to Contribute?

1. **Fork** the repository
2. **Clone** your fork and **setup** with `bash docs/contribution/setup-fork.sh`
3. **Choose** your contribution type (container, installation, tools, etc.)
4. **Read** the appropriate detailed guide
5. **Create** your feature branch
6. **Develop** and **test** your changes
7. **Commit** with clear messages
8. **Push** to your fork
9. **Create** Pull Request

---

## 📞 Contact & Support

- **GitHub**: https://github.com/community-scripts/ProxmoxVE
- **Issues**: https://github.com/community-scripts/ProxmoxVE/issues
- **Discussions**: https://github.com/community-scripts/ProxmoxVE/discussions
- **Discord**: [Join Server](https://discord.gg/UHrpNWGwkH)

---

**Thank you for contributing to ProxmoxVE!** 🙏

Your efforts help make Proxmox VE automation accessible to everyone. Happy coding! 🚀
