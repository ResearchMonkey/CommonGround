// cg/markers.jsx — Marker rendering (CoT + custom CG markers).

const CATS = {
  medical:  { color: 'catMedical',  icon: 'cross',    label: 'Medical' },
  hazard:   { color: 'catHazard',   icon: 'warning',  label: 'Hazard' },
  nav:      { color: 'catNav',      icon: 'flag',     label: 'Navigation' },
  resource: { color: 'catResource', icon: 'box',      label: 'Resource' },
  team:     { color: 'catTeam',     icon: 'user',     label: 'Team' },
  infra:    { color: 'catInfra',    icon: 'building', label: 'Infrastructure' },
};

// Visual marker on the map. CoT markers render as a diamond outline
// (MIL-STD-2525 nod), custom markers render as a colored disc with icon.
function MapMarker({ marker, selected, onClick }) {
  const { x, y, kind = 'custom', cat = 'nav', label, callsign, state = 'active', pinned } = marker;
  const meta = CATS[cat] || CATS.nav;
  const color = CG[meta.color] || CG.text;
  const stale = state === 'stale';
  const baseSize = kind === 'cot' ? 26 : 28;

  return (
    <button onClick={onClick} aria-label={label}
      style={{
        position: 'absolute',
        left: x, top: y,
        transform: 'translate(-50%, -50%)',
        background: 'transparent', border: 'none', padding: 0, cursor: 'pointer',
        filter: stale ? 'opacity(0.55)' : 'none',
        zIndex: selected ? 5 : 2,
      }}>
      {/* Selection halo */}
      {selected && (
        <div style={{
          position: 'absolute', left: '50%', top: '50%',
          transform: 'translate(-50%, -50%)',
          width: baseSize + 22, height: baseSize + 22, borderRadius: '50%',
          border: `1.5px solid ${CG.text}`,
          boxShadow: `0 0 0 2px rgba(15,20,25,0.7)`,
          animation: 'cgPulse 1.4s ease-in-out infinite',
        }}/>
      )}
      {kind === 'cot' ? (
        <div style={{
          width: baseSize, height: baseSize,
          background: color,
          transform: 'rotate(45deg)',
          border: stale ? `1.5px dashed ${CG.bg}` : `1.5px solid ${CG.bg}`,
          boxShadow: `0 2px 8px rgba(0,0,0,0.6), 0 0 0 1px ${color}`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <div style={{
            transform: 'rotate(-45deg)',
            color: CG.bg, fontFamily: CG.fontMono, fontSize: 10, fontWeight: 700,
          }}>{callsign?.slice(0, 2).toUpperCase() || 'CT'}</div>
        </div>
      ) : (
        <div style={{
          width: baseSize, height: baseSize, borderRadius: '50%',
          background: color, color: CG.bg,
          border: stale ? `1.5px dashed ${CG.bg}` : `1.5px solid ${CG.bg}`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: `0 2px 8px rgba(0,0,0,0.6)`,
        }}>
          {Ic[meta.icon]({ size: 16, stroke: 2.2 })}
        </div>
      )}
      {pinned && (
        <div style={{
          position: 'absolute', top: -4, right: -4,
          width: 14, height: 14, borderRadius: '50%',
          background: CG.warn, color: CG.bg,
          border: `1.5px solid ${CG.bg}`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          {Ic.pinFilled({ size: 8, stroke: 2.5 })}
        </div>
      )}
      {label && selected && (
        <div style={{
          position: 'absolute', top: baseSize + 6, left: '50%',
          transform: 'translateX(-50%)',
          background: CG.hudBgSolid,
          color: CG.text,
          fontFamily: CG.fontMono, fontSize: 10, fontWeight: 500,
          padding: '3px 7px', borderRadius: 4,
          border: `1px solid ${CG.hudBorder}`,
          whiteSpace: 'nowrap',
        }}>{label}</div>
      )}
    </button>
  );
}

// Self / GPS marker — pulsing blue dot
function SelfMarker({ x, y, heading = 0 }) {
  return (
    <div style={{
      position: 'absolute', left: x, top: y,
      transform: 'translate(-50%, -50%)', zIndex: 4,
    }}>
      <div style={{
        position: 'absolute', left: '50%', top: '50%',
        transform: 'translate(-50%, -50%)',
        width: 56, height: 56, borderRadius: '50%',
        background: 'rgba(125, 211, 252, 0.18)',
        animation: 'cgPulse 2s ease-out infinite',
      }}/>
      {/* Heading cone */}
      <div style={{
        position: 'absolute', left: '50%', top: '50%',
        width: 0, height: 0,
        borderLeft: '12px solid transparent',
        borderRight: '12px solid transparent',
        borderBottom: '20px solid rgba(125, 211, 252, 0.55)',
        transform: `translate(-50%, -100%) rotate(${heading}deg)`,
        transformOrigin: '50% 100%',
      }}/>
      <div style={{
        width: 16, height: 16, borderRadius: '50%',
        background: '#7DD3FC',
        border: `2.5px solid ${CG.bg}`,
        boxShadow: '0 0 0 1.5px #7DD3FC, 0 2px 6px rgba(0,0,0,0.5)',
      }}/>
    </div>
  );
}

// Pulse keyframes — inject once
if (typeof document !== 'undefined' && !document.getElementById('cg-anim')) {
  const s = document.createElement('style');
  s.id = 'cg-anim';
  s.textContent = `
    @keyframes cgPulse {
      0%, 100% { opacity: 0.55; transform: translate(-50%, -50%) scale(0.95); }
      50% { opacity: 0.15; transform: translate(-50%, -50%) scale(1.15); }
    }
    @keyframes cgSlideUp {
      from { transform: translateY(100%); }
      to { transform: translateY(0); }
    }
    @keyframes cgSlideRight {
      from { transform: translateX(100%); }
      to { transform: translateX(0); }
    }
    @keyframes cgFadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    @keyframes cgScaleIn {
      from { opacity: 0; transform: translate(-50%, -50%) scale(0.6); }
      to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
    }
  `;
  document.head.appendChild(s);
}

Object.assign(window, { MapMarker, SelfMarker, CATS });
