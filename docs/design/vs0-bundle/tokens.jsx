// CommonGround design tokens — neutral HUD palette
// Dark tactical, high contrast, monospace coords

const CG = {
  // Surfaces
  bg: '#0F1419',          // map bg / deepest
  surface0: '#161C23',    // hud panel base
  surface1: '#1E252E',    // raised
  surface2: '#262E3A',    // hover/selected
  surface3: '#323B49',    // border emphasis
  scrim: 'rgba(15, 20, 25, 0.78)',
  panelGlass: 'rgba(22, 28, 35, 0.92)',

  // Lines
  border: 'rgba(255,255,255,0.08)',
  borderStrong: 'rgba(255,255,255,0.16)',
  borderHud: 'rgba(232, 234, 237, 0.22)',

  // Text
  text: '#E8EAED',
  textDim: '#B6BEC8',
  textMute: '#8B95A1',
  textFaint: '#5A6573',

  // Status
  online: '#4ADE80',
  mesh: '#FBBF24',
  offline: '#EF4444',

  // Marker categories (civilian)
  medical: '#F87171',
  hazard: '#FB923C',
  nav: '#60A5FA',
  resource: '#34D399',
  team: '#A78BFA',
  infra: '#94A3B8',

  // Map terrain
  terrainLow: '#162028',
  terrainMid: '#1B2730',
  terrainHigh: '#22303B',
  terrainPeak: '#2A3744',
  contour: 'rgba(184, 196, 210, 0.10)',
  contourMajor: 'rgba(184, 196, 210, 0.20)',
  water: '#1A3140',
  waterEdge: '#274A5E',
  road: 'rgba(232, 234, 237, 0.45)',
  roadMinor: 'rgba(232, 234, 237, 0.18)',
  trail: 'rgba(232, 234, 237, 0.12)',
  grid: 'rgba(232, 234, 237, 0.05)',
};

const FONT = {
  sans: '"IBM Plex Sans", system-ui, -apple-system, sans-serif',
  mono: '"IBM Plex Mono", ui-monospace, monospace',
};

// HUD panel base style
const hudPanel = {
  background: CG.panelGlass,
  border: `1px solid ${CG.borderHud}`,
  backdropFilter: 'blur(8px)',
  WebkitBackdropFilter: 'blur(8px)',
  color: CG.text,
};

window.CG = CG;
window.FONT = FONT;
window.hudPanel = hudPanel;
