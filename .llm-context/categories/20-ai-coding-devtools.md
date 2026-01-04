# 20 Ai Coding Devtools

## Category Information

**Category ID**: 20
**Number of Scripts**: 20

## Description

This category includes scripts for Debian, Ubuntu, Alpine and related services.

## Scripts in This Category (20 total)

| Name | Slug | Port | CPU | RAM | Disk | OS | Privileged |
|------|------|------|-----|-----|------|-----|-----------|
| [Alpine-IT-Tools](https://sharevb-it-tools.vercel.app/) | `alpine-it-tools` | 80 | 1 | 256 MB | 1 GB | Alpine 3.22 |  |
| [ByteStash](https://github.com/jordan-dalby/ByteStash) | `bytestash` | 3000 | 1 | 1024 MB | 4 GB | Debian 12 |  |
| [ComfyUI](https://www.comfy.org/) | `comfyui` | 8188 | 4 | 8192 MB | 25 GB | Debian 13 |  |
| [Dotnet ASP Web API](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-9.0&tabs=linux-ubuntu) | `dotnetaspwebapi` | 80 | 1 | 1024 MB | 8 GB | Ubuntu 24.04 | ✓ |
| [FlowiseAI](https://flowiseai.com/) | `flowiseai` | 3000 | 4 | 4096 MB | 10 GB | Debian 12 |  |
| [Forgejo](https://forgejo.org/) | `forgejo` | 3000 | 2 | 2048 MB | 10 GB | Debian 13 |  |
| [Gitea](https://gitea.com) | `gitea` | 3000 | 1 | 1024 MB | 8 GB | Debian 12 |  |
| [Jenkins](https://www.jenkins.io/) | `jenkins` | 8080 | 2 | 1024 MB | 4 GB | Debian 13 |  |
| [Jupyter Notebook](https://jupyter.org/) | `jupyternotebook` | 8888 | 2 | 2048 MB | 4 GB | Ubuntu 24.04 |  |
| [LiteLLM](https://www.litellm.ai/) | `litellm` | 4000 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [Livebook](https://livebook.dev) | `livebook` | 8080 | 1 | 1024 MB | 4 GB | Ubuntu 24.04 |  |
| [Ollama](https://ollama.com/) | `ollama` | 11434 | 4 | 4096 MB | 35 GB | Ubuntu 24.04 |  |
| [OneDev](https://onedev.io/) | `onedev` | 6610 | 2 | 2048 MB | 4 GB | Debian 13 |  |
| [Open WebUI](https://openwebui.com/) | `openwebui` | 8080 | 4 | 8192 MB | 25 GB | Debian 13 |  |
| [Opengist](https://opengist.io/) | `opengist` | 6157 | 1 | 1024 MB | 8 GB | Debian 13 |  |
| [Paperless-GPT](https://github.com/icereed/paperless-gpt) | `paperless-gpt` | 8080 | 3 | 2048 MB | 7 GB | Debian 13 |  |
| [PaperlessAI](https://github.com/clusterzx/paperless-ai) | `paperless-ai` | 3000 | 4 | 4096 MB | 20 GB | Debian 13 |  |
| [TypeSense](https://typesense.org/) | `typesense` | N/A | 1 | 1024 MB | 4 GB | Debian 13 |  |
| [Verdaccio](https://verdaccio.org/) | `verdaccio` | 4873 | 2 | 2048 MB | 8 GB | Debian 13 |  |
| [sonarqube](https://www.sonarsource.com/products/sonarqube/) | `sonarqube` | 9000 | 4 | 6144 MB | 25 GB | Debian 13 |  |


## Typical Resource Requirements

Based on scripts in this category:

| Resource | Minimum | Maximum | Typical |
|----------|----------|----------|---------|
| CPU Cores | 1 | 4 | 2 |
| RAM | 256 MB | 8192 MB | 4224 MB |
| Disk | 1 GB | 35 GB | 18 GB |

**Supported Operating Systems:**
- Debian
- Ubuntu
- Alpine
- Debian
- Ubuntu

## Common Patterns

### Installation Patterns
- Most scripts offer both **Alpine** and **Debian** installation methods
- Alpine versions typically use fewer resources (RAM, CPU, disk)

### Common Ports
- **Port 80**: Default interface port for many scripts
- **Port 3000**: Default interface port for many scripts
- **Port 4000**: Default interface port for many scripts
- **Port 4873**: Default interface port for many scripts
- **Port 6157**: Default interface port for many scripts

### Special Requirements
- Some scripts require **privileged containers** (see table above)
- Privileged scripts may need USB, FUSE, or other host access


## Special Considerations

### Security
- Review script descriptions for specific security requirements
- Check if scripts expose ports to your network
- Consider firewall rules for services accessible from outside

### Performance
- Adjust CPU and RAM based on expected load
- Databases and media servers may need more resources
- Alpine variants are lighter but may have fewer features

### Storage
- Some scripts grow disk usage over time (databases, media)
- Consider using fast storage for I/O intensive applications
- Backup important data regularly

### Networking
- Most scripts use DHCP by default
- Consider static IPs for critical services
- VLANs can isolate services for security

## Related Categories

*This section will be populated during Phase 5*

---

## Status

- [x] Category stub created
- [x] Scripts listed
- [x] Patterns documented
- [x] Resources documented
- [x] Special considerations documented

**Last Updated**: 2025-01-04
