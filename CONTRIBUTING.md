# Contributing to CommonGround

Before writing or generating any code in this repository, read [`AGENT.md`](./AGENT.md). It is the binding briefing for both human contributors and AI coding agents (CS-007). The full architecture and coding standards live in the `CG` Confluence space — Sessions 3.7, 3.8, and 3.9.

## Quick rules

- Layer boundaries are enforced. Domain depends on nothing. Presentation never imports data.
- Cross-feature communication goes through the event bus. No direct imports between features or plugins.
- All fallible operations return `Either<Failure, Success>` from `fpdart`. No bare `throw`.
- Use `flutter_bloc`. Cubit only for purely local UI state — anything bus-related is a full BLoC.
- Constructor injection only. No `get_it`, no service locator.
- Logging goes through `CgLogger`. `print` and `debugPrint` are banned.
- File ≤ 300 lines, function ≤ 30 lines, class ≤ 200 lines, parameters ≤ 5.
- No barrel files. Every import is explicit.
- Test path mirrors source path under `test/<tier>/`. Tiers are unit / contract / integration / e2e.
- Mocking: `mocktail` only. `mockito` is banned.

## CI gates

| Stage | Tier | Blocking |
| --- | --- | --- |
| PR | unit + contract + lint + coverage thresholds | yes |
| Merge to main | integration | yes |
| Release branch | e2e | yes |

A failing lint, a missing dartdoc on a contract surface, or an unhandled `Left` will fail CI. Fix the cause; do not blanket-ignore.

## Adding a plugin

1. Create `lib/plugins/<name>/{data,domain,presentation}/`.
2. Implement the plugin contract (`*Plugin`) defined in `core/shared/domain`.
3. Add a manifest with the minimum fields from ADR-002.
4. Add a contract test under `test/contract/plugins/<name>/` — 100% coverage required.
5. Communicate with other features via the event bus only.
