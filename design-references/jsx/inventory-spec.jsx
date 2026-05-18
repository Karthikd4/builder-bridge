// inventory-spec.jsx — Strategic spec doc sections for the inventory system.

// ─────────────────────────────────────────────────────────────
// Hero
// ─────────────────────────────────────────────────────────────
function InvHero({ t, builder }) {
  return (
    <section className="hero-grad" style={{
      paddingTop: 64, paddingBottom: 100,
      borderBottom: '1px solid var(--line)',
    }}>
      <Container>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 56 }}>
          <BBMark size={28} color="var(--accent)"/>
          <BBWordmark color="var(--ink)" size={18}/>
          <div style={{
            marginLeft: 'auto', display: 'flex', gap: 18,
            fontSize: 13, fontWeight: 500, color: 'var(--ink-mute)',
          }}>
            <a href="BuilderBridge - Buyer App.html" style={{ color: 'inherit', textDecoration: 'none' }}>
              Buyer prototype ›
            </a>
            <a href="BuilderBridge - Design Spec.html" style={{ color: 'inherit', textDecoration: 'none' }}>
              App design spec ›
            </a>
          </div>
        </div>

        <div className="mono" style={{
          fontSize: 12, fontWeight: 600, letterSpacing: 1,
          textTransform: 'uppercase', color: 'var(--accent)',
        }}>Inventory visualization system · v1.0</div>

        <h1 className="serif" style={{
          fontSize: 80, fontWeight: 400, color: 'var(--ink)',
          margin: '20px 0 0', letterSpacing: -2.2, lineHeight: 1.0,
          maxWidth: 980, textWrap: 'balance',
        }}>
          Eighty-eight flats,<br/>
          <span style={{ fontStyle: 'italic', color: 'var(--ink-mute)' }}>three ways to look at them.</span>
        </h1>

        <p style={{
          fontSize: 19, color: 'var(--ink-mute)', lineHeight: 1.55,
          maxWidth: 720, margin: '32px 0 0', textWrap: 'pretty',
        }}>
          The inventory grid is where sales teams and buyers actually meet — one needs
          to see availability at a glance and act on it, the other needs to imagine themselves
          living there. We give them both: <strong style={{ color: 'var(--ink)' }}>Tower</strong> for
          the bird's-eye, <strong style={{ color: 'var(--ink)' }}>Floor</strong> for the spatial sense,
          <strong style={{ color: 'var(--ink)' }}> Grid</strong> for the spreadsheet brain. Same data,
          same colors, same four statuses — different lenses.
        </p>

        {/* preview triptych */}
        <div style={{ marginTop: 56, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: 12 }}>
          {[
            { l: 'Tower elevation',  s: 'For the glance', view: 'tower' },
            { l: 'Floor plan',       s: 'For the picture', view: 'floor' },
            { l: 'Grid matrix',      s: 'For the scan', view: 'grid' },
          ].map((p, i) => (
            <div key={i} style={{
              padding: 16, borderRadius: 14, background: 'var(--surface)',
              border: '1px solid var(--line)', position: 'relative',
              overflow: 'hidden', minHeight: 200,
            }}>
              <div className="mono" style={{
                fontSize: 11, fontWeight: 700, letterSpacing: 0.5,
                color: 'var(--accent)', textTransform: 'uppercase',
              }}>{String(i + 1).padStart(2, '0')}</div>
              <h3 className="serif" style={{
                fontSize: 22, fontWeight: 500, margin: '6px 0 2px', letterSpacing: -0.4,
              }}>{p.l}</h3>
              <div style={{ fontSize: 13, color: 'var(--ink-mute)', marginBottom: 14 }}>{p.s}</div>
              <div style={{ height: 100, overflow: 'hidden', position: 'relative' }}>
                <MiniViewPreview t={t} view={p.view}/>
              </div>
            </div>
          ))}
        </div>
      </Container>
    </section>
  );
}

// Mini live preview of each view, used in the hero triptych
function MiniViewPreview({ t, view }) {
  if (view === 'tower') {
    return (
      <div style={{ transform: 'scale(0.55)', transformOrigin: 'top left', width: '180%' }}>
        <TowerView t={t} units={ALL_UNITS} selected={null} onSelect={() => {}} density="dense"/>
      </div>
    );
  }
  if (view === 'floor') {
    return (
      <div style={{ transform: 'scale(0.42)', transformOrigin: 'top left', width: '240%' }}>
        <FloorView t={t} units={ALL_UNITS} floor={15} onFloorChange={() => {}}
          selected={null} onSelect={() => {}} floorRange={[1, 22]}/>
      </div>
    );
  }
  return (
    <div style={{ transform: 'scale(0.5)', transformOrigin: 'top left', width: '200%' }}>
      <GridView t={t} units={ALL_UNITS} selected={null} onSelect={() => {}}/>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Section 1: The four statuses + color strategy
// ─────────────────────────────────────────────────────────────
function InvColorStrategy() {
  return (
    <SectionBlock divider
      kicker="01 · Color strategy"
      title="Four states. One color each."
      lede="Status colors carry the entire system. They never compete with brand, never shift with theme, never deputise for another meaning. A buyer who learns the palette in three seconds can read the entire 88-unit tower from across the room."
    >
      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: 16,
        marginBottom: 32,
      }}>
        {Object.keys(STATUS).map((k) => {
          const s = STATUS[k];
          return (
            <div key={k} style={{
              borderRadius: 16, overflow: 'hidden',
              border: '1px solid var(--line)', background: 'var(--surface)',
              display: 'flex', flexDirection: 'column',
            }}>
              {/* swatch */}
              <div style={{
                height: 80, backgroundColor: s.color, position: 'relative',
                display: 'flex', alignItems: 'flex-end',
                padding: '12px 16px',
              }}>
                <div style={{
                  position: 'absolute', top: 12, right: 12,
                  background: 'rgba(255,255,255,0.18)',
                  backdropFilter: 'blur(6px)',
                  borderRadius: 6, padding: '2px 6px',
                  fontSize: 10, fontWeight: 700, color: '#fff',
                  letterSpacing: 0.5, fontFeatureSettings: '"tnum"',
                }} className="mono">{s.color}</div>
                <span style={{
                  fontSize: 18, fontWeight: 700, color: '#fff',
                  letterSpacing: -0.2, textShadow: '0 1px 2px rgba(0,0,0,0.2)',
                }}>{s.label}</span>
              </div>
              <div style={{ padding: 16, fontSize: 13, color: 'var(--ink-mute)', lineHeight: 1.5, flex: 1 }}>
                {s.description}
              </div>
              <div style={{
                padding: '10px 16px', background: s.soft,
                fontSize: 11.5, color: 'var(--ink)', fontWeight: 600,
                borderTop: '1px solid var(--line)',
              }}>
                <span className="mono" style={{
                  fontSize: 10, color: s.color, fontWeight: 700,
                  letterSpacing: 0.5, textTransform: 'uppercase',
                }}>Velocity</span>
                <div style={{ marginTop: 2 }}>{s.velocity}</div>
              </div>
            </div>
          );
        })}
      </div>

      {/* selection overlay rule */}
      <div style={{
        padding: 24, borderRadius: 14,
        background: 'var(--accent-soft)',
        border: '1px solid var(--accent)',
        display: 'flex', gap: 24, alignItems: 'center', flexWrap: 'wrap',
      }}>
        <div style={{ display: 'flex', gap: 6 }}>
          {[STATUS.available, STATUS.reserved, STATUS.booked, STATUS.sold].map((s, i) => (
            <div key={i} style={{
              width: 32, height: 32, borderRadius: 4, background: s.color,
              border: i === 1 ? '3px solid var(--accent)' : '1px solid rgba(0,0,0,0.06)',
              boxShadow: i === 1 ? '0 0 0 2px var(--surface), 0 0 0 4px var(--accent)' : 'none',
            }}/>
          ))}
        </div>
        <div style={{ flex: 1, minWidth: 240 }}>
          <h3 className="serif" style={{
            fontSize: 22, fontWeight: 500, margin: 0, letterSpacing: -0.3, color: 'var(--ink)',
          }}>Selected state overrides status, never replaces it.</h3>
          <p style={{ fontSize: 14, color: 'var(--ink-mute)', margin: '6px 0 0', lineHeight: 1.5, textWrap: 'pretty' }}>
            When a unit is selected, the brand accent rings the cell — its status color stays
            the fill. This means a buyer always knows what they've clicked AND what's available
            without holding both ideas in their head at the same time.
          </p>
        </div>
      </div>

      {/* contrast notes */}
      <div style={{ marginTop: 24, display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: 14 }}>
        {[
          {
            title: 'Theme-agnostic',
            text: 'Status colors stay constant across light/dark. Only the surrounding surface changes — a 12-pixel "sold" cell reads the same in both modes.',
          },
          {
            title: 'WCAG AA on white & on dark',
            text: 'Each status color hits 4.5:1 contrast against the surface beneath it. Labels overlaid on the status (e.g. on a status pill) use white text — also AA.',
          },
          {
            title: 'Soft variant for fills',
            text: 'Tinted soft variants (e.g. #E0F0E5 for available) fill larger surfaces — unit detail headers, filter chip backgrounds. They never carry meaning alone; always paired with the saturated dot.',
          },
          {
            title: 'Color-blind safe enough',
            text: 'Green / amber / violet / gray separates clearly under deuteranopia and protanopia. Status pills include text labels, never relying on color alone.',
          },
        ].map((c, i) => (
          <div key={i} style={{
            padding: 18, borderRadius: 12,
            background: 'var(--surface)', border: '1px solid var(--line)',
          }}>
            <div style={{ fontSize: 13.5, fontWeight: 700, color: 'var(--ink)', letterSpacing: -0.1 }}>{c.title}</div>
            <div style={{ fontSize: 12.5, color: 'var(--ink-mute)', marginTop: 6, lineHeight: 1.5 }}>{c.text}</div>
          </div>
        ))}
      </div>
    </SectionBlock>
  );
}

// ─────────────────────────────────────────────────────────────
// Section 2: Three layout concepts (live demos)
// ─────────────────────────────────────────────────────────────
function InvLayouts({ t }) {
  return (
    <SectionBlock bg="var(--surface)"
      kicker="02 · Layout concepts"
      title="Three lenses. Same eighty-eight flats."
      lede="Each view answers a different question. Tower: 'how full is this building?' Floor: 'what's on the 15th?' Grid: 'show me everything 3BHK and east-facing.' All three live below — you can click any unit to see it switch."
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: 48 }}>
        <LayoutShowcase
          t={t} num="01" label="Tower elevation"
          tag="Best at the glance"
          desc="A vertical slice of the building. Each cell is a unit; colors are status. Floor numbers anchor the eye. Read top-down or bottom-up — the eye finds the pattern instantly. This is the default view on landing."
          sample={<TowerView t={t} units={ALL_UNITS} selected={null} onSelect={() => {}}/>}
          bullets={[
            'Fits 22 floors × 4 units in a column with no scroll.',
            'Hover/tap any cell to see unit ID + status without opening detail.',
            'A small dot in the top-right corner marks the buyer\'s own unit.',
            'Greys out non-matching units when filters are active; the building\'s shape stays legible.',
          ]}/>

        <LayoutShowcase
          t={t} num="02" label="Floor plan"
          tag="Best for picturing the unit"
          desc="A top-down view of one floor. Units are positioned around the central corridor and lifts. Compass shows north. The buyer can see which way they face and how the units relate. A floor slider walks them up the tower."
          sample={<FloorView t={t} units={ALL_UNITS} floor={15}
            onFloorChange={() => {}} selected={null} onSelect={() => {}} floorRange={[1, 22]}/>}
          bullets={[
            'Schematic, not CAD — communicates layout without claiming dimensions.',
            'Status color is the fill (soft) + stroke (saturated). A premium "pool view" gets a small accent dot.',
            'Tappable units carry the same selection ring as other views.',
            'Floor slider supports keyboard arrows + drag; clamps to the filtered floor range.',
          ]}/>

        <LayoutShowcase
          t={t} num="03" label="Grid matrix"
          tag="Best for scanning at scale"
          desc="A data-first table. Rows are floors (high to low), columns are unit positions with their type and facing in the header. Cells fill with status color and unit ID. Sales teams reach for this when they're scanning many units fast."
          sample={<GridView t={t} units={ALL_UNITS} selected={null} onSelect={() => {}}/>}
          bullets={[
            'Each cell is its own button — never relies on hover. Mobile-safe by construction.',
            'Headers carry meaning the cells don\'t need to repeat (e.g. "2BHK · E · Pool · Corner").',
            'Filters dim non-matching cells in place, preserving spatial relationships.',
            'Scrolls vertically; 22 floors × 4 columns fits ~10 floors per screen on mobile.',
          ]}/>
      </div>
    </SectionBlock>
  );
}

function LayoutShowcase({ t, num, label, tag, desc, sample, bullets }) {
  return (
    <div style={{
      display: 'grid', gridTemplateColumns: 'minmax(260px, 1fr) minmax(340px, 1.6fr)',
      gap: 28, alignItems: 'flex-start',
    }}>
      <div>
        <span className="mono" style={{
          fontSize: 11, fontWeight: 700, color: 'var(--accent)',
          background: 'var(--accent-soft)', padding: '3px 8px', borderRadius: 4,
        }}>{num}  {tag}</span>
        <h3 className="serif" style={{
          fontSize: 32, fontWeight: 500, color: 'var(--ink)',
          margin: '14px 0 10px', letterSpacing: -0.5, lineHeight: 1.1,
        }}>{label}</h3>
        <p style={{ fontSize: 14.5, color: 'var(--ink-mute)', lineHeight: 1.55, margin: 0, textWrap: 'pretty' }}>{desc}</p>
        <ul style={{
          margin: '18px 0 0', padding: '0 0 0 18px',
          fontSize: 13, color: 'var(--ink-mute)', lineHeight: 1.6,
        }}>
          {bullets.map((b, i) => <li key={i} style={{ marginBottom: 6 }}>{b}</li>)}
        </ul>
      </div>
      <div style={{
        padding: 20, background: 'var(--bg)', borderRadius: 16,
        border: '1px solid var(--line)',
      }}>
        {sample}
      </div>
    </div>
  );
}

Object.assign(window, {
  InvHero, MiniViewPreview, InvColorStrategy, InvLayouts, LayoutShowcase,
});
