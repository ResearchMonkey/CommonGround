// cg/screen.jsx — The phone screen composition.
// Renders one full main-screen state. State is driven by `state` prop:
//   default | layers | search | searchExpanded | menu | markerDetail
//   | dropStep1 | dropStep2 | connPopover | mapTap
// Density: 'field' or 'busy'.

// Marker fixtures
const FIELD_MARKERS = [
  { id: 'm1', x: 180, y: 320, kind: 'custom', cat: 'team',  label: 'Bravo-1', state: 'active' },
  { id: 'm2', x: 240, y: 410, kind: 'custom', cat: 'nav',   label: 'Rally Pt', state: 'active', pinned: true },
  { id: 'm3', x: 110, y: 470, kind: 'custom', cat: 'medical', label: 'Aid Stn 1', state: 'active' },
  { id: 'm4', x: 270, y: 250, kind: 'cot',     callsign: 'AL', label: 'Alpha-Lead', state: 'active' },
];

const BUSY_MARKERS = [
  ...FIELD_MARKERS,
  { id: 'b1', x: 80,  y: 220, kind: 'custom', cat: 'hazard',   label: 'Slide zone', state: 'active' },
  { id: 'b2', x: 305, y: 180, kind: 'custom', cat: 'hazard',   label: 'Fire 412', state: 'stale' },
  { id: 'b3', x: 60,  y: 350, kind: 'custom', cat: 'resource', label: 'Water cache', state: 'active' },
  { id: 'b4', x: 145, y: 540, kind: 'custom', cat: 'resource', label: 'Fuel', state: 'active' },
  { id: 'b5', x: 220, y: 560, kind: 'cot',    callsign: 'C2',  label: 'Charlie-2', state: 'active' },
  { id: 'b6', x: 290, y: 480, kind: 'cot',    callsign: 'C3',  label: 'Charlie-3', state: 'stale' },
  { id: 'b7', x: 50,  y: 560, kind: 'custom', cat: 'team',     label: 'Delta-1', state: 'active' },
  { id: 'b8', x: 320, y: 550, kind: 'custom', cat: 'infra',    label: 'Bridge', state: 'active', pinned: true },
  { id: 'b9', x: 200, y: 200, kind: 'custom', cat: 'medical',  label: 'CCP', state: 'active' },
  { id: 'b10', x: 320, y: 380, kind: 'custom', cat: 'nav',     label: 'WP-7', state: 'active' },
  { id: 'b11', x: 130, y: 270, kind: 'custom', cat: 'team',    label: 'Bravo-2', state: 'stale' },
  { id: 'b12', x: 235, y: 350, kind: 'cot',    callsign: 'EN', label: 'Engr', state: 'active' },
];

function CGScreen({ state = 'default', density = 'field', label, conn, selectedId = 'm2' }) {
  const markers = density === 'busy' ? BUSY_MARKERS : FIELD_MARKERS;
  const connState = conn || (density === 'busy' ? 'mesh' : 'online');

  // Phone screen content
  return (
    <div className="cg-phone" style={{
      width: CG_PHONE.w, height: CG_PHONE.h,
      position: 'relative', overflow: 'hidden',
      background: CG.bg, color: CG.text,
      fontFamily: CG.font,
    }}>
      {/* MAP */}
      <TopoMap width={CG_PHONE.w} height={CG_PHONE.h} seed={density === 'busy' ? 11 : 7}
        dim={density === 'busy' ? 1 : 0.85} />

      {/* Busy-ops overlay layer (extra raster tint for elevation plugin) */}
      {density === 'busy' && (
        <div style={{
          position: 'absolute', inset: 0,
          background: 'radial-gradient(ellipse at 30% 40%, rgba(251,191,36,0.10), transparent 50%), radial-gradient(ellipse at 70% 75%, rgba(96,165,250,0.10), transparent 55%)',
          pointerEvents: 'none',
        }}/>
      )}

      {/* MARKERS */}
      {markers.map(m => (
        <MapMarker key={m.id} marker={m} selected={state === 'markerDetail' && m.id === selectedId}/>
      ))}

      {/* SELF */}
      <SelfMarker x={170} y={430} heading={32}/>

      {/* Map tap crosshair (for coord readout state) */}
      {state === 'mapTap' && (
        <div style={{
          position: 'absolute', left: 220, top: 360,
          transform: 'translate(-50%, -50%)', zIndex: 3,
        }}>
          <svg width="40" height="40" viewBox="0 0 40 40">
            <circle cx="20" cy="20" r="14" fill="none" stroke={CG.text} strokeWidth="1.5"/>
            <line x1="20" y1="0" x2="20" y2="14" stroke={CG.text} strokeWidth="1.5"/>
            <line x1="20" y1="26" x2="20" y2="40" stroke={CG.text} strokeWidth="1.5"/>
            <line x1="0" y1="20" x2="14" y2="20" stroke={CG.text} strokeWidth="1.5"/>
            <line x1="26" y1="20" x2="40" y2="20" stroke={CG.text} strokeWidth="1.5"/>
            <circle cx="20" cy="20" r="2" fill={CG.text}/>
          </svg>
        </div>
      )}

      {/* Drop step 1 — center crosshair fixed */}
      {state === 'dropStep1' && (
        <div style={{
          position: 'absolute', left: '50%', top: '50%',
          transform: 'translate(-50%, -50%)', zIndex: 3, pointerEvents: 'none',
        }}>
          <svg width="56" height="56" viewBox="0 0 56 56">
            <circle cx="28" cy="28" r="22" fill="none" stroke={CG.warn} strokeWidth="2"/>
            <circle cx="28" cy="28" r="3" fill={CG.warn}/>
            <line x1="28" y1="2" x2="28" y2="18" stroke={CG.warn} strokeWidth="2"/>
            <line x1="28" y1="38" x2="28" y2="54" stroke={CG.warn} strokeWidth="2"/>
            <line x1="2" y1="28" x2="18" y2="28" stroke={CG.warn} strokeWidth="2"/>
            <line x1="38" y1="28" x2="54" y2="28" stroke={CG.warn} strokeWidth="2"/>
          </svg>
        </div>
      )}

      {/* TOP BAR */}
      <TopBar conn={connState} channel="Alpha" nodes={density === 'busy' ? 12 : 7} coordFmt="MGRS"/>

      {/* COMPASS + ZOOM (right side) */}
      <div style={{
        position: 'absolute', top: 64, right: 12, zIndex: 19,
        display: 'flex', flexDirection: 'column', gap: 10, alignItems: 'flex-end',
      }}>
        <Compass bearing={0} mode="north"/>
        <ZoomCluster/>
      </div>

      {/* SCALE BAR (bottom-left, above bottom bar) */}
      <div style={{ position: 'absolute', left: 14, bottom: 88, zIndex: 19 }}>
        <ScaleBar/>
      </div>

      {/* COORD HUD — small floating readout near scale */}
      <div style={{
        position: 'absolute', right: 76, bottom: 88, zIndex: 19,
        background: CG.hudBg, backdropFilter: 'blur(8px)',
        padding: '5px 9px', borderRadius: 6,
        border: `1px solid ${CG.hudBorder}`,
        fontFamily: CG.fontMono, fontSize: 10, fontWeight: 500,
        color: CG.text, letterSpacing: 0.5, textAlign: 'right',
        lineHeight: 1.3,
      }}>
        <div style={{ color: CG.text3, fontSize: 8, letterSpacing: 1 }}>SELF</div>
        <div>17T NK 8421 4193</div>
      </div>

      {/* BOTTOM BAR */}
      <BottomBar
        active={state === 'layers' ? 'layers'
              : state.startsWith('search') ? 'search'
              : state === 'menu' ? 'menu'
              : state.startsWith('drop') ? 'drop'
              : null}/>

      {/* OVERLAYS */}
      {state === 'mapTap' && (
        <CoordReadout coord="17T NK 8512 4287" fmt="MGRS"/>
      )}

      {state === 'connPopover' && <ConnPopoverWrap conn={connState}/>}

      {state === 'markerDetail' && <MarkerDetailWrap marker={markers.find(m => m.id === selectedId)}/>}

      {state === 'layers' && <LayerSheetWrap density={density}/>}

      {state === 'search' && <SearchSheetWrap density={density} expanded={false}/>}
      {state === 'searchExpanded' && <SearchSheetWrap density={density} expanded={true}/>}

      {state === 'dropStep2' && <DropSheetWrap/>}

      {state === 'menu' && <SlideOutMenu/>}

      {/* SCREEN LABEL (small badge at very top, outside hit zone) */}
      {label && (
        <div style={{
          position: 'absolute', top: 0, left: 0,
          background: CG.text, color: CG.bg,
          fontFamily: CG.fontMono, fontSize: 9, fontWeight: 700,
          letterSpacing: 1.5, padding: '3px 8px',
          borderBottomRightRadius: 6,
          zIndex: 50,
        }}>{label}</div>
      )}
    </div>
  );
}

// ─── Sub-components for overlay states ───────────────────────────────

function ConnPopoverWrap({ conn }) {
  return <ConnectionPopover conn={conn}/>;
}

function MarkerDetailWrap({ marker }) {
  if (!marker) return null;
  const meta = CATS[marker.cat] || CATS.nav;
  const color = CG[meta.color];
  return (
    <Sheet height={280} drag={true}>
      <div style={{ padding: '4px 16px 16px' }}>
        {/* header row */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14 }}>
          <div style={{
            width: 44, height: 44, borderRadius: '50%',
            background: color, color: CG.bg,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            border: `2px solid ${CG.bg}`, boxShadow: `0 0 0 1px ${color}`,
          }}>{Ic[meta.icon]({ size: 22, stroke: 2.2 })}</div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ color: CG.text, fontSize: 17, fontWeight: 600 }}>{marker.label}</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 2 }}>
              <span style={{
                color: CG.text3, fontFamily: CG.fontMono, fontSize: 10,
                letterSpacing: 1, textTransform: 'uppercase',
              }}>{meta.label}</span>
              {marker.pinned && (
                <span style={{
                  display: 'inline-flex', alignItems: 'center', gap: 3,
                  background: CG.warnSoft, color: CG.warn,
                  fontFamily: CG.fontMono, fontSize: 9, fontWeight: 600,
                  letterSpacing: 1, padding: '2px 6px', borderRadius: 3,
                }}>{Ic.pinFilled({ size: 9 })} PINNED</span>
              )}
            </div>
          </div>
        </div>

        {/* meta grid */}
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10,
          padding: '10px 12px', marginBottom: 12,
          background: CG.surface1, borderRadius: 8,
        }}>
          {[
            ['Coord', '17T NK 8521 4193', true],
            ['Owner', 'Bravo-1', false],
            ['Created', '14:32 · 8m ago', true],
            ['TTL', 'Pinned ∞', true],
          ].map(([k, v, mono]) => (
            <div key={k}>
              <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 9, letterSpacing: 1.2, textTransform: 'uppercase' }}>{k}</div>
              <div style={{ color: CG.text, fontFamily: mono ? CG.fontMono : CG.font, fontSize: 12, marginTop: 2, fontWeight: 500 }}>{v}</div>
            </div>
          ))}
        </div>

        {/* actions */}
        <div style={{ display: 'flex', gap: 6 }}>
          {[
            { id: 'edit',  i: 'edit',     l: 'Edit' },
            { id: 'pin',   i: 'pin',      l: 'Unpin' },
            { id: 'share', i: 'share',    l: 'Share' },
            { id: 'del',   i: 'trash',    l: 'Delete', danger: true },
          ].map(a => (
            <button key={a.id} style={{
              flex: 1, height: 56,
              background: a.danger ? CG.dangerSoft : CG.surface1,
              border: `1px solid ${a.danger ? 'rgba(239,68,68,0.35)' : CG.hudBorder}`,
              color: a.danger ? CG.danger : CG.text,
              borderRadius: 8, cursor: 'pointer',
              display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 3,
              fontSize: 11, fontWeight: 500,
            }}>
              {Ic[a.i]({ size: 18 })}
              {a.l}
            </button>
          ))}
        </div>
      </div>
    </Sheet>
  );
}

function LayerSheetWrap({ density }) {
  const groups = [
    {
      title: 'Base · Tile source', count: '1',
      layers: [
        { id: 'osm', name: 'OSM Topo · Cached', meta: 'Offline · 142 MB', icon: 'layers', visible: true, color: CG.surface2 },
      ],
    },
    {
      title: 'Overlays', count: density === 'busy' ? '3' : '1',
      layers: density === 'busy' ? [
        { id: 'kml', name: 'AOR_Sector_7B.kml', meta: 'Imported · 14 features', icon: 'flag', visible: true, draggable: true, canOpacity: true, opacity: 75, color: CG.warn },
        { id: 'gpx', name: 'Patrol_route.gpx', meta: 'Imported · 28 pts', icon: 'flag', visible: true, draggable: true, canOpacity: true, opacity: 100, color: CG.catResource },
        { id: 'kmz', name: 'Hazard_zones.kmz', meta: 'Imported · 6 features', icon: 'warning', visible: false, draggable: true, canOpacity: true, opacity: 50, color: CG.danger },
      ] : [
        { id: 'kml', name: 'AOR_Sector_7B.kml', meta: 'Imported · 14 features', icon: 'flag', visible: true, draggable: true, canOpacity: true, opacity: 100, color: CG.warn },
      ],
    },
    {
      title: 'Markers', count: density === 'busy' ? '16' : '4',
      layers: [
        { id: 'cot', name: 'CoT Markers', meta: density === 'busy' ? '4 visible · 2 stale' : '1 visible', icon: 'flag', visible: true, color: CG.catTeam },
        { id: 'cgm', name: 'Custom Markers', meta: density === 'busy' ? '12 visible · 1 stale' : '3 visible', icon: 'pin', visible: true, color: CG.catMedical },
      ],
    },
    {
      title: 'Plugin layers', count: density === 'busy' ? '2' : '1',
      layers: density === 'busy' ? [
        { id: 'el', name: 'Elevation · contours', meta: 'Plugin · 50m intervals', icon: 'layers', visible: true, draggable: true, canOpacity: true, opacity: 50, color: CG.catTeam },
        { id: 'fd', name: 'Sensor feeds', meta: 'Plugin · 3 sources', icon: 'plug', visible: true, draggable: true, canOpacity: true, opacity: 75, color: CG.catResource },
      ] : [
        { id: 'el', name: 'Elevation · contours', meta: 'Plugin · 50m intervals', icon: 'layers', visible: false, draggable: true, canOpacity: true, opacity: 50, color: CG.catTeam },
      ],
    },
  ];
  return (
    <Sheet
      height={560}
      title="Layers"
      action={
        <button style={{
          height: 36, padding: '0 12px', borderRadius: 8,
          background: CG.surface1, border: `1px solid ${CG.hudBorder}`,
          color: CG.text, fontSize: 12, fontWeight: 500, cursor: 'pointer',
          display: 'flex', alignItems: 'center', gap: 6,
        }}>{Ic.download({ size: 14 })} Cache area</button>
      }
    >
      {groups.map(g => (
        <LayerGroup key={g.title} title={g.title} count={g.count}>
          {g.layers.map(l => (
            <LayerRow key={l.id} layer={l} onToggle={()=>{}} onOpacity={()=>{}}/>
          ))}
        </LayerGroup>
      ))}
      <div style={{ height: 16 }}/>
    </Sheet>
  );
}

function SearchSheetWrap({ density, expanded }) {
  const results = [
    { id: 'r1', cat: 'medical', name: 'Aid Stn 1',  dist: '142 m',  src: 'Custom' },
    { id: 'r2', cat: 'medical', name: 'CCP',         dist: '380 m',  src: 'Custom' },
    { id: 'r3', cat: 'team',    name: 'Bravo-1',     dist: '88 m',   src: 'Custom' },
    { id: 'r4', cat: 'team',    name: 'Alpha-Lead',  dist: '210 m',  src: 'CoT' },
    { id: 'r5', cat: 'nav',     name: 'Rally Pt',    dist: '155 m',  src: 'Custom' },
    { id: 'r6', cat: 'hazard',  name: 'Slide zone',  dist: '420 m',  src: 'Custom' },
    { id: 'r7', cat: 'resource',name: 'Water cache', dist: '510 m',  src: 'Custom' },
  ];
  return (
    <Sheet
      height={expanded ? 620 : 460}
      title={expanded ? 'Search · Filters' : 'Search'}
    >
      <div style={{ padding: '4px 16px 12px' }}>
        {/* Search input */}
        <div style={{
          height: 48, borderRadius: 10,
          background: CG.surface1, border: `1px solid ${CG.hudBorder}`,
          display: 'flex', alignItems: 'center', padding: '0 12px', gap: 10,
        }}>
          <div style={{ color: CG.text3 }}>{Ic.search({ size: 18 })}</div>
          <input placeholder="Search markers, overlays, names…" defaultValue="bravo"
            style={{
              flex: 1, background: 'transparent', border: 'none', outline: 'none',
              color: CG.text, fontSize: 14, fontFamily: CG.font,
            }}/>
          <button aria-label="Filter" style={{
            width: 32, height: 32, borderRadius: 6,
            background: expanded ? CG.text : 'transparent',
            color: expanded ? CG.bg : CG.text2,
            border: `1px solid ${expanded ? CG.text : CG.hudBorder}`, cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>{Ic.filter({ size: 16 })}</button>
        </div>

        {/* Filters block */}
        {expanded && (
          <div style={{ marginTop: 14, display: 'flex', flexDirection: 'column', gap: 14 }}>
            {[
              { label: 'Category', opts: ['Medical', 'Hazard', 'Nav', 'Resource', 'Team', 'Infra'], on: ['Team', 'Nav'] },
              { label: 'Source',   opts: ['CoT', 'Custom', 'Plugin'], on: ['Custom'] },
              { label: 'Status',   opts: ['Active', 'Stale', 'Pinned'], on: ['Active'] },
            ].map(f => (
              <div key={f.label}>
                <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 9, letterSpacing: 1.4, textTransform: 'uppercase', marginBottom: 6 }}>{f.label}</div>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                  {f.opts.map(o => {
                    const on = f.on.includes(o);
                    return (
                      <div key={o} style={{
                        height: 32, padding: '0 12px',
                        background: on ? CG.text : 'transparent',
                        color: on ? CG.bg : CG.text2,
                        border: `1px solid ${on ? CG.text : CG.hudBorder}`,
                        borderRadius: 16, fontSize: 12, fontWeight: 500,
                        display: 'flex', alignItems: 'center', gap: 5,
                      }}>{on && Ic.check({ size: 12, stroke: 2.5 })}{o}</div>
                    );
                  })}
                </div>
              </div>
            ))}
            <div>
              <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 9, letterSpacing: 1.4, textTransform: 'uppercase', marginBottom: 6 }}>Proximity</div>
              <div style={{ display: 'flex', gap: 4 }}>
                {['1km', '5km', '10km', '25km', '50km'].map((s, i) => (
                  <div key={s} style={{
                    flex: 1, height: 36, borderRadius: 6,
                    background: i === 1 ? CG.text : 'transparent',
                    color: i === 1 ? CG.bg : CG.text2,
                    border: `1px solid ${i === 1 ? CG.text : CG.hudBorder}`,
                    fontFamily: CG.fontMono, fontSize: 11, fontWeight: 600,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                  }}>{s}</div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Results */}
        {!expanded && (
          <div style={{ marginTop: 14 }}>
            <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 9, letterSpacing: 1.4, textTransform: 'uppercase', marginBottom: 6 }}>
              {results.length} results · sorted by distance
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              {results.slice(0, 5).map(r => {
                const meta = CATS[r.cat];
                return (
                  <div key={r.id} style={{
                    display: 'flex', alignItems: 'center', gap: 10, minHeight: 56,
                    padding: '8px 12px',
                    background: CG.surface1, borderRadius: 8,
                    border: `1px solid ${CG.hudBorder}`,
                  }}>
                    <div style={{
                      width: 32, height: 32, borderRadius: '50%',
                      background: CG[meta.color], color: CG.bg,
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                    }}>{Ic[meta.icon]({ size: 16, stroke: 2.2 })}</div>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ color: CG.text, fontSize: 14, fontWeight: 500 }}>{r.name}</div>
                      <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 10, marginTop: 1 }}>
                        {r.dist} · {r.src}
                      </div>
                    </div>
                    <div style={{ color: CG.text3 }}>{Ic.chevRight({ size: 16 })}</div>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </Sheet>
  );
}

function DropSheetWrap() {
  const cats = Object.entries(CATS);
  return (
    <Sheet height={340} title="Drop marker">
      <div style={{ padding: '0 16px 12px' }}>
        {/* Coord readout */}
        <div style={{
          padding: '8px 12px', marginBottom: 14,
          background: CG.surface1, borderRadius: 8,
          border: `1px solid ${CG.hudBorder}`,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}>
          <div>
            <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 9, letterSpacing: 1.2, textTransform: 'uppercase' }}>At map center</div>
            <div style={{ color: CG.text, fontFamily: CG.fontMono, fontSize: 13, fontWeight: 600, marginTop: 1 }}>17T NK 8512 4287</div>
          </div>
          <div style={{
            display: 'inline-flex', alignItems: 'center', gap: 4,
            background: CG.warnSoft, color: CG.warn,
            fontFamily: CG.fontMono, fontSize: 9, fontWeight: 700, letterSpacing: 1,
            padding: '3px 7px', borderRadius: 3,
          }}>{Ic.crosshair({ size: 10 })} CTR</div>
        </div>

        {/* Category chips */}
        <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 9, letterSpacing: 1.4, textTransform: 'uppercase', marginBottom: 6 }}>Category</div>
        <div style={{
          display: 'flex', gap: 6, overflowX: 'auto',
          marginBottom: 14, paddingBottom: 4,
        }}>
          {cats.map(([k, v], i) => {
            const on = i === 2; // 'nav' selected
            return (
              <div key={k} style={{
                flexShrink: 0, height: 60, minWidth: 64,
                padding: '6px 10px',
                background: on ? CG[v.color] : CG.surface1,
                color: on ? CG.bg : CG.text2,
                border: `1px solid ${on ? CG[v.color] : CG.hudBorder}`,
                borderRadius: 8,
                display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 4,
                fontSize: 10, fontWeight: 600,
              }}>
                {Ic[v.icon]({ size: 18, stroke: 2 })}
                {v.label.split(' ')[0]}
              </div>
            );
          })}
        </div>

        {/* Name input */}
        <div style={{
          height: 44, borderRadius: 8,
          background: CG.surface1, border: `1px solid ${CG.hudBorder}`,
          display: 'flex', alignItems: 'center', padding: '0 12px',
        }}>
          <input placeholder="Marker name (optional)" defaultValue="WP-8"
            style={{
              flex: 1, background: 'transparent', border: 'none', outline: 'none',
              color: CG.text, fontSize: 14, fontFamily: CG.font,
            }}/>
        </div>

        {/* Drop button */}
        <button style={{
          width: '100%', height: 56, marginTop: 12,
          background: CG.text, color: CG.bg,
          border: 'none', borderRadius: 10,
          fontSize: 15, fontWeight: 700, letterSpacing: 0.3, cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          {Ic.pinPlus({ size: 20, stroke: 2.2 })}
          Drop marker
        </button>
      </div>
    </Sheet>
  );
}

Object.assign(window, { CGScreen });
