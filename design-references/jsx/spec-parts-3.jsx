// spec-parts-3.jsx — Sections 05-09 of the BuilderBridge design spec.

// ─────────────────────────────────────────────────────────────
// 05 · Navigation structure
// ─────────────────────────────────────────────────────────────
function SpecNavStructure() {
  return (
    <SectionBlock divider
      kicker="05 · Navigation structure"
      title="Four navigation patterns. Each does one job."
      lede="React Native's navigation can absorb every pattern from drawer to nested stack. We pick four — bottom tabs, push overlays, modals, sheets — and use each for exactly one role."
    >
      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: 18,
      }}>
        {[
          {
            n: '01', title: 'Bottom tab bar',
            sub: 'Always visible. Anchors the entire post-auth experience.',
            use: 'Home · Payments · Documents · Updates · Profile.',
            rules: ['Always 5 tabs', 'No badge clutter — one dot for unread', 'Active tab = brand accent', 'Tap-target ≥ 44pt'],
            color: 'var(--accent)',
            sample: <NavSample kind="tabs"/>,
          },
          {
            n: '02', title: 'Push overlays',
            sub: 'Detail screens reached from a card or row. Back arrow goes back.',
            use: 'Unit detail · Cost estimate · AOS · Receipts · Loan · Tickets · Inventory.',
            rules: ['Always have explicit back button', 'Title + subtitle in top bar', 'Bottom tab bar hides while overlay is up', 'Animation: right-to-left slide'],
            color: 'var(--warn)',
            sample: <NavSample kind="overlay"/>,
          },
          {
            n: '03', title: 'Action sheets',
            sub: 'Confirm / sign / pay flows. Slide up from bottom, dismissable.',
            use: 'AOS signing handoff · Payment confirmation · Filter pickers.',
            rules: ['Tap-outside to dismiss', 'Two CTAs max — primary + ghost cancel', 'Grab handle at top', 'Never nest deeper than one sheet'],
            color: '#7A5AE0',
            sample: <NavSample kind="sheet"/>,
          },
          {
            n: '04', title: 'Inline expands',
            sub: 'For content within a screen — chips, filters, sections.',
            use: 'Document categories · Estimate version chips · Ticket filters.',
            rules: ['Stay in scroll context', 'No nav transition', 'Lightweight — for picking, not deciding'],
            color: 'var(--ok)',
            sample: <NavSample kind="inline"/>,
          },
        ].map((p) => (
          <div key={p.n} style={{
            background: 'var(--surface)', borderRadius: 16,
            border: '1px solid var(--line)', overflow: 'hidden',
          }}>
            <div style={{
              padding: 24, display: 'flex', flexDirection: 'column', gap: 12,
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <span className="mono" style={{
                  fontSize: 12, fontWeight: 700, letterSpacing: 0.5, color: p.color,
                }}>{p.n}</span>
                <h3 className="serif" style={{
                  fontSize: 22, fontWeight: 500, margin: 0, color: 'var(--ink)', letterSpacing: -0.3,
                }}>{p.title}</h3>
              </div>
              <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', margin: 0, lineHeight: 1.5 }}>{p.sub}</p>
              <div style={{
                fontSize: 12.5, color: 'var(--ink)', fontWeight: 600,
                padding: '8px 12px', background: 'var(--surface-mute)', borderRadius: 8,
                lineHeight: 1.4,
              }}>{p.use}</div>
              <ul style={{ margin: '4px 0 0', padding: '0 0 0 16px', fontSize: 12.5, color: 'var(--ink-mute)', lineHeight: 1.6 }}>
                {p.rules.map((r, i) => <li key={i}>{r}</li>)}
              </ul>
            </div>
            <div style={{
              borderTop: '1px solid var(--line)',
              background: 'var(--bg)', padding: 20,
              display: 'flex', justifyContent: 'center',
            }}>
              {p.sample}
            </div>
          </div>
        ))}
      </div>
    </SectionBlock>
  );
}

function NavSample({ kind }) {
  const W = 200, H = 140;
  if (kind === 'tabs') {
    return (
      <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`}>
        <rect x="20" y="10" width={W - 40} height="100" rx="8" fill="#fff" stroke="var(--line)"/>
        <rect x="20" y="110" width={W - 40} height="22" rx="0" fill="#fff" stroke="var(--line)"/>
        {Array.from({ length: 5 }, (_, i) => {
          const x = 28 + i * ((W - 56) / 5);
          const w = (W - 56) / 5 - 4;
          const active = i === 0;
          return (
            <g key={i}>
              <circle cx={x + w / 2} cy={119} r="3" fill={active ? 'var(--accent)' : 'var(--ink-faint)'}/>
              <rect x={x} y={125} width={w} height="3" rx="1" fill={active ? 'var(--accent)' : 'var(--ink-faint)'}/>
            </g>
          );
        })}
      </svg>
    );
  }
  if (kind === 'overlay') {
    return (
      <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`}>
        <rect x="10" y="10" width={W - 20} height="120" rx="8" fill="#fff" stroke="var(--line)"/>
        <rect x="60" y="10" width={W - 70} height="120" rx="0 8 8 0" fill="var(--surface-mute)" stroke="var(--line)"/>
        <path d="M70 20l-6 6 6 6" stroke="var(--warn)" strokeWidth="1.6" fill="none"
              strokeLinecap="round" strokeLinejoin="round"/>
        <rect x="84" y="22" width="60" height="8" rx="2" fill="var(--ink)"/>
        <rect x="84" y="34" width="40" height="5" rx="2" fill="var(--ink-faint)"/>
      </svg>
    );
  }
  if (kind === 'sheet') {
    return (
      <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`}>
        <rect x="20" y="10" width={W - 40} height="120" rx="8" fill="#fff" stroke="var(--line)"/>
        <rect x="0" y="0" width={W} height={H} fill="#000" opacity="0.18"/>
        <rect x="10" y="70" width={W - 20} height="60" rx="14" fill="#fff" stroke="var(--line)"/>
        <rect x={W/2 - 14} y="78" width="28" height="3" rx="1.5" fill="var(--line-strong)"/>
        <rect x="20" y="92" width="60" height="6" rx="2" fill="var(--ink)"/>
        <rect x="20" y="110" width={W - 40} height="14" rx="4" fill="#7A5AE0"/>
      </svg>
    );
  }
  // inline
  return (
    <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`}>
      <rect x="20" y="10" width={W - 40} height="120" rx="8" fill="#fff" stroke="var(--line)"/>
      <g>
        {['All','Plans','Receipts','AOS'].map((l, i) => (
          <g key={i}>
            <rect x={28 + i * 38} y="24" width="34" height="18" rx="9"
                  fill={i === 1 ? 'var(--ok)' : 'var(--surface-mute)'}
                  stroke={i === 1 ? 'var(--ok)' : 'var(--line)'}/>
          </g>
        ))}
      </g>
      <rect x="28" y="56" width={W - 56} height="14" rx="3" fill="var(--surface-mute)"/>
      <rect x="28" y="76" width={W - 56} height="14" rx="3" fill="var(--surface-mute)"/>
      <rect x="28" y="96" width={W - 56} height="14" rx="3" fill="var(--surface-mute)"/>
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// 06 · Wireframes — low-fi sketches of each screen
// ─────────────────────────────────────────────────────────────
const WIRES = [
  { id: 'home', name: 'Home dashboard', tag: 'Home tab', desc: 'Greeting · flat hero · journey · next-up · quick links · activity.' },
  { id: 'unit', name: 'Unit detail',    tag: 'Push',     desc: 'Floor plan · spec table · amenities · downloadable plans.' },
  { id: 'estimate', name: 'Cost estimate', tag: 'Push',  desc: 'Version chips · itemised line items · agreed total · share.' },
  { id: 'inv',  name: 'Inventory grid', tag: 'Push',     desc: 'Tower elevation · colour-coded units · selected detail.' },
  { id: 'pay',  name: 'Payments',       tag: 'Tab',      desc: 'Payment ring · next-due banner · milestone list.' },
  { id: 'rec',  name: 'Receipts',       tag: 'Push',     desc: 'Searchable · downloadable · status pill per receipt.' },
  { id: 'loan', name: 'Loan tracker',   tag: 'Push',     desc: 'Status timeline · docs checklist · affiliated banks.' },
  { id: 'aos',  name: 'AOS review',     tag: 'Push',     desc: 'Progress track · PDF preview · clause comments · sign CTA.' },
  { id: 'docs', name: 'Documents vault', tag: 'Tab',     desc: 'Category chips · file list with type, size, date.' },
  { id: 'upd',  name: 'Updates',        tag: 'Tab',      desc: 'Grouped by day · icon + tone per kind · unread dot.' },
  { id: 'tkt',  name: 'Support tickets', tag: 'Push',    desc: 'Filter chips · SLA badge · status pill · + new ticket.' },
  { id: 'prof', name: 'Profile',        tag: 'Tab',      desc: 'Buyer card · sales rep card · property facts · settings.' },
];

function SpecWireframes() {
  return (
    <SectionBlock bg="var(--surface)"
      kicker="06 · Wireframe recommendations"
      title="Twelve screens at low fidelity."
      lede="Before the hi-fi pixel work, here's the structural skeleton. Each frame names its anchors — what must be on screen, in what order. Anything not shown here is decoration."
    >
      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(220px, 1fr))', gap: 14,
      }}>
        {WIRES.map((w) => (
          <div key={w.id} style={{
            border: '1px solid var(--line)', borderRadius: 14, overflow: 'hidden',
            background: 'var(--bg)',
          }}>
            <div style={{
              background: '#fff', borderBottom: '1px solid var(--line)',
              padding: 14, display: 'flex', justifyContent: 'center',
            }}>
              <Wire id={w.id}/>
            </div>
            <div style={{ padding: '12px 14px' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                <span className="mono" style={{
                  fontSize: 9.5, fontWeight: 700, letterSpacing: 0.5, textTransform: 'uppercase',
                  color: 'var(--ink-faint)', padding: '2px 6px', borderRadius: 4,
                  background: 'var(--surface-mute)',
                }}>{w.tag}</span>
              </div>
              <div style={{ fontSize: 13.5, fontWeight: 700, color: 'var(--ink)', letterSpacing: -0.1 }}>{w.name}</div>
              <div style={{ fontSize: 12, color: 'var(--ink-mute)', marginTop: 4, lineHeight: 1.4 }}>{w.desc}</div>
            </div>
          </div>
        ))}
      </div>
    </SectionBlock>
  );
}

// Hand-drawn-feeling wireframe SVGs — boxes, lines, labels.
function Wire({ id }) {
  const W = 180, H = 280;
  const ink = 'var(--ink)';
  const sub = 'var(--line-strong)';
  const accent = 'var(--accent)';
  const fill = 'var(--surface-mute)';
  const box = (x, y, w, h, opts = {}) => (
    <rect key={opts.k || `b-${x}-${y}-${w}-${h}`} x={x} y={y} width={w} height={h} rx={opts.r ?? 3}
          fill={opts.fill || 'none'} stroke={opts.stroke || sub}
          strokeWidth={opts.sw || 1.2}
          strokeDasharray={opts.dash}/>
  );
  const line = (x, y, w, h = 4) => (
    <rect key={`l-${x}-${y}-${w}-${h}`} x={x} y={y} width={w} height={h} rx={h / 2} fill={fill}/>
  );
  const head = (
    <>
      {box(8, 8, 164, 22, { r: 5 })}
      <circle cx="20" cy="19" r="6" fill={accent} opacity="0.8"/>
      {line(32, 14, 60, 4)}
      {line(32, 22, 38, 3)}
    </>
  );
  const tabs = (
    <>
      {box(8, 250, 164, 22, { r: 5 })}
      {Array.from({ length: 5 }, (_, i) => (
        <circle key={i} cx={26 + i * 32} cy="261" r="2.5"
                fill={i === 0 ? accent : sub}/>
      ))}
    </>
  );
  const wireframes = {
    home: (
      <>
        {head}
        {/* hero card */}
        {box(8, 38, 164, 70, { r: 6, fill: 'var(--accent-soft)', stroke: accent })}
        {line(16, 48, 70, 4)}
        {line(16, 58, 100, 8)}
        {line(16, 76, 80, 4)}
        {/* journey timeline */}
        {box(8, 116, 164, 36, { r: 6, fill, stroke: sub })}
        {Array.from({ length: 5 }, (_, i) => (
          <circle key={i} cx={28 + i * 30} cy="130" r="4"
                  fill={i < 3 ? accent : 'none'} stroke={accent} strokeWidth="1.2"/>
        ))}
        <line x1="32" y1="130" x2="148" y2="130" stroke={accent} strokeWidth="1" opacity="0.4"/>
        {/* next up */}
        {box(8, 160, 164, 42, { r: 6, stroke: accent, sw: 1.5 })}
        {line(16, 168, 50, 4)}
        {line(16, 178, 100, 7)}
        {box(8, 196, 164, 12, { r: 0, fill: accent, stroke: accent })}
        {/* quick links */}
        {box(8, 216, 78, 26, { r: 5 })}
        {box(94, 216, 78, 26, { r: 5 })}
        {tabs}
      </>
    ),
    unit: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 110, 10)}
        {box(8, 70, 164, 80, { r: 6, fill, stroke: sub })}
        <g stroke={ink} strokeWidth="1" fill="none">
          <rect x="20" y="80" width="60" height="40"/>
          <rect x="80" y="80" width="80" height="20"/>
          <rect x="80" y="100" width="80" height="20"/>
          <rect x="20" y="120" width="140" height="22" fill="var(--accent-soft)" stroke={accent}/>
        </g>
        {box(8, 160, 164, 50, { r: 6 })}
        {Array.from({ length: 4 }, (_, i) => line(16, 170 + i * 8, 140 - i * 10, 3))}
        {box(8, 218, 78, 22, { r: 5 })}
        {box(94, 218, 78, 22, { r: 5 })}
        {tabs}
      </>
    ),
    estimate: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 100, 9)}
        {/* version chips */}
        {[0, 1, 2].map((i) => box(8 + i * 50, 70, 46, 16, { r: 8, fill: i === 2 ? 'var(--accent-soft)' : 'transparent', stroke: i === 2 ? accent : sub }))}
        {/* line items */}
        {Array.from({ length: 7 }, (_, i) => (
          <g key={i}>
            {line(8, 100 + i * 14, 110, 4)}
            {line(140, 100 + i * 14, 32, 4)}
          </g>
        ))}
        {/* total */}
        {box(8, 200, 164, 26, { r: 6, fill: 'var(--surface-sunk)', stroke: sub })}
        {line(16, 212, 50, 5)}
        {line(110, 208, 56, 8)}
        {tabs}
      </>
    ),
    inv: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 90, 9)}
        {/* legend */}
        {[0, 1, 2, 3].map((i) => <circle key={i} cx={14 + i * 26} cy="73" r="3" fill={['var(--ok)','var(--warn)','var(--ink-faint)',accent][i]}/>)}
        {/* tower grid */}
        {box(8, 84, 164, 130, { r: 6, fill, stroke: sub })}
        {Array.from({ length: 11 }, (_, r) => (
          <g key={r}>
            {Array.from({ length: 4 }, (_, c) => {
              const fillC = (r === 4 && c === 1) ? accent
                : (r % 3 === 0 && c % 2 === 0) ? 'var(--ok)'
                : (r % 4 === 0) ? 'var(--warn)'
                : 'var(--ink-faint)';
              return <rect key={c} x={18 + c * 38} y={92 + r * 11} width="32" height="8" rx="1.5" fill={fillC} opacity="0.7"/>;
            })}
          </g>
        ))}
        {box(8, 222, 164, 22, { r: 5 })}
        {tabs}
      </>
    ),
    pay: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 100, 9)}
        {/* ring */}
        <circle cx="90" cy="120" r="42" fill="none" stroke="var(--surface-sunk)" strokeWidth="9"/>
        <circle cx="90" cy="120" r="42" fill="none" stroke={accent} strokeWidth="9"
                strokeDasharray={`${2 * Math.PI * 42 * 0.22} ${2 * Math.PI * 42}`}
                transform="rotate(-90 90 120)"/>
        {line(78, 116, 24, 4)}
        {line(70, 124, 40, 7)}
        {/* next due banner */}
        {box(8, 180, 164, 24, { r: 6, fill: 'var(--warn)', stroke: 'var(--warn)' })}
        {/* milestones */}
        {Array.from({ length: 4 }, (_, i) => (
          <g key={i}>
            <circle cx="20" cy={218 + i * 8} r="3" fill={i < 2 ? 'var(--ok)' : 'none'} stroke="var(--ok)" strokeWidth="1"/>
            {line(30, 216 + i * 8, 110, 4)}
          </g>
        ))}
        {tabs}
      </>
    ),
    rec: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 100, 9)}
        {box(8, 70, 164, 22, { r: 6 })}
        <circle cx="20" cy="81" r="4" fill="none" stroke={sub} strokeWidth="1.2"/>
        {line(30, 79, 60, 4)}
        {Array.from({ length: 4 }, (_, i) => (
          <g key={i}>
            {box(8, 102 + i * 30, 164, 26, { r: 6 })}
            <rect x="16" y={110 + i * 30} width="14" height="14" rx="3" fill="var(--ok)" opacity="0.2"/>
            {line(36, 108 + i * 30, 70, 4)}
            {line(36, 116 + i * 30, 50, 3)}
            {line(140, 110 + i * 30, 28, 5)}
          </g>
        ))}
        {tabs}
      </>
    ),
    loan: (
      <>
        {head}
        {line(8, 40, 60, 6)}
        {line(8, 52, 80, 9)}
        {line(8, 65, 100, 4)}
        {/* status */}
        {box(8, 78, 164, 70, { r: 6 })}
        {Array.from({ length: 4 }, (_, i) => (
          <g key={i}>
            <circle cx="20" cy={92 + i * 14} r="4" fill={i < 3 ? accent : 'none'} stroke={accent} strokeWidth="1.2"/>
            {i < 3 && <line x1="20" y1={96 + i * 14} x2="20" y2={102 + i * 14} stroke={accent} strokeWidth="1.2"/>}
            {line(32, 89 + i * 14, 70, 5)}
          </g>
        ))}
        {/* docs */}
        {box(8, 156, 164, 60, { r: 6 })}
        {Array.from({ length: 4 }, (_, i) => (
          <g key={i}>
            <rect x="16" y={166 + i * 12} width="8" height="8" rx="2" fill={i < 3 ? 'var(--ok)' : 'none'} stroke={i < 3 ? 'var(--ok)' : sub}/>
            {line(30, 168 + i * 12, 80, 4)}
          </g>
        ))}
        {tabs}
      </>
    ),
    aos: (
      <>
        {head}
        {line(8, 40, 60, 6)}
        {line(8, 52, 80, 9)}
        {/* status timeline */}
        {box(8, 70, 164, 40, { r: 6 })}
        {Array.from({ length: 5 }, (_, i) => (
          <circle key={i} cx={20 + i * 32} cy="84" r="3.5"
                  fill={i < 3 ? accent : 'none'} stroke={accent} strokeWidth="1"/>
        ))}
        <line x1="22" y1="84" x2="148" y2="84" stroke={accent} strokeWidth="1" opacity="0.5"/>
        {/* doc preview */}
        {box(8, 116, 164, 96, { r: 6, fill, stroke: sub })}
        <rect x="20" y="124" width={140} height="80" fill="#fff" stroke={sub}/>
        {Array.from({ length: 6 }, (_, i) => line(28, 130 + i * 8, [120, 110, 80, 105, 92, 96][i], 3))}
        {/* CTAs */}
        {box(8, 220, 78, 24, { r: 5 })}
        {box(94, 220, 78, 24, { r: 5, fill: accent, stroke: accent })}
        {tabs}
      </>
    ),
    docs: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 100, 9)}
        {/* chips */}
        {['All','Agree','Plans','Rec'].map((l, i) => box(8 + i * 42, 70, 38, 16, { r: 9, fill: i === 0 ? accent : 'transparent', stroke: i === 0 ? accent : sub }))}
        {Array.from({ length: 6 }, (_, i) => (
          <g key={i}>
            {box(8, 102 + i * 22, 164, 18, { r: 5 })}
            <rect x="14" y={106 + i * 22} width="10" height="12" rx="1" fill="var(--surface-sunk)" stroke={sub}/>
            {line(30, 106 + i * 22, 90, 4)}
            {line(30, 114 + i * 22, 60, 3)}
          </g>
        ))}
        {tabs}
      </>
    ),
    upd: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 80, 9)}
        {line(8, 74, 30, 3)}
        {box(8, 80, 164, 26, { r: 5 })}
        <rect x="14" y="86" width="14" height="14" rx="3" fill="var(--warn)" opacity="0.25"/>
        {line(34, 86, 100, 4)}
        {line(34, 96, 60, 3)}
        {line(8, 116, 40, 3)}
        {Array.from({ length: 3 }, (_, i) => (
          <g key={i}>
            {box(8, 122 + i * 26, 164, 22, { r: 5 })}
            <rect x="14" y={128 + i * 26} width="12" height="12" rx="3" fill={['var(--ok)','var(--accent)','var(--ok)'][i]} opacity="0.25"/>
            {line(32, 128 + i * 26, 90, 4)}
            {line(32, 136 + i * 26, 60, 3)}
          </g>
        ))}
        {tabs}
      </>
    ),
    tkt: (
      <>
        {head}
        {line(8, 40, 70, 6)}
        {line(8, 52, 90, 9)}
        <rect x="148" y="38" width="24" height="24" rx="6" fill={accent}/>
        {/* filter pills */}
        {['All','Open','Done'].map((l, i) => box(8 + i * 55, 76, 50, 18, { r: 5, fill: i === 0 ? 'var(--accent-soft)' : 'transparent', stroke: i === 0 ? accent : sub }))}
        {Array.from({ length: 4 }, (_, i) => (
          <g key={i}>
            {box(8, 104 + i * 30, 164, 26, { r: 6 })}
            {line(14, 110 + i * 30, 30, 3)}
            {line(14, 118 + i * 30, 100, 5)}
            <rect x="138" y={111 + i * 30} width="28" height="10" rx="5"
                  fill={['var(--info)','var(--warn)','var(--ok)','var(--ink-faint)'][i]} opacity="0.2"
                  stroke={['var(--info)','var(--warn)','var(--ok)','var(--ink-faint)'][i]}/>
          </g>
        ))}
        {tabs}
      </>
    ),
    prof: (
      <>
        {head}
        {/* buyer card */}
        {box(8, 40, 164, 40, { r: 6 })}
        <circle cx="26" cy="60" r="10" fill="var(--accent-soft)" stroke={accent}/>
        {line(44, 54, 70, 5)}
        {line(44, 64, 50, 3)}
        {line(44, 72, 60, 3)}
        {/* sales rep */}
        {line(8, 92, 40, 3)}
        {box(8, 100, 164, 28, { r: 6 })}
        <circle cx="22" cy="114" r="7" fill={fill} stroke={sub}/>
        {line(34, 110, 60, 4)}
        {line(34, 118, 40, 3)}
        <rect x="138" y="106" width="14" height="14" rx="3" fill="var(--accent-soft)" stroke={accent}/>
        <rect x="156" y="106" width="14" height="14" rx="3" fill="var(--accent-soft)" stroke={accent}/>
        {/* property */}
        {line(8, 140, 40, 3)}
        {Array.from({ length: 4 }, (_, i) => (
          <g key={i}>
            {box(8, 148 + i * 22, 164, 18, { r: 5 })}
            {line(14, 154 + i * 22, 50, 3)}
            {line(130, 154 + i * 22, 36, 3)}
          </g>
        ))}
        {tabs}
      </>
    ),
  };
  return (
    <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`} style={{ display: 'block' }}>
      {wireframes[id] || head}
    </svg>
  );
}

Object.assign(window, {
  SpecNavStructure, NavSample, SpecWireframes, Wire, WIRES,
});
