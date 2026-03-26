# Installation Guide

## Using Skills in Your Project

### Option 1: Copy individual skills

Copy the skill files you need into your project's `.claude/commands/` directory:

```bash
# Create the commands directory
mkdir -p .claude/commands

# Copy specific skills
cp /path/to/CCB-skills/commands/review.md .claude/commands/
cp /path/to/CCB-skills/commands/plan.md .claude/commands/
```

### Option 2: User-level installation (available in all projects)

Copy skills to your user-level commands directory:

```bash
# macOS/Linux
mkdir -p ~/.claude/commands
cp /path/to/CCB-skills/commands/*.md ~/.claude/commands/

# Windows
mkdir %USERPROFILE%\.claude\commands
copy D:\CCB-skills\commands\*.md %USERPROFILE%\.claude\commands\
```

### Option 3: Symlink (always up to date)

```bash
# macOS/Linux
ln -s /path/to/CCB-skills/commands ~/.claude/commands

# Windows (PowerShell as admin)
New-Item -ItemType Junction -Path "$env:USERPROFILE\.claude\commands" -Target "D:\CCB-skills\commands"
```

## Usage

Once installed, use skills as slash commands in Claude Code:

```
/ccb-review                    # Review all uncommitted changes
/ccb-review src/auth.js        # Review specific file
/ccb-plan Add user roles       # Plan a feature
/ccb-security-audit            # Audit entire project
/ccb-debug Login returns 401   # Debug a specific issue
/ccb-test src/utils.js         # Generate tests
/ccb-cleanup                   # Find and fix code smells
/ccb-optimize api/search       # Optimize specific area
/ccb-explore                   # Map unfamiliar codebase
/ccb-deploy-check              # Pre-deployment checklist
/ccb-doc src/lib/              # Generate documentation
/ccb-migrate React 18 to 19   # Migration planning
/ccb-pr                        # Create a pull request
```

## Customization

Feel free to modify any skill to match your preferences. Each `.md` file is a self-contained prompt template. `$ARGUMENTS` is replaced with whatever you type after the command name.
