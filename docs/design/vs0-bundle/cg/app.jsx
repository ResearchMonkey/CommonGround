// cg/app.jsx — Mounts everything onto a DesignCanvas.

const { useState } = React;

// Simple Android phone wrapper — strips down the starter to "screen only"
function Phone({ children }) {
  return (
    <div style={{
      width: CG_PHONE.w + 16,
      borderRadius: 36, padding: 8,
      background: '#0A0E13',
      border: '8px solid #1F242C',
      boxShadow: '0 30px 80px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.04) inset',
    }}>
      <div style={{
        width: CG_PHONE.w, height: CG_PHONE.h,
        borderRadius: 28, overflow: 'hidden',
        position: 'relative', background: '#000',
      }}>
        {/* Status bar (slim) */}
        <div style={{
          position: 'absolute', top: 0, left: 0, right: 0, height: 28, zIndex: 100,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          padding: '0 18px', pointerEvents: 'none',
          fontFamily: CG.fontMono, fontSize: 11, color: CG.text, fontWeight: 600,
        }}>
          <span>9:30</span>
          <div style={{
            position: 'absolute', left: '50%', top: 8, transform: 'translateX(-50%)',
            width: 14, height: 14, borderRadius: '50%', background: '#000',
            border: '2px solid #1F242C',
          }}/>
          <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
            <span style={{ fontSize: 10 }}>5G</span>
            <div style={{ width: 18, height: 9, border: `1px solid ${CG.text}`, borderRadius: 2, position: 'relative' }}>
              <div style={{ position: 'absolute', inset: 1, right: 'auto', width: 11, background: CG.text }}/>
            </div>
          </div>
        </div>
        {/* Push children below status bar */}
        <div style={{
          position: 'absolute', top: 28, left: 0, right: 0, bottom: 0,
          overflow: 'hidden',
        }}>
          {children}
        </div>
        {/* Gesture pill */}
        <div style={{
          position: 'absolute', bottom: 6, left: '50%', transform: 'translateX(-50%)',
          width: 100, height: 4, borderRadius: 2, background: 'rgba(255,255,255,0.4)',
          zIndex: 200,
        }}/>
      </div>
    </div>
  );
}

// Each screen — wrapped in Phone, with a label inside the artboard
function Slot({ id, label, w = CG_PHONE.w + 32, h = CG_PHONE.h + 32, children }) {
  return (
    <DCArtboard id={id} label={label} width={w} height={h}>
      <div style={{
        width: '100%', height: '100%',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        background: '#0a0a0a',
        borderRadius: 12,
      }}>
        {children}
      </div>
    </DCArtboard>
  );
}

function App() {
  return (
    <DesignCanvas>
      <DCSection id="overview" title="CommonGround · Bundle 1" subtitle="Main shell & map · Galaxy A52 class · Dark tactical">

        {/* DEFAULT FIELD-READY */}
        <DCArtboard id="s1" label="01 · Default · Field-ready" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="default" density="field" conn="online"/></Phone>
          </div>
        </DCArtboard>

        {/* DEFAULT BUSY-OPS */}
        <DCArtboard id="s2" label="02 · Default · Busy ops (15+ markers, mesh)" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="default" density="busy" conn="mesh"/></Phone>
          </div>
        </DCArtboard>
      </DCSection>

      <DCSection id="states" title="HUD states" subtitle="Tap-driven panels and overlays — half-sheets, popovers, slide-outs">

        <DCArtboard id="s3" label="03 · Layer Manager · half-sheet" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="layers" density="busy" conn="mesh"/></Phone>
          </div>
        </DCArtboard>

        <DCArtboard id="s4" label="04 · Marker detail · bottom card" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="markerDetail" density="field" conn="online" selectedId="m2"/></Phone>
          </div>
        </DCArtboard>

        <DCArtboard id="s5" label="05 · Search · default" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="search" density="busy" conn="mesh"/></Phone>
          </div>
        </DCArtboard>

        <DCArtboard id="s6" label="06 · Search · filters expanded" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="searchExpanded" density="busy" conn="mesh"/></Phone>
          </div>
        </DCArtboard>

        <DCArtboard id="s7" label="07 · Connection popover" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="connPopover" density="field" conn="mesh"/></Phone>
          </div>
        </DCArtboard>

        <DCArtboard id="s8" label="08 · Slide-out menu" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="menu" density="field" conn="online"/></Phone>
          </div>
        </DCArtboard>
      </DCSection>

      <DCSection id="dropflow" title="Drop marker · 3-tap flow" subtitle="Tap Drop → pick category → confirm">

        <DCArtboard id="d1" label="A · Tap 'Drop' · crosshair appears at center" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="dropStep1" density="field" conn="online"/></Phone>
          </div>
        </DCArtboard>

        <DCArtboard id="d2" label="B · Pick category & name → tap 'Drop marker'" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="dropStep2" density="field" conn="online"/></Phone>
          </div>
        </DCArtboard>

        <DCArtboard id="d3" label="C · Map tap · coord readout + 'Drop here'" width={CG_PHONE.w + 40} height={CG_PHONE.h + 40}>
          <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 4 }}>
            <Phone><CGScreen state="mapTap" density="field" conn="online"/></Phone>
          </div>
        </DCArtboard>
      </DCSection>

      <DCSection id="brand" title="Notes" subtitle="Visual system, hard constraints, and what's not in this bundle">
        <DCArtboard id="n1" label="Visual system" width={520} height={CG_PHONE.h + 40}>
          <div style={{ padding: 24, background: CG.surface0, color: CG.text, height: '100%', overflow: 'auto', fontFamily: CG.font }}>
            {/* Logo */}
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 22 }}>
              <div style={{
                width: 52, height: 52,
                background: CG.text, color: CG.bg,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: CG.fontMono, fontSize: 17, fontWeight: 700, letterSpacing: 0.5,
                clipPath: 'polygon(8% 0, 100% 0, 92% 100%, 0% 100%)',
              }}>CG</div>
              <div>
                <div style={{ fontSize: 18, fontWeight: 600 }}>CommonGround</div>
                <div style={{ color: CG.text3, fontFamily: CG.fontMono, fontSize: 11 }}>Bundle 1 · Main shell</div>
              </div>
            </div>

            <Section title="Palette">
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                {[
                  ['#0F1419', 'bg', 'Map / void'],
                  ['#11161C', 'surface0', 'Sheet base'],
                  ['#161C24', 'surface1', 'Cards'],
                  ['#E8EAED', 'text', 'Primary'],
                  ['#A7AFBA', 'text2', 'Secondary'],
                  ['#4ADE80', 'ok', 'Online'],
                  ['#FBBF24', 'warn', 'Mesh'],
                  ['#EF4444', 'danger', 'Offline'],
                ].map(([hex, name, use]) => (
                  <div key={name} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div style={{ width: 32, height: 32, borderRadius: 4, background: hex, border: `1px solid ${CG.hudBorder}` }}/>
                    <div>
                      <div style={{ fontFamily: CG.fontMono, fontSize: 10, color: CG.text }}>{hex}</div>
                      <div style={{ fontFamily: CG.fontMono, fontSize: 9, color: CG.text3 }}>{use}</div>
                    </div>
                  </div>
                ))}
              </div>
            </Section>

            <Section title="Type">
              <div style={{ fontSize: 22, fontWeight: 600, marginBottom: 4 }}>IBM Plex Sans</div>
              <div style={{ color: CG.text3, fontSize: 11, marginBottom: 10 }}>Labels, body, headlines</div>
              <div style={{ fontFamily: CG.fontMono, fontSize: 17, fontWeight: 500, marginBottom: 4 }}>IBM Plex Mono</div>
              <div style={{ color: CG.text3, fontSize: 11, fontFamily: CG.fontMono }}>17T NK 8521 4193 · COORDS · STATUS</div>
            </Section>

            <Section title="Hard constraints">
              <ul style={{ margin: 0, paddingLeft: 18, fontSize: 13, lineHeight: 1.8, color: CG.text2 }}>
                <li>Min tap target <code style={{ fontFamily: CG.fontMono }}>48×48 dp</code> — gloves on</li>
                <li>Contrast <code style={{ fontFamily: CG.fontMono }}>≥ 4.5:1</code> — direct sunlight</li>
                <li>No sliders — opacity stepped 25/50/75/100</li>
                <li>Map = max screen area, panels float over</li>
                <li>Transitions ≤ 200ms — field tool, not consumer</li>
              </ul>
            </Section>

            <Section title="Not in this bundle">
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 5 }}>
                {['GeoChat', 'Navigation', 'CASEVAC', 'Track history', 'Geofencing', 'Admin', 'Plugin settings', 'Onboarding'].map(t => (
                  <span key={t} style={{
                    padding: '4px 9px', borderRadius: 12,
                    background: CG.surface2, color: CG.text3,
                    fontSize: 11, fontFamily: CG.fontMono,
                  }}>{t}</span>
                ))}
              </div>
            </Section>
          </div>
        </DCArtboard>
      </DCSection>
    </DesignCanvas>
  );
}

function Section({ title, children }) {
  return (
    <div style={{ marginBottom: 22 }}>
      <div style={{
        color: CG.text3, fontFamily: CG.fontMono, fontSize: 10, fontWeight: 600,
        letterSpacing: 1.4, textTransform: 'uppercase', marginBottom: 10,
      }}>{title}</div>
      {children}
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App/>);
