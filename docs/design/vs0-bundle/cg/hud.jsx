// cg/hud.jsx — Floating HUD: top bar, bottom action row, compass, zoom, scale.

// Connection status — solid / partial / hollow
function ConnIcon({ state, size = 18 }) {
  if (state === 'online')  return Ic.signal({ size, stroke: 2 });
  if (state === 'mesh')    return Ic.signalMesh({ size, stroke: 2 });
  return Ic.signalOff({ size, stroke: 2 });
}

function HudButton({ children, onClick, active, size = 48, style, label }) {
  return (
    <button onClick={onClick} aria-label={label}
      style={{
        width: size, height: size,
        background: active ? CG.text : CG.hudBg,
        backdropFilter: 'blur(8px)',
        WebkitBackdropFilter: 'blur(8px)',
        color: active ? CG.bg : CG.text,
        border: `1px solid ${active ? CG.text : CG.hudBorder}`,
        borderRadius: CG.radius,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        cursor: 'pointer',
        transition: 'background 120ms, color 120ms',
        ...style,
      }}>
      {children}
    </button>
  );
}

// Top floating bar — connection / channel / coord format
function TopBar({ conn = 'mesh', channel = 'Alpha', nodes = 7, coordFmt = 'MGRS', onConnTap, onCoordTap }) {
  const connColor = conn === 'online' ? CG.ok : conn === 'mesh' ? CG.warn : CG.danger;
  return (
    <div style={{
      position: 'absolute', top: 12, left: 12, right: 12, zIndex: 20,
      display: 'flex', gap: 8, alignItems: 'center',
      pointerEvents: 'none',
    }}>
      <button onClick={onConnTap} aria-label="Connection"
        style={{
          height: 40, padding: '0 10px',
          background: CG.hudBg, backdropFilter: 'blur(8px)',
          border: `1px solid ${CG.hudBorder}`, borderRadius: CG.radius,
          display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer',
          color: connColor, pointerEvents: 'auto',
        }}>
        <ConnIcon state={conn} size={16}/>
        <span style={{
          fontFamily: CG.fontMono, fontSize: 10, fontWeight: 600,
          letterSpacing: 1, textTransform: 'uppercase', color: connColor,
        }}>{conn === 'online' ? 'ONLINE' : conn === 'mesh' ? 'MESH' : 'OFFLINE'}</span>
      </button>

      <div style={{
        flex: 1, height: 40, padding: '0 12px',
        background: CG.hudBg, backdropFilter: 'blur(8px)',
        border: `1px solid ${CG.hudBorder}`, borderRadius: CG.radius,
        display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        pointerEvents: 'auto',
      }}>
        <div style={{ width: 6, height: 6, borderRadius: '50%', background: CG.ok }}/>
        <span style={{ color: CG.text, fontSize: 13, fontWeight: 600 }}>
          {channel}
        </span>
        <span style={{ color: CG.text3, fontSize: 11, fontFamily: CG.fontMono }}>·</span>
        <span style={{ color: CG.text2, fontSize: 12, fontFamily: CG.fontMono, fontWeight: 500 }}>
          {nodes}
        </span>
      </div>

      <button onClick={onCoordTap} aria-label="Coordinate format"
        style={{
          height: 40, padding: '0 10px', minWidth: 56,
          background: CG.hudBg, backdropFilter: 'blur(8px)',
          border: `1px solid ${CG.hudBorder}`, borderRadius: CG.radius,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          color: CG.text, fontFamily: CG.fontMono, fontSize: 11, fontWeight: 600,
          letterSpacing: 1, cursor: 'pointer', pointerEvents: 'auto',
        }}>
        {coordFmt}
      </button>
    </div>
  );
}

// Compass rose
function Compass({ bearing = 0, mode = 'north', locked, onTap, onLongPress }) {
  const pressTimer = React.useRef();
  const handleDown = () => { pressTimer.current = setTimeout(onLongPress, 500); };
  const handleUp = () => { clearTimeout(pressTimer.current); };
  return (
    <button onClick={onTap}
      onMouseDown={handleDown} onMouseUp={handleUp} onMouseLeave={handleUp}
      onTouchStart={handleDown} onTouchEnd={handleUp}
      aria-label={`Compass ${mode === 'track' ? 'track-up' : 'north-up'}`}
      style={{
        width: 56, height: 56,
        background: CG.hudBg, backdropFilter: 'blur(8px)',
        border: `1px solid ${CG.hudBorder}`, borderRadius: '50%',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        cursor: 'pointer', position: 'relative', padding: 0,
      }}>
      <svg width="40" height="40" viewBox="0 0 40 40" style={{ transform: `rotate(${-bearing}deg)`, transition: 'transform 200ms' }}>
        {/* tick ring */}
        {[0, 90, 180, 270].map(deg => (
          <line key={deg} x1="20" y1="3" x2="20" y2="6"
            stroke={CG.text3} strokeWidth="1"
            transform={`rotate(${deg} 20 20)`}/>
        ))}
        {/* north arrow (red top) */}
        <polygon points="20,6 17,20 20,17 23,20" fill={CG.danger}/>
        <polygon points="20,34 17,20 20,23 23,20" fill={CG.text2}/>
        <circle cx="20" cy="20" r="2" fill={CG.text}/>
      </svg>
      <div style={{
        position: 'absolute', bottom: 3, left: '50%', transform: 'translateX(-50%)',
        fontFamily: CG.fontMono, fontSize: 8, fontWeight: 700,
        color: mode === 'track' ? CG.warn : CG.text2,
        letterSpacing: 0.5,
      }}>{mode === 'track' ? 'TRK' : 'N'}</div>
      {locked && (
        <div style={{
          position: 'absolute', top: -2, right: -2,
          width: 16, height: 16, borderRadius: '50%',
          background: CG.warn, color: CG.bg,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{Ic.lock({ size: 9, stroke: 2.5 })}</div>
      )}
    </button>
  );
}

// Zoom buttons (vertical)
function ZoomCluster({ onZoomIn, onZoomOut }) {
  return (
    <div style={{
      display: 'flex', flexDirection: 'column',
      background: CG.hudBg, backdropFilter: 'blur(8px)',
      border: `1px solid ${CG.hudBorder}`, borderRadius: CG.radius,
      overflow: 'hidden',
    }}>
      <button onClick={onZoomIn} aria-label="Zoom in"
        style={{
          width: 48, height: 48, background: 'transparent', border: 'none',
          color: CG.text, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          borderBottom: `1px solid ${CG.hudBorder}`,
        }}>{Ic.plus({ size: 22 })}</button>
      <button onClick={onZoomOut} aria-label="Zoom out"
        style={{
          width: 48, height: 48, background: 'transparent', border: 'none',
          color: CG.text, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{Ic.minus({ size: 22 })}</button>
    </div>
  );
}

// Scale bar (bottom-left)
function ScaleBar() {
  return (
    <div style={{
      display: 'flex', flexDirection: 'column', gap: 2,
      pointerEvents: 'none',
    }}>
      <div style={{ display: 'flex', alignItems: 'flex-end' }}>
        <div style={{ width: 1, height: 6, background: CG.text }}/>
        <div style={{ width: 60, height: 2, background: CG.text }}/>
        <div style={{ width: 1, height: 6, background: CG.text }}/>
      </div>
      <div style={{
        fontFamily: CG.fontMono, fontSize: 10, color: CG.text,
        textShadow: '0 1px 3px rgba(0,0,0,0.9)', letterSpacing: 0.5,
      }}>500 m</div>
    </div>
  );
}

// Bottom action row — 5 primary actions
function BottomBar({ active, onAction }) {
  const items = [
    { id: 'self',   icon: Ic.crosshair, label: 'Self-locate' },
    { id: 'drop',   icon: Ic.pinPlus,   label: 'Drop marker', primary: true },
    { id: 'layers', icon: Ic.layers,    label: 'Layers' },
    { id: 'search', icon: Ic.search,    label: 'Search' },
    { id: 'menu',   icon: Ic.menu,      label: 'Menu' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 12, left: 12, right: 12, zIndex: 20,
      display: 'flex', gap: 6,
      background: CG.hudBg, backdropFilter: 'blur(10px)',
      border: `1px solid ${CG.hudBorder}`,
      borderRadius: CG.radiusLg,
      padding: 6,
    }}>
      {items.map(it => {
        const isActive = active === it.id;
        const isPrimary = it.primary;
        return (
          <button key={it.id} onClick={() => onAction(it.id)} aria-label={it.label}
            style={{
              flex: 1, height: 56,
              background: isActive ? CG.text : (isPrimary ? CG.surface2 : 'transparent'),
              color: isActive ? CG.bg : CG.text,
              border: isPrimary && !isActive ? `1px solid ${CG.hudBorderStrong}` : 'none',
              borderRadius: CG.radius,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer', position: 'relative',
              transition: 'background 120ms, color 120ms',
            }}>
            {it.icon({ size: 24, stroke: isPrimary ? 2 : 1.75 })}
            {isActive && (
              <div style={{
                position: 'absolute', top: 4, right: 4,
                width: 6, height: 6, borderRadius: '50%', background: CG.bg,
              }}/>
            )}
          </button>
        );
      })}
    </div>
  );
}

Object.assign(window, { TopBar, BottomBar, Compass, ZoomCluster, ScaleBar, ConnIcon, HudButton });
