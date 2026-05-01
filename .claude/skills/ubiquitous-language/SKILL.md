---
name: ubiquitous-language
description: Extract a DDD-style ubiquitous language glossary from the current conversation, flagging ambiguities and proposing canonical terms. Saves to UBIQUITOUS_LANGUAGE.md. Use when user wants to define domain terms, build a glossary, harden terminology, create a ubiquitous language, or mentions "domain model" or "DDD".
---

# Ubiquitous Language

Extract and formalize domain terminology from the current conversation into a consistent glossary, saved to a local file. CommonGround's authoritative terminology lives in Confluence space CG — when in doubt, fetch the latest and reconcile with that.

## Process

1. **Scan the conversation** for domain-relevant nouns, verbs, and concepts
2. **Identify problems**:
   - Same word used for different concepts (ambiguity)
   - Different words used for the same concept (synonyms)
   - Vague or overloaded terms
3. **Propose a canonical glossary** with opinionated term choices
4. **Write to `UBIQUITOUS_LANGUAGE.md`** in the working directory using the format below
5. **Output a summary** inline in the conversation

## Output Format

Write a `UBIQUITOUS_LANGUAGE.md` file with this structure:

```md
# Ubiquitous Language

## Hub & plugins

| Term       | Definition                                              | Aliases to avoid    |
| ---------- | ------------------------------------------------------- | ------------------- |
| **Hub**    | The host shell that loads and routes to Plugins         | App, shell, core    |
| **Plugin** | A self-contained feature unit registered with the Hub  | Module, extension   |

## Relationships

- A **Hub** loads zero or more **Plugins** at runtime
- Each **Plugin** exposes a single **Plugin Manifest** to the Hub

## Example dialogue

> **Dev:** "When the **Hub** boots, do we resolve every **Plugin Manifest** eagerly?"
> **Domain expert:** "No — the **Hub** lazy-loads a **Plugin** the first time its route is requested."

## Flagged ambiguities

- "module" was used to mean both **Plugin** and a Dart library — these are distinct.
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others as aliases to avoid.
- **Flag conflicts explicitly.** If a term is used ambiguously in the conversation, call it out in the "Flagged ambiguities" section with a clear recommendation.
- **Only include terms relevant for domain experts.** Skip the names of classes/files unless they have meaning in the domain language.
- **Keep definitions tight.** One sentence max. Define what it IS, not what it does.
- **Show relationships.** Use bold term names and express cardinality where obvious.
- **Skip generic programming concepts** (Widget, Future, StreamController) unless they have domain-specific meaning.
- **Group terms into multiple tables** when natural clusters emerge. Each group gets its own heading and table.
- **Write an example dialogue** — a short conversation (3-5 exchanges) between a dev and a domain expert that demonstrates how the terms interact.

## Re-running

When invoked again in the same conversation:

1. Read the existing `UBIQUITOUS_LANGUAGE.md`
2. Incorporate any new terms from subsequent discussion
3. Update definitions if understanding has evolved
4. Re-flag any new ambiguities
5. Rewrite the example dialogue to incorporate new terms
