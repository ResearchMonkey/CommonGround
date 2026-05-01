# Architecture Decision Records

Locked sessions in Confluence (`CG` space) are immutable. New information that contradicts a locked decision opens a new ADR here — it does not reopen the session.

Numbering is global and zero-padded: `0001-short-slug.md`, `0002-...`. Reference the superseded session by ID (e.g. "supersedes SA-002") in the ADR header.

## Template

```
# ADR-NNNN — Title

Status: Proposed | Accepted | Superseded
Date: YYYY-MM-DD
Supersedes: <session ID or prior ADR>

## Context
## Decision
## Consequences
```
