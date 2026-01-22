# Claude Code Configuration for Dotfiles

This directory contains Claude Code configuration and custom agents for managing your dotfiles.

## Available Agents

### dotfiles-manager

A specialized agent for managing and maintaining your dotfiles configuration.

**Automatically activated when:**
- Editing .zshrc, nvim configs, tmux.conf, or terminal configs
- Working with the theme system
- Troubleshooting configuration issues

**Capabilities:**
- Understands your entire dotfiles structure
- Knows about the theme switching system (light/dark mode sync)
- Aware of all aliases and custom functions
- Can update configs while preserving existing patterns
- Suggests appropriate reload commands after changes

**Manual activation:**
You can explicitly invoke this agent by mentioning dotfiles-related tasks, or Claude will automatically delegate to it when appropriate.

## Directory Structure

```
.claude/
├── README.md                    # This file
├── settings.local.json          # Permission rules
└── agents/
    └── dotfiles-manager.md      # Dotfiles management agent
```

## How It Works

The `dotfiles-manager` agent:
1. Has comprehensive knowledge of your dotfiles structure
2. Understands the sophisticated theme system that syncs across Ghostty, Neovim, and tmux
3. Knows all your aliases, functions, and custom commands
4. Will read configs before making changes
5. Updates all related files when making theme changes
6. Provides reload commands after edits

## Usage Examples

Just ask Claude to help with dotfiles tasks naturally:

```
"Add a new alias for running tests"
"Update the dark theme colors in tmux"
"Add a new Neovim plugin for markdown"
"Fix the theme sync issue"
"Add a new git alias"
```

Claude will automatically delegate to the dotfiles-manager agent when appropriate.

## Permissions

The `settings.local.json` file contains pre-approved permissions for common operations:
- Reading system defaults
- Checking theme mode
- Running git commands
- File operations

## Theme System Overview

Your dotfiles include a unified theme system:
- **State file**: `~/.theme-mode` (contains "light" or "dark")
- **Commands**: `theme [light|dark]` or `tt` to toggle
- **Synced tools**: Ghostty, Neovim, tmux
- **Dark theme**: Catppuccin Macchiato
- **Light theme**: Solarized Light + Everforest

The agent knows to update all related configs when making theme changes.

## Adding More Agents

To add more agents, create new `.md` files in the `agents/` directory with this format:

```markdown
---
name: agent-name
description: What this agent does and when to use it
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
permissionMode: default
---

Agent instructions and context here...
```

## References

- [Claude Code Agents Documentation](https://github.com/anthropics/claude-code)
- Use `/agents` command to view and manage agents
- Use `/config` to view current configuration
