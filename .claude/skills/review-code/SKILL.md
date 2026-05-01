---
name: review-code
description: "Code review with impact analysis for the CommonGround Flutter project — inline findings against Dart/Flutter conventions, hub-and-plugins boundary, and the locked design in Confluence space CG. Use for PR reviews, branch diffs, or critical reviews before merge."
argument-hint: "[base-branch or file-or-feature-description]"
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(gh pr diff:*), Bash(gh pr view:*), Bash(dart analyze:*), Bash(flutter analyze:*)
---

# Code Review & Impact Analysis

You are reviewing CommonGround code changes and providing **inline, line-level feedback** against Dart/Flutter conventions, the project's Clean Architecture boundaries, and the hub-and-plugins contract — plus assessing cross-project impact.

## Step 0 — Determine the diff

Use the argument as the base branch (default: `main`). Let `<base>` refer to the resolved base branch.

- **Branch diff:** `git diff <base>...HEAD`
- **No diff found:** check `git diff --cached`, then `git diff`

If there is no diff at all, inform the user and stop.

## Step 1 — Load the diff

Substitute `<base>` from Step 0:

1. `git diff <base>...HEAD -- '*.dart' '*.yaml' '*.yml' ':!**/*.g.dart' ':!**/*.freezed.dart' ':!**/.dart_tool/*'` — current diff
2. `git diff <base>...HEAD --name-only` — changed files
3. `git log <base>...HEAD --oneline` — recent commits on this branch

## Step 2 — Review against quality gates

Apply each applicable gate to the diff.

### Architecture & boundaries (VETO-level)

1. **Feature-first Clean Architecture** — `lib/features/<feature>/{domain,application,infrastructure,presentation}` layering is preserved; no presentation imports from infrastructure, no domain imports from Flutter
2. **Hub ↔ Plugin contract** — changes to the Hub interface match the locked design in Confluence space CG (fetch via Atlassian MCP if uncertain); plugins do not reach into Hub internals or sibling plugins
3. **No cross-feature imports** — features only depend on shared/core packages, never on each other directly
4. **Dependency injection at the boundary** — services/repositories are wired at the Hub level, not constructed inside widgets

### Dart / Flutter correctness (VETO or HIGH)

5. **Null safety** — no unguarded `!` on values that can legitimately be null at runtime; nullable fields handled at every read site
6. **Async hygiene** — every `Future` is `await`-ed or explicitly fire-and-forgotten with a comment; `BuildContext` is not used across an `await` without a `mounted` check
7. **Resource disposal** — `StreamSubscription`, `AnimationController`, `TextEditingController`, `FocusNode`, etc. are disposed in `dispose()`
8. **Immutability** — model classes are `final`/`const`-friendly (or use `freezed`); no mutation of shared state without a clear owner
9. **Error feedback** — caught exceptions surface to the user via UI (snackbar/dialog/error state), not just `print`/`debugPrint`
10. **`const` constructors** used wherever the analyzer recommends, especially in widget trees

### Testing

11. **Behavior over implementation** — new tests assert on rendered widgets, returned values, or emitted state; not on `verify(mock.method())` alone
12. **Coverage proportional to risk** — domain/application changes ship with unit tests; new screens ship with at least one widget test
13. **No flaky patterns** — `pumpAndSettle()` after async UI actions; no real network/filesystem from tests

### Security & data

14. **Secrets** — no hardcoded keys, tokens, or endpoints in source; verify via grep on the diff
15. **Input validation** — all data crossing the Hub↔Plugin boundary or coming from external sources is validated before use
16. **Logging hygiene** — no PII or secrets in log output

## Step 3 — Impact Analysis

For each changed file:

1. **Direct dependents** — what other files import this symbol? (`grep -rn "import .*<file>"`)
2. **Plugin contract impact** — if a Hub-facing type changed, list every plugin that needs the same change
3. **Feature coupling** — if a shared/core file changed, which features inherit the change?
4. **Test coverage** — are the changed code paths covered by existing tests?
5. **Platform parity** — does this assume an iOS/Android/web/desktop capability that doesn't hold elsewhere?

### Unintended consequences

- **Breaking changes** to Plugin API (renames, signature changes, removed exports)
- **State leaks** between plugins via shared singletons
- **Race conditions** introduced (init order, async state dependencies)
- **Pattern inconsistency** (a fix applied in one place but the same pattern lives elsewhere)

## Step 4 — Verify and eliminate false positives

Before reporting, confirm each finding:

- Open the file and read surrounding context (not just the diff line)
- Confirm the flagged code actually violates the cited rule
- Check if the violation already existed before this diff (note as pre-existing)
- Run `dart analyze` and check whether the analyzer already flags it (drop redundant findings)
- Remove false positives

## Step 5 — Output

### Summary

One paragraph: what the changes do, overall quality assessment, merge readiness, and blast radius.

### Findings

```
**[SEVERITY]** `path/to/file.dart:LINE` — Rule
> The offending code line(s)
**Issue:** What's wrong
**Fix:** Specific recommended fix
```

**Severity levels:**
- **VETO** — Blocks merge. Architecture boundary, security, or correctness violation.
- **HIGH** — Broken functionality, missing required test coverage, resource leak.
- **MEDIUM** — Convention violation, missing negative-path test.
- **LOW** — Style nit, minor improvement.

### Risk Assessment

| Risk | Area | Description | Mitigation |
|------|------|-------------|------------|
| HIGH/MEDIUM/LOW | ... | ... | ... |

### Recommendations

Prioritized improvements, ordered by risk. Separate "must fix before merge" from "should address in follow-up."

### Verdict

- **APPROVE** — No VETO or HIGH findings. Safe to merge.
- **REQUEST CHANGES** — VETO or HIGH findings must be fixed before merge.

If no issues found, state: "Clean review — no findings. Approved."

## Important

- Only review **changed code** (the diff), not the entire codebase
- Always cite file path, line number, and the rule violated
- Do not suggest improvements beyond what the gates above require
- Pre-existing issues in unchanged code → note separately as "pre-existing"
