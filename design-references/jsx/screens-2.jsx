// screens-2.jsx — Module screens added in iteration 2.
// UnitDetail, Receipts, Loan, SupportTickets. Reuses primitives from ui.jsx.

// ─────────────────────────────────────────────────────────────
// Shared mock data
// ─────────────────────────────────────────────────────────────
const RECEIPTS = [
  { id: 'BB-26-1003', desc: 'Booking token',     amount: 200000,  date: '03 May 2026', method: 'NEFT · IOB23947',     status: 'cleared' },
  { id: 'BB-26-1018', desc: 'On agreement',      amount: 2050000, date: '18 May 2026', method: 'NEFT · HDFC44102',    status: 'cleared' },
];

const BANKS = [
  { name: 'HDFC Bank',        rate: '8.50%', proc: '7 days',  affiliated: true, tag: 'Recommended' },
  { name: 'State Bank of India', rate: '8.40%', proc: '12 days', affiliated: true, tag: null },
  { name: 'ICICI Bank',       rate: '8.55%', proc: '6 days',  affiliated: true, tag: 'Fastest' },
  { name: 'Axis Bank',        rate: '8.65%', proc: '9 days',  affiliated: true, tag: null },
  { name: 'LIC Housing Finance', rate: '8.75%', proc: '14 days', affiliated: false, tag: null },
];

const LOAN_STEPS = [
  { label: 'Applied',         sub: '05 May', done: true },
  { label: 'KYC verified',    sub: '08 May', done: true },
  { label: 'Property check',  sub: '14 May', done: true },
  { label: 'Sanctioned',      sub: '20 May', done: true, current: true },
  { label: 'Disbursement',    sub: 'Scheduled with foundation milestone', done: false },
];

const LOAN_DOCS = [
  { name: 'PAN card',                shared: true },
  { name: 'Aadhaar',                 shared: true },
  { name: 'Form 16 · FY25',          shared: true },
  { name: 'Salary slips · last 3 mo', shared: true },
  { name: 'Bank statements · 6 mo',  shared: true },
  { name: 'Property title (builder)', shared: true },
  { name: 'Sale agreement (final)',   shared: false },
];

const TICKETS = [
  { id: 'TKT-1042', title: 'Pool view obstructed — clarify drawing',  cat: 'Pre-AOS',     sla: '2 of 2 days', status: 'in_progress', last: 'Sai Krishna · 2h ago', priority: 'normal' },
  { id: 'TKT-1031', title: 'Update name in records (post-marriage)',  cat: 'Profile',     sla: 'within SLA',  status: 'in_progress', last: 'Accounts · 1d ago',    priority: 'normal' },
  { id: 'TKT-1024', title: 'Cheque returned — TDS 26AS mismatch',     cat: 'Payments',    sla: 'breached',    status: 'open',        last: 'You · 3d ago',         priority: 'high' },
  { id: 'TKT-1015', title: 'Cancel parking slot P2 (keep P1 only)',   cat: 'Booking',     sla: 'within SLA',  status: 'resolved',    last: 'Resolved · 12 Apr',    priority: 'normal' },
  { id: 'TKT-1009', title: 'Welcome kit not delivered',               cat: 'General',     sla: 'within SLA',  status: 'closed',      last: 'Closed · 04 Apr',      priority: 'low' },
];

// ─────────────────────────────────────────────────────────────
// UnitDetailScreen — deeper view than the inventory grid pop
// ─────────────────────────────────────────────────────────────
function UnitDetailScreen({ t, builder, nav }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '14px 16px 24px' }}>
      <div>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          {builder.project} · Block A · Floor 15
        </div>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginTop: 4 }}>
          <div style={{ fontSize: 28, fontWeight: 700, color: t.ink, letterSpacing: -0.4 }}>{builder.unit}</div>
          <Pill t={t} tone="accent" variant="solid">Yours</Pill>
        </div>
        <div style={{ fontSize: 13, color: t.inkMute, marginTop: 4 }}>{builder.typology} · East-facing · Pool view</div>
      </div>

      {/* floor plan */}
      <Card t={t} padding={0} style={{ overflow: 'hidden' }}>
        <div style={{
          background: t.surfaceSunk, padding: 18, position: 'relative',
        }}>
          <svg viewBox="0 0 320 220" width="100%" height="auto">
            <defs>
              <pattern id="fp-grid" width="16" height="16" patternUnits="userSpaceOnUse">
                <path d="M16 0H0V16" fill="none" stroke={t.lineStrong} strokeWidth="0.3"/>
              </pattern>
            </defs>
            <rect width="320" height="220" fill="url(#fp-grid)" opacity="0.5"/>
            <g stroke={t.ink} fill="none" strokeWidth="2">
              {/* outer */}
              <rect x="20" y="20" width="280" height="180" fill={t.surface}/>
              {/* living */}
              <rect x="20" y="120" width="160" height="80" fill={t.accentSoft}/>
              {/* master bed */}
              <rect x="20" y="20" width="110" height="100"/>
              {/* second bed */}
              <rect x="130" y="20" width="80" height="60"/>
              {/* third bed */}
              <rect x="210" y="20" width="90" height="80"/>
              {/* kitchen */}
              <rect x="180" y="120" width="120" height="40"/>
              {/* balcony */}
              <rect x="180" y="160" width="120" height="40" fill={t.surfaceMute}/>
            </g>
            {/* labels */}
            <g fontFamily="Manrope" fontSize="8" fill={t.inkMute} fontWeight="600">
              <text x="75" y="75" textAnchor="middle">MASTER</text>
              <text x="75" y="86" textAnchor="middle" fontSize="6.5">14′×12′</text>
              <text x="170" y="50" textAnchor="middle">BED 2</text>
              <text x="170" y="60" textAnchor="middle" fontSize="6.5">12′×10′</text>
              <text x="255" y="60" textAnchor="middle">BED 3</text>
              <text x="255" y="70" textAnchor="middle" fontSize="6.5">12′×11′</text>
              <text x="100" y="160" textAnchor="middle" fill={t.accent}>LIVING / DINING</text>
              <text x="100" y="172" textAnchor="middle" fontSize="6.5" fill={t.accent}>22′×14′</text>
              <text x="240" y="142" textAnchor="middle">KITCHEN</text>
              <text x="240" y="182" textAnchor="middle">BALCONY</text>
            </g>
            {/* north */}
            <g transform="translate(290, 30)">
              <circle r="9" stroke={t.inkMute} strokeWidth="0.8" fill="none"/>
              <path d="M0 -6L-3 4L0 2L3 4Z" fill={t.inkMute}/>
              <text y="14" textAnchor="middle" fontSize="6" fill={t.inkMute} fontWeight="600">N</text>
            </g>
          </svg>
        </div>
        <div style={{ display: 'flex', gap: 6, padding: '12px 14px', borderTop: `1px solid ${t.line}` }}>
          <Button t={t} variant="secondary" icon="eye" onClick={() => {}}>3D walkthrough</Button>
          <Button t={t} variant="secondary" icon="download" onClick={() => {}}>Plans PDF</Button>
        </div>
      </Card>

      {/* specs */}
      <Section label="Specifications" t={t}>
        <Card t={t} padding={0}>
          {[
            ['Carpet area',         '1,720 sq ft'],
            ['Built-up area',       '2,140 sq ft'],
            ['Facing',              'East'],
            ['View',                'Pool + central courtyard'],
            ['Parking',             '2 covered slots — P1, P2'],
            ['Furnishing',          'Semi-furnished (modular)'],
            ['Floor',               '15 of 22'],
            ['Possession',          'Dec 2027'],
          ].map((r, i, arr) => (
            <div key={i} style={{
              display: 'flex', justifyContent: 'space-between',
              padding: '12px 16px',
              borderBottom: i < arr.length - 1 ? `1px solid ${t.line}` : 'none',
            }}>
              <span style={{ fontSize: 13, color: t.inkMute }}>{r[0]}</span>
              <span style={{ fontSize: 13, fontWeight: 600, color: t.ink, fontFeatureSettings: '"tnum"' }}>{r[1]}</span>
            </div>
          ))}
        </Card>
      </Section>

      {/* amenities */}
      <Section label="Amenities in tower" t={t}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
          {[
            { icon: 'shield',   label: '24×7 security' },
            { icon: 'sparkle',  label: 'Clubhouse · 18k sqft' },
            { icon: 'layers',   label: 'Pool + gym' },
            { icon: 'home',     label: '3-tier landscaping' },
            { icon: 'pin',      label: 'EV charging' },
            { icon: 'building', label: 'Visitor parking' },
          ].map((a, i) => (
            <div key={i} style={{
              display: 'flex', alignItems: 'center', gap: 10,
              background: t.surface, border: `1px solid ${t.line}`,
              borderRadius: 12, padding: '12px 12px',
            }}>
              <div style={{
                width: 32, height: 32, borderRadius: 8, background: t.accentSoft,
                color: t.accent, display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon name={a.icon} size={16}/>
              </div>
              <span style={{ fontSize: 12.5, fontWeight: 600, color: t.ink, lineHeight: 1.2 }}>{a.label}</span>
            </div>
          ))}
        </div>
      </Section>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ReceiptsScreen — searchable invoice/receipt list
// ─────────────────────────────────────────────────────────────
function ReceiptsScreen({ t }) {
  const [query, setQuery] = React.useState('');
  const filtered = RECEIPTS.filter((r) =>
    !query || r.desc.toLowerCase().includes(query.toLowerCase()) || r.id.toLowerCase().includes(query.toLowerCase())
  );
  const total = filtered.reduce((s, r) => s + r.amount, 0);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '14px 16px 24px' }}>
      <div>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          Receipts & invoices
        </div>
        <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
          {RECEIPTS.length} receipts · {formatINR(total)}
        </div>
      </div>

      <div style={{
        display: 'flex', alignItems: 'center', gap: 10,
        padding: '10px 14px', background: t.surface, borderRadius: 12,
        border: `1px solid ${t.line}`,
      }}>
        <Icon name="search" size={18} color={t.inkFaint}/>
        <input value={query} onChange={(e) => setQuery(e.target.value)}
               placeholder="Search receipt # or description"
               style={{
                 flex: 1, border: 'none', background: 'transparent', outline: 'none',
                 color: t.ink, fontSize: 14, fontFamily: 'inherit',
               }}/>
      </div>

      <Card t={t} padding={0}>
        {filtered.map((r, i) => (
          <button key={r.id} style={{
            width: '100%', display: 'flex', alignItems: 'center', gap: 12,
            padding: '14px 14px', background: 'transparent', border: 'none', cursor: 'pointer',
            textAlign: 'left',
            borderBottom: i < filtered.length - 1 ? `1px solid ${t.line}` : 'none',
          }}>
            <div style={{
              width: 40, height: 40, borderRadius: 10, background: t.okSoft,
              color: t.ok, display: 'flex', alignItems: 'center', justifyContent: 'center',
              flexShrink: 0,
            }}>
              <Icon name="receipt" size={20}/>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: 13.5, fontWeight: 600, color: t.ink, letterSpacing: -0.1 }}>{r.desc}</div>
              <div style={{ fontSize: 11.5, color: t.inkFaint, marginTop: 2, fontFeatureSettings: '"tnum"' }}>
                {r.id} · {r.date}
              </div>
              <div style={{ fontSize: 11.5, color: t.inkMute, marginTop: 1 }}>{r.method}</div>
            </div>
            <div style={{ textAlign: 'right' }}>
              <div style={{ fontSize: 14, fontWeight: 700, color: t.ink, fontFeatureSettings: '"tnum"' }}>
                {formatINR(r.amount)}
              </div>
              <Pill t={t} tone="ok" variant="tint" style={{ marginTop: 4, height: 18, fontSize: 10 }}>
                Cleared
              </Pill>
            </div>
          </button>
        ))}
      </Card>

      <Button t={t} variant="secondary" icon="download">Export all as PDF</Button>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// LoanScreen — application tracker + bank chooser + docs
// ─────────────────────────────────────────────────────────────
function LoanScreen({ t, builder }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '14px 16px 24px' }}>
      <div>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          Home loan
        </div>
        <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
          ₹1.85 Cr · HDFC Bank
        </div>
        <div style={{ fontSize: 13, color: t.inkMute, marginTop: 4 }}>
          Loan account: HDFC HL-26009 · 22-year tenure
        </div>
      </div>

      {/* status timeline */}
      <Section label="Application status" t={t}>
        <Card t={t} padding={16}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {LOAN_STEPS.map((s, i, arr) => (
              <div key={i} style={{ display: 'flex', gap: 12 }}>
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                  <div style={{
                    width: 22, height: 22, borderRadius: '50%',
                    background: s.done ? t.accent : (s.current ? t.surface : t.surfaceMute),
                    border: `1.5px solid ${s.done || s.current ? t.accent : t.lineStrong}`,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    flexShrink: 0,
                    boxShadow: s.current ? `0 0 0 4px ${t.accentSoft}` : 'none',
                  }}>
                    {s.done && <Icon name="check" size={12} color={t.accentInk} strokeWidth={2.6}/>}
                  </div>
                  {i < arr.length - 1 && (
                    <div style={{ width: 1.5, flex: 1, background: s.done ? t.accent : t.line, minHeight: 14 }}/>
                  )}
                </div>
                <div style={{ flex: 1, paddingBottom: i < arr.length - 1 ? 6 : 0 }}>
                  <div style={{ fontSize: 13.5, fontWeight: s.current ? 700 : 600,
                                color: s.done || s.current ? t.ink : t.inkFaint }}>{s.label}</div>
                  <div style={{ fontSize: 11.5, color: t.inkFaint, marginTop: 1 }}>{s.sub}</div>
                </div>
              </div>
            ))}
          </div>
        </Card>
      </Section>

      {/* docs checklist */}
      <Section label="Documents required" t={t} action={`${LOAN_DOCS.filter(d => d.shared).length} of ${LOAN_DOCS.length} shared`}>
        <Card t={t} padding={0}>
          {LOAN_DOCS.map((d, i) => (
            <div key={i} style={{
              display: 'flex', alignItems: 'center', gap: 12, padding: '12px 14px',
              borderBottom: i < LOAN_DOCS.length - 1 ? `1px solid ${t.line}` : 'none',
            }}>
              <div style={{
                width: 22, height: 22, borderRadius: '50%',
                background: d.shared ? t.ok : t.surfaceMute,
                border: d.shared ? 'none' : `1.5px dashed ${t.lineStrong}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                {d.shared && <Icon name="check" size={12} color="#fff" strokeWidth={2.6}/>}
              </div>
              <span style={{ flex: 1, fontSize: 13.5, color: d.shared ? t.ink : t.inkMute, fontWeight: 500 }}>{d.name}</span>
              {!d.shared && (
                <button style={{
                  fontSize: 12, fontWeight: 600, color: t.accent,
                  background: 'transparent', border: 'none', cursor: 'pointer',
                }}>Upload</button>
              )}
            </div>
          ))}
        </Card>
      </Section>

      {/* affiliated banks */}
      <Section label="Affiliated banks" t={t}>
        <Card t={t} padding={0}>
          {BANKS.slice(0, 3).map((b, i) => (
            <div key={b.name} style={{
              display: 'flex', alignItems: 'center', gap: 12, padding: '14px 14px',
              borderBottom: i < 2 ? `1px solid ${t.line}` : 'none',
            }}>
              <div style={{
                width: 40, height: 40, borderRadius: 10, background: t.surfaceMute,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 13, fontWeight: 700, color: t.ink, flexShrink: 0,
              }}>{b.name.split(' ').map(w => w[0]).slice(0, 2).join('')}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
                  <span style={{ fontSize: 13.5, fontWeight: 700, color: t.ink }}>{b.name}</span>
                  {b.tag && <Pill t={t} tone={b.tag === 'Recommended' ? 'accent' : 'info'} variant="tint" style={{ height: 18, fontSize: 10 }}>{b.tag}</Pill>}
                </div>
                <div style={{ fontSize: 11.5, color: t.inkMute, marginTop: 2, fontFeatureSettings: '"tnum"' }}>
                  {b.rate} · sanction in {b.proc}
                </div>
              </div>
              <Icon name="chev" size={16} color={t.inkFaint}/>
            </div>
          ))}
        </Card>
      </Section>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// TicketsScreen — support tickets with SLA visibility
// ─────────────────────────────────────────────────────────────
function TicketsScreen({ t }) {
  const [filter, setFilter] = React.useState('all');
  const filters = [
    { k: 'all', l: 'All', count: TICKETS.length },
    { k: 'open', l: 'Open', count: TICKETS.filter(x => x.status === 'open' || x.status === 'in_progress').length },
    { k: 'resolved', l: 'Resolved', count: TICKETS.filter(x => x.status === 'resolved' || x.status === 'closed').length },
  ];
  const filtered = filter === 'all' ? TICKETS
                 : filter === 'open' ? TICKETS.filter(x => x.status === 'open' || x.status === 'in_progress')
                 : TICKETS.filter(x => x.status === 'resolved' || x.status === 'closed');

  const statusPill = (s) =>
    s === 'open' ? { tone: 'warn', label: 'Open' }
    : s === 'in_progress' ? { tone: 'info', label: 'In progress' }
    : s === 'resolved' ? { tone: 'ok', label: 'Resolved' }
    : { tone: 'neutral', label: 'Closed' };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 14, padding: '14px 16px 24px' }}>
      <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
            Support tickets
          </div>
          <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
            SLA-tracked support
          </div>
        </div>
        <button style={{
          width: 44, height: 44, borderRadius: 12, background: t.accent,
          color: t.accentInk, border: 'none', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: t.shadow,
        }}>
          <Icon name="plus" size={22} strokeWidth={2.2}/>
        </button>
      </div>

      {/* filters */}
      <div style={{ display: 'flex', gap: 8 }}>
        {filters.map((f) => {
          const on = filter === f.k;
          return (
            <button key={f.k} onClick={() => setFilter(f.k)} style={{
              flex: 1, padding: '10px 8px', borderRadius: 10,
              border: `1px solid ${on ? t.accent : t.line}`,
              background: on ? t.accentSoft : t.surface,
              color: on ? t.accent : t.inkMute,
              fontSize: 13, fontWeight: 600, cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
            }}>
              {f.l}
              <span style={{
                fontSize: 11, fontWeight: 700, padding: '1px 6px', borderRadius: 99,
                background: on ? t.accent : t.surfaceMute, color: on ? t.accentInk : t.inkFaint,
              }}>{f.count}</span>
            </button>
          );
        })}
      </div>

      <Card t={t} padding={0}>
        {filtered.map((tk, i) => {
          const sp = statusPill(tk.status);
          const slaBad = tk.sla === 'breached';
          return (
            <div key={tk.id} style={{
              padding: '14px 14px',
              borderBottom: i < filtered.length - 1 ? `1px solid ${t.line}` : 'none',
            }}>
              <div style={{ display: 'flex', alignItems: 'flex-start', gap: 10, justifyContent: 'space-between' }}>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 4 }}>
                    <span style={{ fontSize: 11, fontWeight: 700, color: t.inkFaint, letterSpacing: 0.5, fontFeatureSettings: '"tnum"' }}>
                      {tk.id}
                    </span>
                    <span style={{ fontSize: 11, color: t.inkFaint }}>·</span>
                    <span style={{ fontSize: 11, fontWeight: 600, color: t.inkMute }}>{tk.cat}</span>
                    {tk.priority === 'high' && <Pill t={t} tone="danger" variant="tint" style={{ height: 16, fontSize: 9 }}>High</Pill>}
                  </div>
                  <div style={{ fontSize: 14, fontWeight: 600, color: t.ink, lineHeight: 1.3 }}>{tk.title}</div>
                  <div style={{ fontSize: 11.5, color: t.inkFaint, marginTop: 6 }}>{tk.last}</div>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 6 }}>
                  <Pill t={t} tone={sp.tone} variant="tint">{sp.label}</Pill>
                  <span style={{
                    fontSize: 10.5, fontWeight: 600,
                    color: slaBad ? t.danger : t.inkFaint,
                  }}>
                    {slaBad ? '⚠ SLA breached' : `SLA ${tk.sla}`}
                  </span>
                </div>
              </div>
            </div>
          );
        })}
      </Card>
    </div>
  );
}

Object.assign(window, {
  UnitDetailScreen, ReceiptsScreen, LoanScreen, TicketsScreen,
  RECEIPTS, BANKS, LOAN_STEPS, LOAN_DOCS, TICKETS,
});
