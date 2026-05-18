// inventory-spec-3.jsx — Sections 05-06 of the inventory spec doc.

// ─────────────────────────────────────────────────────────────
// Section 5: Mobile adaptation — side by side
// ─────────────────────────────────────────────────────────────
function InvMobileAdaptation({ t, builder }) {
  return (
    <SectionBlock divider
      kicker="05 · Mobile adaptation"
      title="The desktop tool, made for the thumb."
      lede="Sales staff carry desktops; buyers carry phones. The same inventory needs to work in both. Below: how the three-column desktop layout folds down to a single-column mobile flow, with no feature loss for either audience."
    >
      <div style={{
        display: 'grid',
        gridTemplateColumns: '1.4fr 1fr',
        gap: 28, alignItems: 'flex-start',
      }}>
        {/* Desktop frame */}
        <div>
          <div className="mono" style={{
            fontSize: 11, fontWeight: 700, color: 'var(--accent)',
            letterSpacing: 0.5, textTransform: 'uppercase', marginBottom: 12,
          }}>Desktop · Sales / web admin</div>
          <div style={{
            background: '#2a2d34', borderRadius: 14, padding: '14px 14px 18px',
            boxShadow: '0 30px 60px rgba(0,0,0,0.15)',
          }}>
            {/* fake macOS chrome */}
            <div style={{ display: 'flex', gap: 6, paddingBottom: 12 }}>
              <span style={{ width: 11, height: 11, borderRadius: '50%', background: '#FF5F57' }}/>
              <span style={{ width: 11, height: 11, borderRadius: '50%', background: '#FEBC2E' }}/>
              <span style={{ width: 11, height: 11, borderRadius: '50%', background: '#28C840' }}/>
            </div>
            <div style={{
              background: t.bg, borderRadius: 8, overflow: 'hidden',
              minHeight: 520, padding: 12,
            }}>
              <DesktopFrame t={t} builder={builder}/>
            </div>
          </div>
          <ul style={{
            margin: '18px 0 0', padding: '0 0 0 18px',
            fontSize: 13, color: 'var(--ink-mute)', lineHeight: 1.6,
          }}>
            <li>Filters live in a persistent <strong style={{ color: 'var(--ink)' }}>260px sidebar</strong>. No collapsing — sales staff want them in muscle memory.</li>
            <li>The canvas adapts to fill remaining space. View switcher pinned top-right.</li>
            <li><strong style={{ color: 'var(--ink)' }}>Right rail</strong> shows unit detail, then shortlist or pipeline below it.</li>
            <li>Modal-less: nothing covers the canvas. Selection updates inline.</li>
          </ul>
        </div>

        {/* Mobile frame */}
        <div>
          <div className="mono" style={{
            fontSize: 11, fontWeight: 700, color: 'var(--accent)',
            letterSpacing: 0.5, textTransform: 'uppercase', marginBottom: 12,
          }}>Mobile · Buyer experience</div>
          <div style={{
            display: 'flex', justifyContent: 'center',
            background: '#2a2d34', borderRadius: 14, padding: 24,
            boxShadow: '0 30px 60px rgba(0,0,0,0.15)',
          }}>
            <div style={{
              width: 320, height: 580, background: t.bg, borderRadius: 22,
              overflow: 'hidden', position: 'relative',
              boxShadow: '0 4px 12px rgba(0,0,0,0.3)',
              border: '6px solid #111', boxSizing: 'content-box',
            }}>
              <MobileFrame t={t} builder={builder}/>
            </div>
          </div>
          <ul style={{
            margin: '18px 0 0', padding: '0 0 0 18px',
            fontSize: 13, color: 'var(--ink-mute)', lineHeight: 1.6,
          }}>
            <li>Status chips above the canvas — the headline filter is always one tap.</li>
            <li>Other filters live in a <strong style={{ color: 'var(--ink)' }}>bottom sheet</strong>. Tap "More filters" to open.</li>
            <li>Selecting a unit raises a <strong style={{ color: 'var(--ink)' }}>half-sheet</strong>. Swipe down or tap outside to dismiss.</li>
            <li>The three views stay the same. Tower is the default; floor-plan still works on a 320px viewport because we scale the SVG.</li>
          </ul>
        </div>
      </div>

      {/* Responsive behavior breakdown */}
      <div style={{ marginTop: 40 }}>
        <h3 className="serif" style={{
          fontSize: 24, fontWeight: 500, color: 'var(--ink)', letterSpacing: -0.3,
          margin: '0 0 16px',
        }}>What folds, what disappears</h3>
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: 12,
        }}>
          {[
            { d: 'Filter sidebar',  m: '→ Chip strip + bottom sheet', why: 'Persistent panels steal vertical canvas. Sheet keeps the same controls one tap away.' },
            { d: 'Unit detail rail', m: '→ Half-sheet',                 why: 'A right rail on 320px would crowd the canvas to nothing. Sheets are the mobile-native answer.' },
            { d: 'Three columns',   m: '→ One column, vertical stack', why: 'Header / canvas / sheet-on-top.' },
            { d: 'Shortlist tray',  m: '→ Inline below unit detail',    why: 'Buyer sees the running comparison alongside the unit they just tapped.' },
            { d: 'Hover affordances', m: '→ All taps',                  why: 'No hover on touch. We use long-press for sales bulk-select.' },
            { d: 'Bulk select',     m: '✕ removed',                     why: 'Sales staff using mobile don\'t bulk-edit; they\'re escorting a buyer.' },
          ].map((c, i) => (
            <div key={i} style={{
              padding: 16, borderRadius: 10,
              background: 'var(--surface)', border: '1px solid var(--line)',
            }}>
              <div style={{
                display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, color: 'var(--ink-mute)',
              }}>
                <span style={{ fontWeight: 600 }}>{c.d}</span>
              </div>
              <div style={{
                fontSize: 14, fontWeight: 700, color: 'var(--ink)', marginTop: 4, letterSpacing: -0.1,
              }}>{c.m}</div>
              <div style={{ fontSize: 11.5, color: 'var(--ink-faint)', marginTop: 6, lineHeight: 1.5 }}>
                {c.why}
              </div>
            </div>
          ))}
        </div>
      </div>
    </SectionBlock>
  );
}

// A pre-cooked desktop layout snapshot — non-interactive in the spec, but visually accurate.
function DesktopFrame({ t, builder }) {
  return (
    <div style={{
      display: 'grid', gridTemplateColumns: '180px 1fr 200px',
      gap: 0, height: '100%', background: t.surface,
      borderRadius: 4, border: `1px solid ${t.line}`, overflow: 'hidden',
      fontSize: 10,
    }}>
      <div style={{ padding: 10, borderRight: `1px solid ${t.line}`, fontSize: 10 }}>
        <div style={{ fontWeight: 700, color: t.ink, marginBottom: 8 }}>Filters</div>
        {['Status', 'Facing', 'Type', 'Floor'].map((g) => (
          <div key={g} style={{ marginBottom: 10 }}>
            <div style={{ fontSize: 8.5, fontWeight: 600, color: t.inkFaint, textTransform: 'uppercase', letterSpacing: 0.5 }}>{g}</div>
            <div style={{ display: 'flex', gap: 3, marginTop: 4, flexWrap: 'wrap' }}>
              {Array.from({ length: g === 'Status' ? 4 : g === 'Floor' ? 0 : 3 }, (_, i) => (
                <span key={i} style={{
                  background: i === 0 ? t.accentSoft : t.surfaceMute,
                  color: i === 0 ? t.accent : t.inkMute,
                  padding: '2px 6px', borderRadius: 4, fontSize: 8.5, fontWeight: 600,
                  border: i === 0 ? `1px solid ${t.accent}` : 'none',
                }}>—</span>
              ))}
              {g === 'Floor' && <div style={{ width: '100%', height: 4, background: t.surfaceMute, borderRadius: 2, marginTop: 4 }}>
                <div style={{ width: '50%', height: '100%', background: t.accent, borderRadius: 2, marginLeft: '20%' }}/>
              </div>}
            </div>
          </div>
        ))}
      </div>
      <div style={{ padding: 10, overflow: 'hidden' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
          <span style={{ fontSize: 9, fontWeight: 700, color: t.ink }}>Block A · 88 units</span>
          <div style={{ display: 'flex', gap: 3 }}>
            {['Tower', 'Floor', 'Grid'].map((v, i) => (
              <span key={v} style={{
                fontSize: 8, padding: '2px 6px', borderRadius: 3,
                background: i === 0 ? t.surface : 'transparent',
                color: i === 0 ? t.ink : t.inkMute, fontWeight: 600,
                boxShadow: i === 0 ? '0 1px 2px rgba(0,0,0,0.08)' : 'none',
              }}>{v}</span>
            ))}
          </div>
        </div>
        <div style={{ transform: 'scale(0.85)', transformOrigin: 'top center' }}>
          <TowerView t={t} units={ALL_UNITS} selected={ALL_UNITS.find(u => u.id === 'A-1502')}
            onSelect={() => {}} density="dense"/>
        </div>
      </div>
      <div style={{ padding: 10, borderLeft: `1px solid ${t.line}`, fontSize: 9 }}>
        <div style={{
          background: STATUS.booked.soft, padding: 6, borderRadius: 4, color: STATUS.booked.color,
          fontWeight: 700, fontSize: 8.5, marginBottom: 6,
        }}>A-1502 · Booked</div>
        <div style={{ color: t.ink, fontWeight: 700 }}>3 BHK · 2,140 sqft</div>
        <div style={{ color: t.inkMute, marginTop: 2 }}>East · Pool view</div>
        <div style={{ marginTop: 8, padding: 6, background: t.surfaceMute, borderRadius: 4 }}>
          <div style={{ color: t.inkFaint, fontSize: 7.5, fontWeight: 600 }}>PRICE</div>
          <div style={{ color: t.ink, fontWeight: 700, fontSize: 10 }}>₹2.18 Cr</div>
        </div>
        <div style={{ marginTop: 8, color: t.inkFaint, fontSize: 7.5, fontWeight: 600 }}>PIPELINE</div>
        <div style={{ marginTop: 2, color: t.inkMute }}>3 leads · 2h ago</div>
      </div>
    </div>
  );
}

// Mobile frame snapshot — vertical stack
function MobileFrame({ t, builder }) {
  return (
    <div style={{
      width: '100%', height: '100%', background: t.bg, color: t.ink,
      display: 'flex', flexDirection: 'column',
      fontSize: 10,
    }}>
      {/* status bar */}
      <div style={{
        padding: '8px 16px 6px', display: 'flex', justifyContent: 'space-between',
        fontSize: 9, fontWeight: 600, color: t.ink,
      }}>
        <span>9:41</span>
        <span>● ● ● ●</span>
      </div>
      {/* header */}
      <div style={{
        padding: '6px 14px 10px', borderBottom: `1px solid ${t.line}`,
        background: t.surface,
      }}>
        <div style={{ fontSize: 8.5, fontWeight: 700, color: t.inkFaint, textTransform: 'uppercase', letterSpacing: 0.4 }}>
          Pavilion Heights
        </div>
        <div style={{ fontSize: 13, fontWeight: 700, color: t.ink, marginTop: 1 }}>
          Inventory · 88
        </div>
        <div style={{ display: 'flex', gap: 4, marginTop: 8, overflowX: 'auto' }}>
          {Object.keys(STATUS).map((k) => {
            const s = STATUS[k];
            return (
              <span key={k} style={{
                display: 'inline-flex', alignItems: 'center', gap: 3,
                padding: '3px 7px', borderRadius: 99,
                background: s.soft, color: s.color, fontSize: 8.5, fontWeight: 600,
              }}>
                <span style={{ width: 5, height: 5, borderRadius: '50%', background: s.color }}/>
                {s.label}
              </span>
            );
          })}
        </div>
      </div>
      {/* canvas */}
      <div style={{ flex: 1, padding: '10px 14px', overflow: 'hidden' }}>
        <TowerView t={t} units={ALL_UNITS} selected={ALL_UNITS.find(u => u.id === 'A-1502')}
          onSelect={() => {}} density="comfortable"/>
      </div>
      {/* half sheet at bottom */}
      <div style={{
        background: t.surface, borderRadius: '14px 14px 0 0', padding: '8px 12px 14px',
        boxShadow: '0 -8px 20px rgba(0,0,0,0.12)',
      }}>
        <div style={{
          width: 32, height: 3, background: t.lineStrong, borderRadius: 99,
          margin: '0 auto 6px',
        }}/>
        <div style={{
          background: STATUS.booked.color, borderRadius: 6, padding: 6, color: '#fff',
          marginBottom: 6,
        }}>
          <div style={{ fontSize: 7.5, fontWeight: 700, letterSpacing: 0.5 }}>BOOKED · YOUR BOOKING</div>
          <div style={{ fontSize: 14, fontWeight: 700 }}>A-1502</div>
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 8.5, color: t.inkMute }}>
          <span>3 BHK · 2,140 sqft</span>
          <span style={{ fontWeight: 700, color: t.ink }}>₹2.18 Cr</span>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Section 6: Live full system
// ─────────────────────────────────────────────────────────────
function InvLiveSystem({ t }) {
  const [mode, setMode] = React.useState('buyer');
  return (
    <SectionBlock bg="var(--surface)"
      kicker="06 · The complete system"
      title="Live. Click anything."
      lede="Everything above, working. Toggle between buyer and sales modes. Switch views. Compose filters. Tap a unit. The same data, the same colors, the same interactions you'd ship."
    >
      <InventoryExplorer t={t} mode={mode} setMode={setMode} layout="desktop"/>
      <div style={{
        marginTop: 14, fontSize: 12.5, color: 'var(--ink-mute)', textAlign: 'center',
        fontStyle: 'italic',
      }}>
        Demo data — 88 units across 22 floors of "Block A · Pavilion Heights".
      </div>
    </SectionBlock>
  );
}

// ─────────────────────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────────────────────
function InvFooter() {
  return (
    <footer style={{
      padding: '56px 0 56px', borderTop: '1px solid var(--line)',
      background: 'var(--bg)',
    }}>
      <Container>
        <div style={{
          display: 'flex', justifyContent: 'space-between', gap: 24, flexWrap: 'wrap',
          marginBottom: 24,
        }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12, maxWidth: 360 }}>
            <BBLockup size={16}/>
            <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', margin: 0, lineHeight: 1.5 }}>
              The inventory module is one part of Phase 1. The same system serves the buyer mobile app
              and the builder web admin portal — different chrome, identical canvas.
            </p>
          </div>
          <div style={{ display: 'flex', gap: 36 }}>
            <FooterCol title="Related artefacts" links={[
              { l: 'Buyer prototype', href: 'BuilderBridge - Buyer App.html' },
              { l: 'All screens canvas', href: 'BuilderBridge - All Screens.html' },
              { l: 'Buyer app design spec', href: 'BuilderBridge - Design Spec.html' },
            ]}/>
          </div>
        </div>
        <div style={{
          paddingTop: 22, borderTop: '1px solid var(--line)',
          fontSize: 12, color: 'var(--ink-faint)',
          display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap',
        }}>
          <span>Inventory system spec · v1.0 · May 2026</span>
          <span className="mono">Confidential · For internal review</span>
        </div>
      </Container>
    </footer>
  );
}

Object.assign(window, {
  InvMobileAdaptation, DesktopFrame, MobileFrame, InvLiveSystem, InvFooter,
});
