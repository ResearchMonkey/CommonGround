---
name: write-a-skill
description: "Scaffold a new skill following CommonGround conventions. Use when creating a new skill or when user says 'write a skill'."
argument-hint: "[skill-name or description of what the skill should do]"
allowed-tools: Read, Grep, Glob, Edit, Write
---

# Write a Skill

You are a **skill author**. Your job is to scaffold a new skill in `.claude/skills/<name>/SKILL.md` for the CommonGround project.

## When to Use

- Creating a new skill for the project
- User describes a repeatable workflow they want to codify
- User says "write a skill" or "make a skill"

## Step 0 — Gather Requirements

Ask the user (or infer from the argument):

1. **Name** — lowercase kebab-case identifier (e.g., `review-plugin-contract`)
2. **Purpose** — what does this skill do? One sentence.
3. **Trigger** — when should someone use it? ("Use when...")
4. **Arguments** — what input does it expect? (Jira key, file path, description, none)
5. **Tools needed** — read-only, or does it edit/write/run commands?

## Step 1 — Check for Overlap

Before creating, scan for existing skills that already cover this:

- Glob `.claude/skills/*/SKILL.md`
- Grep their `description:` fields for related keywords
- If overlap exists, tell the user and ask whether to extend the existing skill or proceed with a new one

## Step 2 — Write the Skill

Create `.claude/skills/<name>/SKILL.md`:

```
---
name: <name>
description: "<purpose>. Use when <trigger>."
argument-hint: "<expected arguments>"
allowed-tools: <comma-separated list>
---

# <Skill Title>

<1-2 sentence summary>

## When to Use
- ...

## Step 0 — ...
## Step 1 — ...
## Output
## References
```

### Structure guidelines

- **When to Use** — 2-4 bullet points describing trigger conditions
- **Steps** — numbered steps with clear, actionable instructions (not vague: "Read `path/to/file` and check for Y", not "Analyze X")
- **Output** — describe the expected output format (table, summary, file written, PR opened)
- Reference real CommonGround paths (e.g., `lib/features/...`, Confluence space CG, Jira project CG board 71) — not generic advice
- Keep it under 150 lines — if longer, split it

### allowed-tools guidance

- **Read-only skills** (reviews, audits, analysis): `Read, Grep, Glob`
- **Git-aware skills**: add `Bash(git log:*), Bash(git diff:*)`
- **Implementation skills**: add `Edit, Write, Bash(flutter test), Bash(dart analyze)`
- **Jira/Confluence-aware skills**: MCP tools are granted globally; no need to list them

## Step 3 — Confirm

Show the user the new skill path and a one-line summary of what was created.

## Output

- One new file at `.claude/skills/<name>/SKILL.md`
- Summary of what was created
