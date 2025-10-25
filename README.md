# Ansible Onboarding Environment – Supuni

## System Info
- OS: Ubuntu 22.04 on WSL2
- Python: 3.10.x
- Ansible: 2.15.x
- Virtual Env: `.venv/`

## VS Code Extensions
- Ansible (Red Hat)
- YAML (Red Hat)
- Python
- EditorConfig

## SSH Configuration
- Key: `~/.ssh/id_ed25519`
- Config: `~/.ssh/config`
- Agent running: `ssh-add -l` shows your key

## Git & Hooks
- Configured user name/email
- Pre-commit hooks installed:
  - yamllint
  - ansible-lint

## Commands
```bash
source .venv/bin/activate
ansible --version
ansible-lint --version
yamllint .
pre-commit run --all-files

