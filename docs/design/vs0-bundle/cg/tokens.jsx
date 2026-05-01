// cg/tokens.jsx — Design tokens for CommonGround
// Dark tactical HUD palette + IBM Plex type scale.

const CG = {
  // Surfaces — deep charcoal with cool undertone, never pure black
  bg:       '#0F1419',   // map background fallback
  surface0: '#11161C',   // sheet/panel base
  surface1: '#161C24',   // raised surface (cards)
  surface2: '#1C2530',   // highest surface
  hudBg:    'rgba(15, 20, 25, 0.78)', // floating HUD chrome
  hudBgSolid: '#0F1419',
  hudBorder: 'rgba(232, 234, 237, 0.10)',
  hudBorderStrong: 'rgba(232, 234, 237, 0.18)',
  scrim:    'rgba(8, 11, 15, 0.55)',

  // Text — neutral, no saturation
  text:     '#E8EAED',   // primary
  text2:    '#A7AFBA',   // secondary
  text3:    '#6E7785',   // tertiary / disabled
  textInv:  '#0F1419',

  // Status — high-contrast for sunlight
  ok:       '#4ADE80',   // online / safe
  okSoft:   'rgba(74, 222, 128, 0.16)',
  warn:     '#FBBF24',   // mesh / caution
  warnSoft: 'rgba(251, 191, 36, 0.18)',
  danger:   '#EF4444',   // offline / hazard
  dangerSoft:'rgba(239, 68, 68, 0.18)',

  // Marker category colors (consistent saturation/lightness, hue-varied)
  catMedical:    '#F87171',  // red
  catHazard:     '#FB923C',  // orange
  catNav:        '#E8EAED',  // neutral
  catResource:   '#60A5FA',  // blue
  catTeam:       '#A78BFA',  // violet
  catInfra:      '#94A3B8',  // slate

  // Sizing
  hit: 48,                     // minimum tap target (dp)
  radius: 10,                  // standard corner
  radiusSm: 6,
  radiusLg: 14,

  // Type
  font:      "'IBM Plex Sans', system-ui, sans-serif",
  fontMono:  "'IBM Plex Mono', ui-monospace, monospace",
};

// Phone size — Galaxy A52 class (1080x2400 native, scaled to dp)
// We render at 360 x 800 dp viewport.
const CG_PHONE = { w: 360, h: 800 };

Object.assign(window, { CG, CG_PHONE });
