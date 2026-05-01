# VS.0 — UI Design Bundle (Authoritative)

**Source:** Claude Design (`claude.ai/design`) export, locked alongside Confluence page
[Session VS.0 — UI Design Spec & Implementation Plan v1.0](https://echo8lohrer.atlassian.net/wiki/spaces/CG/pages/212172801).

This directory is the canonical visual reference for all VS.x build sessions.
The Confluence spec is the textual contract; these files are the pixel contract.

## Files

| File | Purpose |
|---|---|
| `CommonGround.html` | Entry point. Open in a browser to see the full artboard canvas. |
| `design-canvas.jsx` | Artboard layout framework. |
| `android-frame.jsx` | Phone frame wrapper. |
| `tokens.jsx` | Top-level design tokens (palette, sizing, type). |
| `cg/tokens.jsx` | CG-namespaced token re-export. |
| `cg/icons.jsx` | 40+ SVG icon components — source of truth for `HudIconGlyph` painters. |
| `cg/map.jsx` | Procedural topographic map background. |
| `cg/markers.jsx` | Marker rendering (custom + CoT + self). |
| `cg/hud.jsx` | Floating HUD (top bar, bottom bar, compass, zoom, scale). **Bottom-bar action mapping lives here.** |
| `cg/panels.jsx` | Sheets, popovers, slide-out menu, coord readout. |
| `cg/screen.jsx` | Full screen compositions for all 11 artboard states. |
| `cg/app.jsx` | Artboard canvas mount. |

## How to render

1. `cd docs/design/vs0-bundle && python3 -m http.server 8080` (or any static server).
2. Open `http://localhost:8080/CommonGround.html`.
3. The canvas renders all 11 states side-by-side.

## How to use during build

- For any chrome / glyph / sheet implementation, **read the matching `.jsx` first** to confirm: action ID, glyph choice, color token, size, padding, active-state styling.
- When the Flutter implementation diverges from the bundle, the bundle wins (per VS.0 "Pixel-fidelity requirements").
- If the spec needs a revision, log the change in [CG-spec-revision-log](https://echo8lohrer.atlassian.net/wiki/spaces/CG/pages/211714049) before editing the JSX.

## Provenance

Bundle was originally delivered as `Common Ground (Remix).zip` from Claude Design.
Vendored here on 2026-05-01 because the Confluence cloud plan in use does not
support page attachments.
