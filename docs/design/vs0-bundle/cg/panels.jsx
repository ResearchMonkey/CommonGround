// cg/panels.jsx — Bottom sheets, drawers, popovers.

// Generic half-sheet container (slides up from bottom)
function Sheet({ children, onClose, height = 480, title, drag = true, action }) {
  return (
    <>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0, background: CG.scrim,
        zIndex: 30, animation: 'cgFadeIn 180ms ease-out',
      }}/>
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        height, zIndex: 31,
        background: CG.surface0,
        borderTop: `1px solid ${CG.hudBorderStrong}`,
        borderTopLeftRadius: 18, borderTopRightRadius: 18,
        boxShadow: '0 -20px 50px rgba(0,0,0,0.6)',
        animation: 'cgSlideUp 200ms cubic-bezier(.2,.8,.2,1)',
        display: 'flex', flexDirection: 'column', overflow: 'hidden',
      }}>
        {drag && (
          <div style={{ display: 'flex', justifyContent: 'center', padding: '8px 0 4px' }}>
            <div style={{ width: 40, height: 4, borderRadius: 2, background: CG.text3 }}/>
          </div>
        )}
        {title && (
          <div style={{
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            padding: '8px 16px 12px',
          }}>
            <div style={{ color: CG.text, fontSize: 16, fontWeight: 600 }}>{title}</div>
            <div style={{ display: 'flex', gap: 8 }}>
              {action}
              <button onClick={onClose} aria-label="Close"
                style={{
                  width: 36, height: 36, borderRadius: 8,
                  background: CG.surface1, border: `1px solid ${CG.hudBorder}`,
                  color: CG.text, cursor: 'pointer',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>{Ic.close({ size: 18 })}</button>
            </div>
          </div>
        )}
        <div style={{ flex: 1, overflow: 'auto' }}>{children}</div>
      </div>
    </>
  );
}

// Stepped opacity buttons
function OpacityStep({ value, onChange }) {
  const steps = [25, 50, 75, 100];
  return (
    <div style={{ display: 'flex', gap: 4 }}>
      {steps.map(s => (
        <button key={s} onClick={() => onChange(s)}
          style={{
            minWidth: 44, height: 32, borderRadius: 6,
            background: value === s ? CG.text : 'transparent',
            color: value === s ? CG.bg : CG.text2,
            border: `1px solid ${value === s ? CG.text : CG.hudBorder}`,
            fontFamily: CG.fontMono, fontSize: 11, fontWeight: 600,
            cursor: 'pointer',
          }}>{s}</button>
      ))}
    </div>
  );
}

// One layer row
function LayerRow({ layer, onToggle, onOpacity }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10,
      padding: '10px 16px',
      borderTop: `1px solid ${CG.hudBorder}`,
    }}>
      {layer.draggable && (
        <div style={{ color: CG.text3, display: 'flex' }}>{Ic.drag({ size: 18 })}</div>
      )}
      <div style={{
        width: 28, height: 28, borderRadius: 6,
        background: layer.color || CG.surface2,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        color: layer.color ? CG.bg : CG.text2,
      }}>{layer.icon ? Ic[layer.icon]({ size: 16 }) : null}</div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ color: CG.text, fontSize: 14, fontWeight: 500 }}>{layer.name}</div>
        {layer.meta && (
          <div style={{ color: CG.text3, fontSize: 11, fontFamily: CG.fontMono, marginTop: 1 }}>{layer.meta}</div>
        )}
      </div>
      {layer.canOpacity && (
        <OpacityStep value={layer.opacity} onChange={(v) => onOpacity(layer.id, v)}/>
      )}
      <button onClick={() => onToggle(layer.id)} aria-label="Toggle"
        style={{
          width: 48, height: 48, borderRadius: 8,
          background: 'transparent', border: 'none',
          color: layer.visible ? CG.text : CG.text3, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
        {layer.visible ? Ic.eye({ size: 20 }) : Ic.eyeOff({ size: 20 })}
      </button>
    </div>
  );
}

function LayerGroup({ title, count, children }) {
  return (
    <div style={{ marginTop: 8 }}>
      <div style={{
        padding: '8px 16px',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        background: CG.surface1,
      }}>
        <div style={{
          color: CG.text2, fontFamily: CG.fontMono, fontSize: 10, fontWeight: 600,
          letterSpacing: 1.4, textTransform: 'uppercase',
        }}>{title}</div>
        <div style={{
          color: CG.text3, fontFamily: CG.fontMono, fontSize: 10,
        }}>{count}</div>
      </div>
      {children}
    </div>
  );
}

// Connection popover
function ConnectionPopover({ conn, onClose }) {
  const conf = conn === 'online'
    ? { color: CG.ok, label: 'ONLINE', transport: 'Hardline NIC', quality: '−42 dBm' }
    : conn === 'mesh'
    ? { color: CG.warn, label: 'MESH', transport: 'Wi-Fi Direct mesh', quality: '−68 dBm' }
    : { color: CG.danger, label: 'OFFLINE', transport: 'No transport', quality: '—' };
  return (
    <>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0, zIndex: 30,
      }}/>
      <div style={{
        position: 'absolute', top: 60, left: 12, zIndex: 31,
        width: 240, padding: 14,
        background: CG.surface0, borderRadius: 12,
        border: `1px solid ${CG.hudBorderStrong}`,
        boxShadow: '0 12px 40px rgba(0,0,0,0.6)',
        animation: 'cgFadeIn 150ms',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12 }}>
          <div style={{ width: 8, height: 8, borderRadius: '50%', background: conf.color }}/>
          <div style={{ color: conf.color, fontFamily: CG.fontMono, fontSize: 12, fontWeight: 700, letterSpacing: 1.5 }}>
            {conf.label}
          </div>
        </div>
        {[
          ['Transport', conf.transport],
          ['Peers', conn === 'offline' ? '0' : conn === 'mesh' ? '7 visible' : '12 visible'],
          ['Signal', conf.quality],
          ['Last sync', conn === 'offline' ? '14m ago' : '4s ago'],
        ].map(([k, v]) => (
          <div key={k} style={{
            display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
            padding: '6px 0',
            borderTop: k === 'Transport' ? 'none' : `1px solid ${CG.hudBorder}`,
          }}>
            <div style={{ color: CG.text3, fontSize: 11, fontFamily: CG.fontMono, textTransform: 'uppercase', letterSpacing: 1 }}>{k}</div>
            <div style={{ color: CG.text, fontSize: 12, fontFamily: CG.fontMono }}>{v}</div>
          </div>
        ))}
      </div>
    </>
  );
}

// Slide-out menu (right edge)
function SlideOutMenu({ onClose }) {
  const sections = [
    {
      title: 'Active Plugins',
      items: [
        { name: 'Elevation', meta: 'v1.4.0', toggle: true, on: true },
        { name: 'CoT Relay', meta: 'v0.9.2', toggle: true, on: true },
        { name: 'Sensor Feeds', meta: 'v2.0.1', toggle: true, on: false },
        { name: 'Network Mgr', meta: 'v1.1.0', toggle: true, on: true },
      ],
    },
    {
      title: 'Settings',
      items: [
        { name: 'Coordinate format', meta: 'MGRS', icon: 'chevRight' },
        { name: 'Map orientation', meta: 'North-up', icon: 'chevRight' },
        { name: 'Theme', meta: 'Dark', icon: 'chevRight' },
        { name: 'Tile cache', meta: '1.2 GB', icon: 'chevRight' },
      ],
    },
    {
      title: 'Data',
      items: [
        { name: 'Import KML/GPX/KMZ', icon: 'upload' },
        { name: 'Export…', icon: 'download' },
        { name: 'Favorites', meta: '4 saved', icon: 'star' },
      ],
    },
    {
      title: 'About',
      items: [
        { name: 'Version', meta: '0.4.1' },
        { name: 'Node ID', meta: 'cg-7af2', mono: true },
        { name: 'Channel', meta: 'Alpha', mono: true },
        { name: 'Diagnostics', icon: 'chevRight' },
      ],
    },
  ];
  return (
    <>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0, background: CG.scrim, zIndex: 30,
        animation: 'cgFadeIn 180ms',
      }}/>
      <div style={{
        position: 'absolute', top: 0, right: 0, bottom: 0,
        width: 296, zIndex: 31,
        background: CG.surface0,
        borderLeft: `1px solid ${CG.hudBorderStrong}`,
        animation: 'cgSlideRight 220ms cubic-bezier(.2,.8,.2,1)',
        display: 'flex', flexDirection: 'column', overflow: 'hidden',
      }}>
        {/* Header — CG badge */}
        <div style={{
          padding: '20px 16px 16px',
          display: 'flex', alignItems: 'center', gap: 12,
          borderBottom: `1px solid ${CG.hudBorder}`,
        }}>
          <div style={{
            width: 40, height: 40,
            background: CG.text, color: CG.bg,
            border: `2px solid ${CG.text}`,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: CG.fontMono, fontSize: 14, fontWeight: 700, letterSpacing: 0.5,
            clipPath: 'polygon(8% 0, 100% 0, 92% 100%, 0% 100%)',
          }}>CG</div>
          <div style={{ flex: 1 }}>
            <div style={{ color: CG.text, fontSize: 14, fontWeight: 600 }}>CommonGround</div>
            <div style={{ color: CG.text3, fontSize: 11, fontFamily: CG.fontMono, marginTop: 1 }}>
              cg-7af2 · Alpha
            </div>
          </div>
          <button onClick={onClose} aria-label="Close"
            style={{
              width: 36, height: 36, borderRadius: 8,
              background: CG.surface1, border: `1px solid ${CG.hudBorder}`,
              color: CG.text, cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>{Ic.close({ size: 18 })}</button>
        </div>

        <div style={{ flex: 1, overflow: 'auto' }}>
          {sections.map((s, i) => (
            <div key={i}>
              <div style={{
                padding: '14px 16px 6px',
                color: CG.text3, fontFamily: CG.fontMono, fontSize: 10, fontWeight: 600,
                letterSpacing: 1.4, textTransform: 'uppercase',
              }}>{s.title}</div>
              {s.items.map((it, j) => (
                <div key={j} style={{
                  display: 'flex', alignItems: 'center', gap: 10,
                  padding: '10px 16px', minHeight: 48,
                  borderTop: `1px solid ${CG.hudBorder}`,
                }}>
                  <div style={{ flex: 1, color: CG.text, fontSize: 14 }}>{it.name}</div>
                  {it.meta && (
                    <div style={{
                      color: CG.text2, fontSize: 12,
                      fontFamily: it.mono ? CG.fontMono : CG.font,
                    }}>{it.meta}</div>
                  )}
                  {it.toggle && (
                    <div style={{
                      width: 36, height: 22, borderRadius: 12,
                      background: it.on ? CG.ok : CG.surface2,
                      position: 'relative', transition: 'background 120ms',
                    }}>
                      <div style={{
                        position: 'absolute', top: 2,
                        left: it.on ? 16 : 2,
                        width: 18, height: 18, borderRadius: '50%',
                        background: '#fff', transition: 'left 120ms',
                      }}/>
                    </div>
                  )}
                  {it.icon && Ic[it.icon] && (
                    <div style={{ color: CG.text3 }}>{Ic[it.icon]({ size: 16 })}</div>
                  )}
                </div>
              ))}
            </div>
          ))}
        </div>
      </div>
    </>
  );
}

// Coordinate readout (after map tap)
function CoordReadout({ coord, fmt = 'MGRS', onDrop, onDismiss }) {
  return (
    <div style={{
      position: 'absolute', left: '50%', bottom: 90,
      transform: 'translateX(-50%)', zIndex: 22,
      background: CG.surface0,
      border: `1px solid ${CG.hudBorderStrong}`,
      borderRadius: 12,
      padding: '10px 12px',
      display: 'flex', alignItems: 'center', gap: 10,
      boxShadow: '0 10px 30px rgba(0,0,0,0.6)',
      animation: 'cgFadeIn 150ms',
    }}>
      <div>
        <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 9, letterSpacing: 1.4, textTransform: 'uppercase' }}>
          {fmt}
        </div>
        <div style={{ color: CG.text, fontFamily: CG.fontMono, fontSize: 13, fontWeight: 600 }}>
          {coord}
        </div>
      </div>
      <button onClick={onDrop}
        style={{
          height: 40, padding: '0 14px',
          background: CG.text, color: CG.bg,
          border: 'none', borderRadius: 8,
          fontSize: 13, fontWeight: 600, cursor: 'pointer',
          display: 'flex', alignItems: 'center', gap: 6,
        }}>
        {Ic.pinPlus({ size: 16, stroke: 2.2 })}
        Drop here
      </button>
      <button onClick={onDismiss} aria-label="Dismiss"
        style={{
          width: 36, height: 36, borderRadius: 8,
          background: 'transparent', border: `1px solid ${CG.hudBorder}`,
          color: CG.text2, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{Ic.close({ size: 16 })}</button>
    </div>
  );
}

Object.assign(window, { Sheet, OpacityStep, LayerRow, LayerGroup, ConnectionPopover, SlideOutMenu, CoordReadout });
