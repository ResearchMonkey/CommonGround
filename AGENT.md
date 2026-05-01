# AGENT.md — CommonGround AI Coding Agent Briefing

**Mandatory.** Load this file before writing any CommonGround code (CS-007).

CommonGround is a Flutter/Dart, offline-first, plugin-based situational awareness platform. The core is a pub/sub event bus; plugins are runtime-loaded Dart isolates. Core/plugin boundaries are enforced structurally, not by convention.

Source of truth: Confluence space `CG`. This document is derived from Sessions 3.7 (architecture), 3.8 (coding standards), and 3.9 (testing standards). If this file disagrees with those documents, the Confluence sessions win — open an issue to update this file.

---

## Architecture (SA-001 .. SA-006)

| ID | Rule |
| --- | --- |
| SA-001 | Clean Architecture. Layers: domain ← data, domain ← presentation. Never the reverse. BLoC at presentation. |
| SA-002 | Feature-first folders. `lib/core/<feature>/{data,domain,presentation}` and `lib/plugins/<plugin>/{data,domain,presentation}`. No cross-plugin imports. |
| SA-003 | Cubit only for purely-local UI state. Bus / cross-feature / plugin = full BLoC with typed events. |
| SA-004 | Constructor injection only. No `get_it`, no service locator, no global singletons. |
| SA-005 | `Either<Failure, Success>` (`fpdart`) at every fallible function. No bare `throw`. No silent `try/catch`. Failures are sealed classes in `core/shared/domain`. |
| SA-006 | All logging via injected `CgLogger`. Warning+ also publishes a `LogEvent` on the bus. `print` / `debugPrint` banned. |

## Coding Standards (CS-001 .. CS-007)

| ID | Rule |
| --- | --- |
| CS-001 | Lints: `very_good_analysis`. CI fails on any violation. `// ignore:` requires inline justification. `// ignore_for_file:` banned. |
| CS-002 | Naming suffixes are mandatory: `*Event`, `*Contract`, `*Bloc`, `*Cubit`, `*Failure`, `*Repository`, `*RepositoryImpl`, `*UseCase`, `*Dto`, `*Plugin`. Files `snake_case`, match the primary class. |
| CS-003 | Hard limits — file 300 lines, function 30 lines, class 200 lines, parameters 5. Resolve by extract/split, not blanket ignores. |
| CS-004 | Dartdoc required on `*Contract`, `*Event`, `*UseCase`, `*Failure`, and public plugin APIs. Optional elsewhere. |
| CS-005 | Import order: dart SDK → external → internal `package:commonground/...` → relative (same feature only). Barrel files banned. Cross-feature talks via the bus only. |
| CS-006 | Domain/data/repositories/use cases return `Either<Failure, Success>`. BLoC folds into typed states. UI never touches `Either`. `throw` banned outside tests. Plugin failures carry `pluginId`. |
| CS-007 | Load this file first. CI is the last line of defense — not the first. |

## Testing Standards (TS-001 .. TS-007)

| ID | Rule |
| --- | --- |
| TS-001 | Four tiers: unit / contract / integration / e2e. Contract = plugin boundary. |
| TS-002 | Coverage: domain 90%, presentation 80%, plugin contracts 100%. Enforced in CI. |
| TS-003 | Tests mirror source path under `test/<tier>/...`. Suffix `_test.dart`. |
| TS-004 | `mocktail` is the default. Hand-written fakes only at the contract tier. `mockito` banned. |
| TS-005 | `bloc_test` `blocTest()` is the default. Manual `expectLater` only for interleaved async. |
| TS-006 | Unit + Contract: every PR. Integration: merge to main. E2E: release branch. |
| TS-007 | No golden files. Assert state and structure only. |

---

## Boundaries — non-negotiable

1. **No cross-plugin imports.** Plugin A never imports from plugin B. Inter-plugin communication is bus-only.
2. **No barrel files.** Every import is explicit.
3. **No service locator.** Dependencies are visible in the constructor.
4. **No `throw` in production code.** Failures travel as `Either<Failure, T>` and `LogEvent`.
5. **No `print` / `debugPrint`.** Use injected `CgLogger`.
6. **No goldens.** Widget tests assert state and structure.

## Folder layout

```
lib/
  core/
    event_bus/   {data,domain,presentation}
    transport/   {data,domain,presentation}
    map/         {data,domain,presentation}
    geochat/     {data,domain,presentation}
    markers/     {data,domain,presentation}
    navigation/  {data,domain,presentation}
    shared/      {domain,data}
  plugins/
    casevac/        {data,domain,presentation}
    track_history/  {data,domain,presentation}
    contacts/       {data,domain,presentation}
    rto_toolkit/    {data,domain,presentation}
    tak_relay/      {data,domain,presentation}
    data_package/   {data,domain,presentation}
    turn_by_turn/   {data,domain,presentation}
    geofencing/     {data,domain,presentation}
test/
  unit/        # mirrors lib/
  contract/    # plugin boundary tests (100% coverage)
  integration/ # full feature flows on device/emulator
  e2e/         # full user journeys
```
