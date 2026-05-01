---
name: test-runner
description: "Run, triage, and improve Flutter tests — executes test suites, triages failures/flaky tests, and drives coverage increase. Use when running tests, CI fails, or coverage needs improvement."
argument-hint: "[suite-name or 'coverage' or 'triage']"
allowed-tools: Read, Grep, Glob, Edit, Bash(flutter test:*), Bash(flutter analyze:*), Bash(dart analyze:*), Bash(dart format:*), Bash(genhtml:*), Bash(lcov:*)
---

# Test Runner, Triage & Coverage

This skill combines test execution, failure triage, and coverage improvement for the CommonGround Flutter project.

## Modes

- **Run** (default): Execute test suites and report results
- **Triage** (argument contains "triage"): Diagnose and fix failing/flaky tests
- **Coverage** (argument contains "coverage"): Drive coverage upward

---

## Mode: Run

### Step 1 — Execute

```bash
flutter test
dart analyze
```

If integration tests are present:

```bash
flutter test integration_test
```

### Step 2 — Report Results

For each suite, report: pass/fail count, duration, any failures with the first ~30 lines of error output.

If any tests fail, automatically enter **Triage** mode for those failures.

---

## Mode: Triage

### Step 1 — Reproduce the failure

Run the single failing test in isolation:

```bash
flutter test --plain-name "<test name>" path/to/test_file.dart
```

Capture the full error including the stack trace.

### Step 2 — Root Cause Analysis

**For widget test flakiness, check:**
- Missing `await tester.pumpAndSettle()` after async actions
- Animations not awaited (use `pumpAndSettle` or `pump(duration)`)
- `Timer`s/`Future`s pending at test end (causes "Pending timers" failures)
- Missing fake binding for plugin channels (use `TestDefaultBinaryMessengerBinding`)
- Locale/MediaQuery defaults differing from production

**For unit test failures, check:**
- Fixture/test data mutated across tests (lack of `setUp` re-init)
- Async race — `Stream`/`Future` ordering assumed but not awaited
- Real network/filesystem accidentally hit instead of a fake
- `Provider`/DI scope not reset between tests

### Step 3 — Fix or Quarantine

1. **Fix root cause** when possible — always preferred
2. **For genuinely flaky third-party-driven tests:** wrap in `retry` or mark `skip:` with a comment naming the underlying cause
3. **If not fixed:** create a Jira bug in project CG (board 71) with label `test-failure` via the Atlassian MCP, linking the failing file and the error excerpt

### Step 4 — Verify

```bash
flutter test path/to/test_file.dart
```

Re-run a few times if flakiness was the suspected cause.

---

## Mode: Coverage

### Targets (initial)

- **Lines:** ≥70% (raise as the project matures)
- **Domain & application layers:** ≥85% — these are the layers without Flutter dependencies
- **Presentation layer:** widget tests for every screen happy path + at least one error/empty state

### Measure

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Open `coverage/html/index.html` to browse uncovered files.

### Rules

1. **No regressions.** `flutter test` and `dart analyze` must pass after every change.
2. **Observable assertions only.** Every test asserts on a rendered widget, returned value, or emitted state — not on a `verify(mock.method())` call alone.
3. **Stop when:** (a) targets met, or (b) two consecutive cycles add <0.5% lines (plateau). On plateau, report which files need refactoring for testability rather than continuing to write tests against awkward shapes.

### Phased approach

**Phase A — Refactor for testability**
- Extract pure functions out of widgets into the domain layer
- Inject dependencies (repositories, clocks, random sources) instead of constructing them inside widgets
- Replace static singletons with factories registered at the Hub boundary

**Phase B — Domain & application coverage**
- Pure Dart unit tests for use cases, validators, mappers
- Fakes (not mocks) for repository ports

**Phase C — Widget coverage**
- One happy-path widget test per screen
- One error-state and one empty-state widget test per screen with non-trivial conditional rendering

### After Each Phase

1. `flutter test --coverage` — all must pass
2. Note line/branch coverage delta
3. If a Hub↔Plugin contract changed, re-check the locked design in Confluence space CG and flag any drift

---

## CLI Reference

| Command | Purpose |
|---------|---------|
| `flutter test` | Run all unit + widget tests |
| `flutter test integration_test` | Run integration tests |
| `flutter test --coverage` | Run with coverage (writes `coverage/lcov.info`) |
| `flutter test --plain-name "<name>"` | Run a single named test |
| `dart analyze` | Static analysis |
| `dart format --set-exit-if-changed .` | Format check |
| `genhtml coverage/lcov.info -o coverage/html` | Render HTML coverage report |
