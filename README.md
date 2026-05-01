# CommonGround

Modular, offline-first team coordination and situational awareness platform for civilian field operations. Hub-and-plugins architecture: a pub/sub event bus at the core, with a map and every other feature as subscribers. Built in Flutter/Dart; Android-primary, iOS-secondary.

**Project tracking:** Jira project [`CG`](https://echo8lohrer.atlassian.net/jira/software/projects/CG/boards/71). **Design source of truth:** Confluence space [`CG`](https://echo8lohrer.atlassian.net/wiki/spaces/CG/overview).

## Start here

- [`AGENT.md`](./AGENT.md) — mandatory briefing for humans and AI coding agents.
- [`CONTRIBUTING.md`](./CONTRIBUTING.md) — quick rules and CI gates.
- `docs/sessions/` — local mirrors of Confluence session decisions (optional, kept in sync manually).
- `docs/adr/` — Architecture Decision Records for changes that supersede a locked session.

## Layout

```
lib/
  core/      event_bus, transport, map, geochat, markers, navigation, shared
  plugins/   casevac, track_history, contacts, rto_toolkit, tak_relay,
             data_package, turn_by_turn, geofencing
test/
  unit/  contract/  integration/  e2e/
```

Feature-first Clean Architecture (SA-002). Each feature owns its `data/domain/presentation` layers. Cross-feature communication is bus-only — no direct imports.

## Bootstrapping the Flutter platform layer

This repository ships with the architectural skeleton only. To add the Android/iOS platform folders, run:

```
flutter create --project-name commonground --platforms=android,ios .
```

Then delete the generated `lib/main.dart` example and `test/widget_test.dart` — the canonical entry point is `lib/main.dart` in this repo. Verify with:

```
flutter pub get
flutter analyze
flutter test test/unit/
```

## Standards

Architecture: Sessions 3.7 (`SA-001..006`). Coding: Session 3.8 (`CS-001..007`). Testing: Session 3.9 (`TS-001..007`). All locked and immutable — changes go through a new ADR in `docs/adr/`.
