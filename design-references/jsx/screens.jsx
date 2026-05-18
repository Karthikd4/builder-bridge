// screens.jsx — BuilderBridge buyer app screens.
// Each screen is (props: { t, builder, stage, nav, onTab }) → JSX.
// Stage values: 'prospect', 'visit', 'estimate', 'booked', 'aos', 'signed'

// ─────────────────────────────────────────────────────────────
// Shared data — Hyderabad-flavored
// ─────────────────────────────────────────────────────────────
const BUYER = { name: 'Arjun Reddy', email: 'arjun.reddy@gmail.com', phone: '+91 98480 12211' };
const SALES = { name: 'Sai Krishna', role: 'Sales Manager', phone: '+91 91002 33455' };

const JOURNEY_STEPS = [
  { label: 'Enquiry',   sub: 'Apr 02', key: 'prospect' },
  { label: 'Site visit', sub: 'Apr 14', key: 'visit' },
  { label: 'Estimate',   sub: 'Apr 22', key: 'estimate' },
  { label: 'Booked',     sub: 'May 03', key: 'booked' },
  { label: 'AOS',        sub: 'May 18', key: 'aos' },
  { label: 'Reg.',       sub: 'Jul ’26', key: 'register' },
  { label: 'Handover',   sub: 'Q4 ’27', key: 'handover' },
];

const stageToIdx = (stage) => {
  const m = { prospect: 0, visit: 1, estimate: 2, booked: 3, aos: 4, signed: 5 };
  return m[stage] ?? 3;
};

// Payment milestones — full lifecycle.
const MILESTONES = [
  { id: 1, name: 'Booking token',           amount: 200000,   due: '03 May 2026', status: 'paid',     ref: 'NEFT IOB23947' },
  { id: 2, name: 'On agreement',            amount: 2050000,  due: '18 May 2026', status: 'paid',     ref: 'NEFT HDFC44102' },
  { id: 3, name: 'Foundation',              amount: 4370000,  due: '28 May 2026', status: 'due',      ref: null },
  { id: 4, name: 'Plinth',                  amount: 2185000,  due: '22 Jul 2026', status: 'upcoming', ref: null },
  { id: 5, name: '6th floor slab',          amount: 2185000,  due: '15 Oct 2026', status: 'upcoming', ref: null },
  { id: 6, name: '12th floor slab',         amount: 2185000,  due: '20 Jan 2027', status: 'upcoming', ref: null },
  { id: 7, name: 'Brickwork & plastering',  amount: 2185000,  due: '12 Apr 2027', status: 'upcoming', ref: null },
  { id: 8, name: 'Final finishes',          amount: 2185000,  due: '10 Jul 2027', status: 'upcoming', ref: null },
  { id: 9, name: 'On registration',         amount: 2185000,  due: '15 Oct 2027', status: 'upcoming', ref: null },
  { id: 10, name: 'On possession',          amount: 2020000,  due: '20 Dec 2027', status: 'upcoming', ref: null },
];

// Cost estimate line items
const ESTIMATE = [
  { label: 'Base price',          sub: '2,140 sq ft × ₹8,750',  amount: 18725000 },
  { label: 'Floor rise (15th)',   sub: '₹150 × 2,140 × 15',     amount: 4815000 },
  { label: 'East-facing premium', sub: 'Block A pricing',       amount: 350000 },
  { label: 'Pool-view premium',   sub: '',                      amount: 250000 },
  { label: 'Covered parking',     sub: '2 slots',                amount: 600000 },
  { label: 'Club membership',     sub: 'one-time',               amount: 300000 },
  { label: 'Legal & docs',        sub: '',                       amount: 75000 },
  { label: 'Discount applied',    sub: 'Pre-launch · approved',  amount: -1265000 },
  { label: 'GST (5%)',            sub: 'on construction value',  amount: 1100000 },
];

const DOCUMENTS = [
  { cat: 'Agreement', name: 'Agreement of Sale — Draft v2.pdf',       size: '4.2 MB', date: '18 May 2026', tag: 'Under review' },
  { cat: 'Agreement', name: 'Booking Confirmation Letter.pdf',         size: '480 KB', date: '03 May 2026', tag: 'Signed' },
  { cat: 'Plans',     name: 'A-1502 — Floor plan.pdf',                 size: '2.1 MB', date: '22 Apr 2026', tag: null },
  { cat: 'Plans',     name: 'Pavilion Heights — Master layout.pdf',    size: '6.8 MB', date: '12 Apr 2026', tag: null },
  { cat: 'Plans',     name: 'A-1502 — 3D walkthrough.mp4',             size: '38 MB',  date: '14 Apr 2026', tag: 'New' },
  { cat: 'Receipts',  name: 'Receipt — Booking token ₹2.00 L.pdf',     size: '120 KB', date: '03 May 2026', tag: null },
  { cat: 'Receipts',  name: 'Receipt — On agreement ₹20.50 L.pdf',     size: '128 KB', date: '18 May 2026', tag: null },
  { cat: 'Compliance', name: 'RERA Certificate — P02400006789.pdf',     size: '320 KB', date: '12 Apr 2026', tag: null },
  { cat: 'Compliance', name: 'Approved building plan — HMDA.pdf',       size: '5.4 MB', date: '12 Apr 2026', tag: null },
  { cat: 'Compliance', name: 'Title deed — Survey 138/2.pdf',           size: '1.8 MB', date: '12 Apr 2026', tag: null },
  { cat: 'Estimate',   name: 'Cost Estimate v3 — Final.pdf',            size: '210 KB', date: '22 Apr 2026', tag: 'Final' },
  { cat: 'Estimate',   name: 'Cost Estimate v2.pdf',                    size: '208 KB', date: '20 Apr 2026', tag: null },
  { cat: 'Estimate',   name: 'Cost Estimate v1 — Initial.pdf',          size: '202 KB', date: '15 Apr 2026', tag: null },
];

const UPDATES = [
  { kind: 'payment',  title: 'Foundation milestone due in 6 days',  body: '₹43.70 L due on 28 May 2026',     time: '2h',    tone: 'warn' },
  { kind: 'doc',      title: 'AOS Draft v2 shared by builder',      body: 'Sai Krishna · review by 22 May',  time: '1d',    tone: 'info' },
  { kind: 'success',  title: 'Payment received — On agreement',     body: '₹20.50 L · NEFT HDFC44102',        time: '3d',    tone: 'ok' },
  { kind: 'doc',      title: '3D walkthrough video added',          body: 'A-1502 · Pavilion Heights',        time: '5d',    tone: 'info' },
  { kind: 'success',  title: 'Booking confirmed — A-1502',          body: 'Token received · Unit reserved',   time: '2w',    tone: 'ok' },
  { kind: 'info',     title: 'Site visit completed',                body: 'Karthik Rao on-site escort',       time: '4w',    tone: 'info' },
];

// ─────────────────────────────────────────────────────────────
// HomeScreen — the everything-at-a-glance dashboard
// ─────────────────────────────────────────────────────────────
function HomeScreen({ t, builder, stage, nav }) {
  const idx = stageToIdx(stage);
  const nextDue = MILESTONES.find((m) => m.status === 'due');
  const paid = MILESTONES.filter((m) => m.status === 'paid').reduce((s, m) => s + m.amount, 0);
  const total = MILESTONES.reduce((s, m) => s + m.amount, 0);
  const pct = Math.round((paid / total) * 100);

  // primary action by stage
  const action = (() => {
    if (stage === 'prospect') return { label: 'Schedule a site visit', icon: 'pin', onClick: () => nav('inventory') };
    if (stage === 'visit')    return { label: 'View available units',  icon: 'building', onClick: () => nav('inventory') };
    if (stage === 'estimate') return { label: 'Review cost estimate',  icon: 'receipt',  onClick: () => nav('estimate') };
    if (stage === 'booked')   return { label: 'Review AOS draft',      icon: 'doc',      onClick: () => nav('aos') };
    if (stage === 'aos')      return { label: 'Sign Agreement of Sale', icon: 'doc',     onClick: () => nav('aos') };
    return { label: 'Pay foundation milestone', icon: 'rupee', onClick: () => nav('payments') };
  })();

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 18, padding: '14px 16px 24px' }}>
      {/* Greeting */}
      <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 13, color: t.inkMute, fontWeight: 500 }}>
            Good morning, Arjun
          </div>
          <div style={{
            fontSize: 24, fontWeight: 700, color: t.ink, letterSpacing: -0.5, marginTop: 2,
          }}>Your home, in motion.</div>
        </div>
        <div style={{
          width: 40, height: 40, borderRadius: '50%', background: t.accentSoft,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          color: t.accent, fontWeight: 700, fontSize: 14,
        }}>AR</div>
      </div>

      {/* Flat card */}
      <Card t={t} padding={0} style={{ overflow: 'hidden' }}>
        {/* hero band */}
        <div style={{
          height: 132, position: 'relative',
          backgroundColor: builder.accent,
          backgroundImage: `linear-gradient(135deg, ${builder.accent} 0%, ${t.accentDark} 100%)`,
          padding: '14px 16px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
          color: builder.accentInk,
        }}>
          {/* isometric building motif */}
          <svg viewBox="0 0 200 120" style={{
            position: 'absolute', right: -10, top: -8, height: 156, width: 180,
            opacity: 0.18,
          }}>
            <g stroke={builder.accentInk} fill="none" strokeWidth="1.2">
              <path d="M40 30 L100 10 L160 30 L100 50 Z"/>
              <path d="M40 30 L40 90 L100 110 L100 50"/>
              <path d="M100 50 L100 110 L160 90 L160 30"/>
              <path d="M50 36 L50 96 M60 41 L60 101 M70 46 L70 106 M80 51 L80 111"/>
              <path d="M110 53 L110 113 M120 51 L120 111 M130 48 L130 108 M140 45 L140 105 M150 42 L150 102"/>
            </g>
          </svg>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', position: 'relative' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 11.5, fontWeight: 600,
              padding: '4px 8px', borderRadius: 99, background: 'rgba(255,255,255,0.18)',
              backdropFilter: 'blur(8px)', WebkitBackdropFilter: 'blur(8px)',
            }}>
              <Icon name="shield" size={12} strokeWidth={2}/>
              RERA · {builder.rera}
            </div>
            <div style={{
              fontFamily: 'Söhne, "Inter", sans-serif', fontSize: 11, fontWeight: 600,
              letterSpacing: 0.3, opacity: 0.85,
            }}>
              {builder.name.toUpperCase()}
            </div>
          </div>
          <div style={{ position: 'relative' }}>
            <div style={{ fontSize: 11, fontWeight: 600, opacity: 0.75, letterSpacing: 0.5, textTransform: 'uppercase' }}>
              {builder.project}
            </div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginTop: 4 }}>
              <div style={{ fontSize: 30, fontWeight: 700, letterSpacing: -0.6, lineHeight: 1 }}>
                {builder.unit}
              </div>
              <div style={{ fontSize: 13, opacity: 0.85, fontWeight: 500 }}>
                {builder.typology}
              </div>
            </div>
            <div style={{ fontSize: 12, marginTop: 4, opacity: 0.85 }}>
              {builder.block} · {builder.location}
            </div>
          </div>
        </div>
        {/* fact row */}
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr 1fr',
          padding: '14px 4px', borderTop: `1px solid ${t.line}`,
        }}>
          {[
            { l: 'Agreed price', v: formatINR(builder.agreedPrice) },
            { l: 'Paid',         v: `${pct}%`, sub: formatINR(paid) },
            { l: 'Possession',   v: 'Dec ’27' },
          ].map((s, i) => (
            <div key={i} style={{
              textAlign: 'center',
              borderLeft: i > 0 ? `1px solid ${t.line}` : 'none',
              padding: '2px 8px',
            }}>
              <div style={{ fontSize: 10.5, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>{s.l}</div>
              <div style={{ fontSize: 16, fontWeight: 700, color: t.ink, marginTop: 4, fontFeatureSettings: '"tnum"' }}>{s.v}</div>
              {s.sub && <div style={{ fontSize: 11, color: t.inkMute, fontFeatureSettings: '"tnum"' }}>{s.sub}</div>}
            </div>
          ))}
        </div>
      </Card>

      {/* Journey */}
      <Section label="Your journey" t={t} action="See all">
        <BlueprintTimeline t={t} steps={JOURNEY_STEPS} currentIdx={idx} />
      </Section>

      {/* Next action */}
      <Card t={t} padding={0} style={{
        overflow: 'hidden', borderColor: t.accent,
        boxShadow: `0 0 0 1px ${t.accent}, ${t.shadowLg}`,
      }}>
        <div style={{ padding: '14px 16px 16px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
            <Pill t={t} tone="accent" variant="tint">
              <Icon name="sparkle" size={11} strokeWidth={2.2}/> Next up
            </Pill>
            {stage === 'signed' && nextDue && (
              <span style={{ fontSize: 12, color: t.inkMute }}>
                Due {nextDue.due.slice(0, 6)}
              </span>
            )}
          </div>
          {stage === 'signed' && nextDue ? (
            <>
              <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>
                {nextDue.name} milestone
              </div>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 4 }}>
                <span style={{ fontSize: 22, fontWeight: 700, color: t.ink, fontFeatureSettings: '"tnum"' }}>
                  {formatINR(nextDue.amount)}
                </span>
                <span style={{ fontSize: 12, color: t.inkMute }}>due in 6 days</span>
              </div>
            </>
          ) : (
            <>
              <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>
                {action.label}
              </div>
              <div style={{ fontSize: 13, color: t.inkMute, marginTop: 4, lineHeight: 1.4 }}>
                {stage === 'prospect' && 'See the model flat and walk the block with Sai Krishna.'}
                {stage === 'visit' && 'Visit done. Pick a unit to see your itemised cost estimate.'}
                {stage === 'estimate' && 'Cost Estimate v3 is the final agreed version. Pay token to reserve.'}
                {stage === 'booked' && 'Draft v2 is ready. Add comments on any clause for clarification.'}
                {stage === 'aos' && 'All clauses resolved. Sign digitally — no print, no courier.'}
              </div>
            </>
          )}
        </div>
        <Button t={t} icon={action.icon} onClick={action.onClick} style={{
          borderRadius: 0, minHeight: 52,
        }}>
          {stage === 'signed' && nextDue ? `Pay ${formatINR(nextDue.amount)}` : action.label}
        </Button>
      </Card>

      {/* Quick links */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
        {[
          { icon: 'building', label: 'Browse inventory', onClick: () => nav('inventory') },
          { icon: 'layers',  label: 'My floor plan',    onClick: () => nav('unit') },
          { icon: 'receipt', label: 'Receipts',         onClick: () => nav('receipts') },
          { icon: 'doc',     label: 'AOS draft',        onClick: () => nav('aos') },
        ].map((q, i) => (
          <button key={i} onClick={q.onClick} style={{
            background: t.surface, border: `1px solid ${t.line}`, borderRadius: 14,
            padding: '14px 14px', display: 'flex', alignItems: 'center', gap: 10,
            cursor: 'pointer', textAlign: 'left',
          }}>
            <div style={{
              width: 36, height: 36, borderRadius: 10, background: t.accentSoft,
              color: t.accent, display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name={q.icon} size={18}/>
            </div>
            <span style={{ fontSize: 14, fontWeight: 600, color: t.ink }}>{q.label}</span>
          </button>
        ))}
      </div>

      {/* Recent activity */}
      <Section label="Recent activity" t={t} action="See all">
        <Card t={t} padding={0}>
          {UPDATES.slice(0, 3).map((u, i) => (
            <div key={i} style={{
              display: 'flex', alignItems: 'flex-start', gap: 12,
              padding: '12px 14px',
              borderBottom: i < 2 ? `1px solid ${t.line}` : 'none',
            }}>
              <div style={{
                width: 32, height: 32, borderRadius: 10,
                background: t[`${u.tone}Soft`] || t.surfaceMute,
                color: t[u.tone] || t.inkMute,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                flexShrink: 0,
              }}>
                <Icon name={u.kind === 'payment' ? 'rupee' : u.kind === 'doc' ? 'doc' : u.kind === 'success' ? 'check' : 'bell'}
                      size={16} strokeWidth={2}/>
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13.5, fontWeight: 600, color: t.ink, lineHeight: 1.3 }}>{u.title}</div>
                <div style={{ fontSize: 12, color: t.inkMute, marginTop: 2 }}>{u.body}</div>
              </div>
              <div style={{ fontSize: 11, color: t.inkFaint, fontVariantNumeric: 'tabular-nums' }}>{u.time}</div>
            </div>
          ))}
        </Card>
      </Section>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// InventoryScreen — wraps the new InventoryExplorer (mobile layout, buyer mode)
// The full system (data, views, filters, detail sheet) lives in
// inventory-*.jsx files. This screen is just the in-app entry point.
// ─────────────────────────────────────────────────────────────
function InventoryScreen({ t, builder, nav }) {
  return <InventoryExplorer t={t} mode="buyer" layout="embedded" defaultView="tower"/>;
}

// ─────────────────────────────────────────────────────────────
// EstimateScreen — itemised cost breakdown
// ─────────────────────────────────────────────────────────────
function EstimateScreen({ t, builder }) {
  const subtotal = ESTIMATE.reduce((s, l) => s + l.amount, 0);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '14px 16px 24px' }}>
      {/* version meta */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
            Cost estimate · v3 (final)
          </div>
          <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
            {builder.unit} — {builder.typology.split(' · ')[0]}
          </div>
        </div>
        <Pill t={t} tone="ok" variant="tint">
          <Icon name="check" size={11} strokeWidth={2.5}/> Agreed
        </Pill>
      </div>

      {/* version chips */}
      <div style={{ display: 'flex', gap: 8, overflowX: 'auto' }} className="hide-scroll">
        {['v1 · 15 Apr', 'v2 · 20 Apr', 'v3 · 22 Apr · Final'].map((v, i) => (
          <button key={i} style={{
            flexShrink: 0, padding: '8px 12px', borderRadius: 10,
            border: `1px solid ${i === 2 ? t.accent : t.line}`,
            background: i === 2 ? t.accentSoft : t.surface,
            color: i === 2 ? t.accent : t.inkMute,
            fontSize: 12, fontWeight: 600, cursor: 'pointer',
          }}>{v}</button>
        ))}
      </div>

      {/* breakdown card */}
      <Card t={t} padding={0}>
        <div style={{ padding: '12px 16px 4px' }}>
          <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
            Breakdown
          </div>
        </div>
        <div style={{ padding: '4px 16px 12px', display: 'flex', flexDirection: 'column', gap: 12 }}>
          {ESTIMATE.map((line, i) => (
            <div key={i}>
              <Row t={t} label={line.label}
                   sub={line.sub}
                   value={(line.amount < 0 ? '−' : '') + formatINR(Math.abs(line.amount))}
                   style={line.amount < 0 ? { color: t.ok } : null} />
              {i < ESTIMATE.length - 1 && (
                <div style={{ height: 1, background: t.line, marginTop: 12 }}/>
              )}
            </div>
          ))}
        </div>
        {/* total */}
        <div style={{
          background: t.surfaceMute, borderTop: `1px solid ${t.line}`,
          padding: '14px 16px', display: 'flex', flexDirection: 'column', gap: 6,
        }}>
          <div style={{
            display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
          }}>
            <span style={{ fontSize: 12, fontWeight: 600, color: t.inkMute, letterSpacing: 0.4, textTransform: 'uppercase' }}>
              Agreed total
            </span>
            <span style={{
              fontSize: 24, fontWeight: 700, color: t.ink, letterSpacing: -0.4,
              fontFeatureSettings: '"tnum"',
            }}>{formatINR(subtotal)}</span>
          </div>
          <div style={{ fontSize: 11, color: t.inkFaint }}>
            {formatINR(subtotal, { compact: false })}
          </div>
        </div>
      </Card>

      {/* discount note */}
      <Card t={t} padding={14} style={{ background: t.okSoft, border: `1px solid ${t.ok}` }}>
        <div style={{ display: 'flex', gap: 10, alignItems: 'flex-start' }}>
          <Icon name="sparkle" size={18} color={t.ok}/>
          <div>
            <div style={{ fontSize: 13, fontWeight: 700, color: t.ink }}>
              ₹12.65 L discount applied
            </div>
            <div style={{ fontSize: 12, color: t.inkMute, marginTop: 2, lineHeight: 1.4 }}>
              Pre-launch incentive · approved by Sai Krishna on 22 Apr 2026.
              See full negotiation history for audit trail.
            </div>
          </div>
        </div>
      </Card>

      <div style={{ display: 'flex', gap: 8 }}>
        <Button t={t} variant="secondary" icon="download" onClick={() => {}}>PDF</Button>
        <Button t={t} variant="primary" icon="share" onClick={() => {}}>Share</Button>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// PaymentsScreen — ring + milestone list
// ─────────────────────────────────────────────────────────────
function PaymentsScreen({ t, builder, nav }) {
  const paid = MILESTONES.filter((m) => m.status === 'paid').reduce((s, m) => s + m.amount, 0);
  const due = MILESTONES.find((m) => m.status === 'due');

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 18, padding: '14px 16px 24px' }}>
      <div>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          Payment schedule
        </div>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
            {builder.unit} · 10 milestones
          </div>
          <button onClick={() => nav('receipts')} style={{
            fontSize: 13, fontWeight: 600, color: t.accent,
            background: 'transparent', border: 'none', cursor: 'pointer',
          }}>Receipts ›</button>
        </div>
      </div>

      {/* ring */}
      <Card t={t} padding={20}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 6 }}>
          <PaymentRing t={t} milestones={MILESTONES} size={220} />
        </div>
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10,
          paddingTop: 14, borderTop: `1px solid ${t.line}`, marginTop: 8,
        }}>
          {[
            { l: 'Milestones', v: `2 / ${MILESTONES.length}`, sub: 'paid' },
            { l: 'Next due',   v: '28 May',   sub: '₹43.70 L' },
            { l: 'Possession', v: 'Dec ’27',   sub: 'final ₹20.20 L' },
          ].map((s, i) => (
            <div key={i} style={{ textAlign: 'center' }}>
              <div style={{ fontSize: 10.5, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.4, textTransform: 'uppercase' }}>{s.l}</div>
              <div style={{ fontSize: 15, fontWeight: 700, color: t.ink, marginTop: 4, fontFeatureSettings: '"tnum"' }}>{s.v}</div>
              <div style={{ fontSize: 11, color: t.inkMute, fontFeatureSettings: '"tnum"' }}>{s.sub}</div>
            </div>
          ))}
        </div>
      </Card>

      {/* upcoming due banner */}
      {due && (
        <Card t={t} padding={14} style={{
          background: t.warnSoft, border: `1px solid ${t.warn}`,
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{
              width: 36, height: 36, borderRadius: 10, background: t.warn,
              display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', flexShrink: 0,
            }}>
              <Icon name="clock" size={20} strokeWidth={2}/>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, fontWeight: 700, color: t.ink }}>
                {due.name} · due in 6 days
              </div>
              <div style={{ fontSize: 12, color: t.inkMute, fontFeatureSettings: '"tnum"' }}>
                {formatINR(due.amount, { compact: false })} · {due.due}
              </div>
            </div>
            <Button t={t} fullWidth={false} variant="primary" style={{ minHeight: 36, padding: '0 14px', fontSize: 13 }}>
              Pay
            </Button>
          </div>
        </Card>
      )}

      {/* milestones */}
      <Section label="All milestones" t={t}>
        <Card t={t} padding={0}>
          {MILESTONES.map((m, i) => {
            const tone = m.status === 'paid' ? 'ok'
                       : m.status === 'due' ? 'warn'
                       : m.status === 'overdue' ? 'danger'
                       : 'neutral';
            const label = m.status === 'paid' ? 'Paid'
                        : m.status === 'due' ? 'Due'
                        : m.status === 'overdue' ? 'Overdue'
                        : 'Upcoming';
            return (
              <div key={m.id} style={{
                display: 'flex', alignItems: 'center', gap: 12, padding: '12px 14px',
                borderBottom: i < MILESTONES.length - 1 ? `1px solid ${t.line}` : 'none',
              }}>
                <div style={{
                  width: 28, height: 28, borderRadius: '50%',
                  background: m.status === 'paid' ? t.ok : t.surfaceMute,
                  border: m.status === 'paid' ? 'none' : `1px solid ${t.lineStrong}`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  flexShrink: 0,
                }}>
                  {m.status === 'paid' ? (
                    <Icon name="check" size={14} color="#fff" strokeWidth={2.6}/>
                  ) : (
                    <span style={{ fontSize: 11, fontWeight: 700, color: t.inkFaint }}>{m.id}</span>
                  )}
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 14, fontWeight: 600, color: t.ink, letterSpacing: -0.1 }}>{m.name}</div>
                  <div style={{ fontSize: 11.5, color: t.inkFaint, marginTop: 1 }}>
                    {m.ref ? `${m.due} · ${m.ref}` : m.due}
                  </div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <div style={{ fontSize: 14, fontWeight: 700, color: t.ink, fontFeatureSettings: '"tnum"' }}>
                    {formatINR(m.amount)}
                  </div>
                  <Pill t={t} tone={tone} variant="tint" style={{ marginTop: 4, height: 18, fontSize: 10 }}>
                    {label}
                  </Pill>
                </div>
              </div>
            );
          })}
        </Card>
      </Section>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// DocumentsScreen — categorised vault
// ─────────────────────────────────────────────────────────────
function DocumentsScreen({ t, builder, nav }) {
  const [cat, setCat] = React.useState('All');
  const cats = ['All', 'Agreement', 'Plans', 'Receipts', 'Estimate', 'Compliance'];
  const filtered = cat === 'All' ? DOCUMENTS : DOCUMENTS.filter((d) => d.cat === cat);

  const catIcon = { Agreement: 'doc', Plans: 'layers', Receipts: 'receipt', Estimate: 'rupee', Compliance: 'shield' };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '14px 16px 24px' }}>
      <div>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          Documents vault
        </div>
        <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
          {DOCUMENTS.length} files · 60 MB
        </div>
      </div>

      {/* category chips */}
      <div style={{ display: 'flex', gap: 8, overflowX: 'auto' }} className="hide-scroll">
        {cats.map((c) => {
          const isOn = cat === c;
          return (
            <button key={c} onClick={() => setCat(c)} style={{
              flexShrink: 0, padding: '8px 14px', borderRadius: 999,
              border: `1px solid ${isOn ? t.accent : t.line}`,
              background: isOn ? t.accent : t.surface,
              color: isOn ? t.accentInk : t.ink,
              fontSize: 12.5, fontWeight: 600, cursor: 'pointer',
            }}>{c}</button>
          );
        })}
      </div>

      <Card t={t} padding={0}>
        {filtered.map((d, i) => (
          <button key={i}
                  onClick={() => d.cat === 'Agreement' && d.name.includes('Draft') ? nav('aos') : null}
                  style={{
            width: '100%', display: 'flex', alignItems: 'center', gap: 12,
            padding: '12px 14px', background: 'transparent',
            border: 'none', cursor: 'pointer', textAlign: 'left',
            borderBottom: i < filtered.length - 1 ? `1px solid ${t.line}` : 'none',
          }}>
            <div style={{
              width: 38, height: 46, borderRadius: 6,
              background: t.surfaceMute, border: `1px solid ${t.line}`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              flexShrink: 0, position: 'relative',
            }}>
              <Icon name={catIcon[d.cat] || 'doc'} size={18} color={t.inkMute}/>
              <div style={{
                position: 'absolute', bottom: -1, right: -1,
                background: t.accent, color: t.accentInk,
                fontSize: 8, fontWeight: 700, padding: '1px 3px', borderRadius: 2,
                letterSpacing: 0.5,
              }}>{d.name.split('.').pop().toUpperCase().slice(0, 3)}</div>
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{
                fontSize: 13.5, fontWeight: 600, color: t.ink,
                whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                letterSpacing: -0.1,
              }}>{d.name}</div>
              <div style={{
                fontSize: 11.5, color: t.inkFaint, marginTop: 2,
                display: 'flex', alignItems: 'center', gap: 6,
              }}>
                <span>{d.cat}</span>
                <span style={{ opacity: 0.5 }}>·</span>
                <span>{d.size}</span>
                <span style={{ opacity: 0.5 }}>·</span>
                <span>{d.date}</span>
              </div>
            </div>
            {d.tag && (
              <Pill t={t} tone={d.tag === 'New' ? 'accent' : d.tag === 'Under review' ? 'warn' : d.tag === 'Signed' ? 'ok' : 'neutral'} variant="tint">
                {d.tag}
              </Pill>
            )}
          </button>
        ))}
      </Card>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// AOSScreen — Agreement of Sale review
// ─────────────────────────────────────────────────────────────
function AOSScreen({ t, builder, stage, nav }) {
  const signed = stage === 'signed';
  const [showSign, setShowSign] = React.useState(false);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '14px 16px 24px' }}>
      <div>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          Agreement of Sale
        </div>
        <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
          Draft v2 · {builder.unit}
        </div>
      </div>

      {/* status track */}
      <Card t={t} padding={14}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {[
            { label: 'Draft shared by builder',    sub: '14 May 2026 · Sai Krishna', done: true },
            { label: 'Buyer review · v1',           sub: '15 May · 3 comments raised', done: true },
            { label: 'Revised draft v2 shared',     sub: '18 May 2026', done: true },
            { label: 'Buyer review · v2',           sub: 'In progress', done: false, current: !signed },
            { label: 'Signature collected',         sub: signed ? '20 May 2026 · DocuSign' : 'Pending', done: signed, current: false },
            { label: 'Final AOS archived',          sub: signed ? '20 May 2026' : 'Pending', done: signed },
          ].map((s, i, arr) => (
            <div key={i} style={{ display: 'flex', gap: 12 }}>
              <div style={{
                display: 'flex', flexDirection: 'column', alignItems: 'center',
              }}>
                <div style={{
                  width: 22, height: 22, borderRadius: '50%',
                  background: s.done ? t.accent : (s.current ? t.surface : t.surfaceMute),
                  border: `1.5px solid ${s.done || s.current ? t.accent : t.lineStrong}`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  flexShrink: 0,
                }}>
                  {s.done && <Icon name="check" size={12} color={t.accentInk} strokeWidth={2.6}/>}
                </div>
                {i < arr.length - 1 && (
                  <div style={{
                    width: 1.5, flex: 1, background: s.done ? t.accent : t.line,
                    minHeight: 14,
                  }}/>
                )}
              </div>
              <div style={{ flex: 1, paddingBottom: i < arr.length - 1 ? 6 : 0 }}>
                <div style={{
                  fontSize: 13.5, fontWeight: s.current ? 700 : 600,
                  color: s.done || s.current ? t.ink : t.inkFaint,
                }}>{s.label}</div>
                <div style={{ fontSize: 11.5, color: t.inkFaint, marginTop: 1 }}>{s.sub}</div>
              </div>
            </div>
          ))}
        </div>
      </Card>

      {/* document preview */}
      <Card t={t} padding={0} style={{ overflow: 'hidden' }}>
        <div style={{ padding: '14px 16px', borderBottom: `1px solid ${t.line}` }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <Icon name="doc" size={18} color={t.inkMute}/>
            <span style={{ flex: 1, fontSize: 13.5, fontWeight: 600, color: t.ink }}>
              AOS_v2_{builder.unit}.pdf
            </span>
            <span style={{ fontSize: 11.5, color: t.inkFaint }}>26 pages · 4.2 MB</span>
          </div>
        </div>
        {/* doc preview mock */}
        <div style={{ background: t.surfaceSunk, padding: 18 }}>
          <div style={{
            background: '#fff', color: '#111',
            padding: '16px 16px', borderRadius: 4,
            boxShadow: '0 2px 10px rgba(11,18,40,0.08)',
            fontFamily: 'Georgia, serif',
            fontSize: 8.5, lineHeight: 1.5,
            minHeight: 180,
          }}>
            <div style={{ textAlign: 'center', fontWeight: 700, fontSize: 10, letterSpacing: 1 }}>
              AGREEMENT OF SALE
            </div>
            <div style={{ textAlign: 'center', fontSize: 7.5, marginTop: 2, color: '#555' }}>
              between {builder.name} and Mr Arjun Reddy
            </div>
            <div style={{ height: 1, background: '#ccc', margin: '8px 0' }}/>
            <div style={{ color: '#333' }}>
              <p style={{ margin: '4px 0' }}>
                THIS AGREEMENT made and entered into at Hyderabad on this 18th day of May 2026
                BETWEEN {builder.name} Private Limited, a company incorporated under the Companies Act…
              </p>
              <p style={{ margin: '4px 0' }}>
                <b style={{ background: '#FFF3CD' }}>1. PROPERTY: </b>
                <span style={{ background: '#FFF3CD' }}>
                  Flat No. {builder.unit}, admeasuring 2,140 sq ft super built-up area on the
                </span> 15th floor of Block A of the project known as…
              </p>
              <p style={{ margin: '4px 0' }}>
                <b>2. CONSIDERATION: </b>
                The total agreed consideration is ₹2,18,50,000/- (Rupees Two Crore Eighteen Lakh Fifty Thousand only)…
              </p>
              <p style={{ margin: '4px 0' }}>
                <b>3. PAYMENT SCHEDULE: </b>
                As per the milestone-based payment plan attached hereto as Schedule A and as updated…
              </p>
            </div>
          </div>
        </div>
      </Card>

      {/* comments */}
      {!signed && (
        <Section label="Open clarifications" t={t}>
          <Card t={t} padding={0}>
            {[
              { clause: 'Clause 4.2 · Possession date', body: 'Please confirm "Dec 2027" includes grace period.', from: 'Arjun (buyer)', time: '2d', status: 'resolved' },
              { clause: 'Clause 7.1 · Maintenance', body: 'Maintenance start date needs to align with handover.', from: 'Arjun (buyer)', time: '2d', status: 'open' },
            ].map((c, i, arr) => (
              <div key={i} style={{
                padding: '12px 14px',
                borderBottom: i < arr.length - 1 ? `1px solid ${t.line}` : 'none',
              }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <span style={{ fontSize: 12, fontWeight: 700, color: t.ink }}>{c.clause}</span>
                  <Pill t={t} tone={c.status === 'resolved' ? 'ok' : 'warn'} variant="tint">
                    {c.status === 'resolved' ? 'Resolved' : 'Open'}
                  </Pill>
                </div>
                <div style={{ fontSize: 12.5, color: t.inkMute, marginTop: 4, lineHeight: 1.4 }}>{c.body}</div>
                <div style={{ fontSize: 11, color: t.inkFaint, marginTop: 4 }}>{c.from} · {c.time} ago</div>
              </div>
            ))}
          </Card>
        </Section>
      )}

      <div style={{ display: 'flex', gap: 8 }}>
        <Button t={t} variant="secondary" icon="chat" onClick={() => {}}>Comment</Button>
        {!signed ? (
          <Button t={t} variant="primary" icon="check" onClick={() => setShowSign(true)}>
            Sign with DocuSign
          </Button>
        ) : (
          <Button t={t} variant="primary" icon="download" onClick={() => {}}>
            Signed copy
          </Button>
        )}
      </div>

      {/* sign sheet */}
      {showSign && (
        <div style={{
          position: 'absolute', inset: 0, background: 'rgba(11,18,40,0.45)', zIndex: 100,
          display: 'flex', alignItems: 'flex-end',
        }} onClick={() => setShowSign(false)}>
          <div onClick={(e) => e.stopPropagation()} style={{
            width: '100%', background: t.surface,
            borderRadius: '24px 24px 0 0',
            padding: '20px 18px 32px', display: 'flex', flexDirection: 'column', gap: 14,
            boxShadow: t.shadowLg,
          }}>
            <div style={{
              width: 36, height: 4, background: t.lineStrong, borderRadius: 999,
              alignSelf: 'center',
            }}/>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                width: 56, height: 56, borderRadius: '50%', background: t.accentSoft,
                color: t.accent, margin: '6px auto',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon name="lock" size={26} strokeWidth={2}/>
              </div>
              <div style={{ fontSize: 18, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>
                Sign the agreement
              </div>
              <div style={{ fontSize: 13, color: t.inkMute, marginTop: 4, lineHeight: 1.4, padding: '0 8px' }}>
                You'll be redirected to DocuSign to verify identity and apply your signature.
                Your signed copy will appear in Documents.
              </div>
            </div>
            <Button t={t} icon="key" onClick={() => setShowSign(false)}>Continue to DocuSign</Button>
            <Button t={t} variant="ghost" onClick={() => setShowSign(false)}>Not now</Button>
          </div>
        </div>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// UpdatesScreen — notifications feed
// ─────────────────────────────────────────────────────────────
function UpdatesScreen({ t }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 14, padding: '14px 16px 24px' }}>
      <div>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          Updates
        </div>
        <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, marginTop: 2, letterSpacing: -0.3 }}>
          Activity & alerts
        </div>
      </div>

      {/* group: Today */}
      {[
        { date: 'Today', items: UPDATES.slice(0, 1) },
        { date: 'This week', items: UPDATES.slice(1, 4) },
        { date: 'Earlier', items: UPDATES.slice(4) },
      ].map((g) => (
        <div key={g.date} style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <div style={{
            fontSize: 11, fontWeight: 600, color: t.inkFaint,
            letterSpacing: 0.5, textTransform: 'uppercase', paddingLeft: 4,
          }}>{g.date}</div>
          <Card t={t} padding={0}>
            {g.items.map((u, i) => (
              <div key={i} style={{
                display: 'flex', alignItems: 'flex-start', gap: 12,
                padding: '14px 14px',
                borderBottom: i < g.items.length - 1 ? `1px solid ${t.line}` : 'none',
              }}>
                <div style={{
                  width: 36, height: 36, borderRadius: 10,
                  background: t[`${u.tone}Soft`] || t.surfaceMute,
                  color: t[u.tone] || t.inkMute,
                  display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
                }}>
                  <Icon name={u.kind === 'payment' ? 'rupee' : u.kind === 'doc' ? 'doc' : u.kind === 'success' ? 'check' : 'bell'} size={18} strokeWidth={2}/>
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 14, fontWeight: 600, color: t.ink, lineHeight: 1.3 }}>{u.title}</div>
                  <div style={{ fontSize: 12.5, color: t.inkMute, marginTop: 2 }}>{u.body}</div>
                </div>
                <div style={{ fontSize: 11.5, color: t.inkFaint, fontVariantNumeric: 'tabular-nums' }}>{u.time}</div>
              </div>
            ))}
          </Card>
        </div>
      ))}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ProfileScreen — buyer profile + sales contact + settings
// ─────────────────────────────────────────────────────────────
function ProfileScreen({ t, builder, nav }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '14px 16px 24px' }}>
      {/* buyer card */}
      <Card t={t} padding={18}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
          <div style={{
            width: 62, height: 62, borderRadius: '50%', background: t.accentSoft,
            color: t.accent, display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontWeight: 700, fontSize: 22, letterSpacing: -0.5,
          }}>AR</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 18, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>
              {BUYER.name}
            </div>
            <div style={{ fontSize: 12.5, color: t.inkMute, marginTop: 2 }}>
              {BUYER.phone}
            </div>
            <div style={{ fontSize: 12.5, color: t.inkMute }}>
              {BUYER.email}
            </div>
          </div>
        </div>
      </Card>

      {/* sales rep */}
      <Section label="Your sales manager" t={t}>
        <Card t={t}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{
              width: 44, height: 44, borderRadius: '50%', background: t.surfaceMute,
              color: t.ink, display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontWeight: 700, fontSize: 16,
            }}>SK</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14.5, fontWeight: 700, color: t.ink }}>{SALES.name}</div>
              <div style={{ fontSize: 12.5, color: t.inkMute }}>{SALES.role} · {builder.name}</div>
            </div>
            <button style={{
              width: 38, height: 38, borderRadius: 10, background: t.accentSoft,
              color: t.accent, border: 'none', cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name="call" size={18}/>
            </button>
            <button style={{
              width: 38, height: 38, borderRadius: 10, background: t.accentSoft,
              color: t.accent, border: 'none', cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name="chat" size={18}/>
            </button>
          </div>
        </Card>
      </Section>

      {/* property card */}
      <Section label="Your property" t={t}>
        <Card t={t} padding={0}>
          {[
            { label: 'Project',  value: builder.project },
            { label: 'Unit',     value: builder.unit },
            { label: 'Typology', value: builder.typology },
            { label: 'RERA',     value: builder.rera },
            { label: 'Location', value: builder.location },
          ].map((r, i, arr) => (
            <div key={i} style={{
              display: 'flex', justifyContent: 'space-between',
              padding: '14px 16px',
              borderBottom: i < arr.length - 1 ? `1px solid ${t.line}` : 'none',
            }}>
              <span style={{ fontSize: 13, color: t.inkMute }}>{r.label}</span>
              <span style={{ fontSize: 13, fontWeight: 600, color: t.ink, fontFeatureSettings: '"tnum"' }}>{r.value}</span>
            </div>
          ))}
        </Card>
      </Section>

      {/* settings */}
      <Section label="App" t={t}>
        <Card t={t} padding={0}>
          {[
            { label: 'Support tickets',         icon: 'chat',   onClick: () => nav && nav('tickets') },
            { label: 'Home loan',                icon: 'key',    onClick: () => nav && nav('loan') },
            { label: 'Notifications',            icon: 'bell',   onClick: () => nav && nav('updates') },
            { label: 'Privacy & PII visibility', icon: 'shield', onClick: () => {} },
            { label: 'Sign out',                 icon: 'lock', tone: 'danger', onClick: () => {} },
          ].map((r, i, arr) => (
            <button key={i} onClick={r.onClick} style={{
              width: '100%', display: 'flex', alignItems: 'center', gap: 12,
              padding: '14px 16px', background: 'transparent', border: 'none', cursor: 'pointer',
              borderBottom: i < arr.length - 1 ? `1px solid ${t.line}` : 'none',
              textAlign: 'left',
            }}>
              <Icon name={r.icon} size={18} color={r.tone === 'danger' ? t.danger : t.inkMute}/>
              <span style={{ flex: 1, fontSize: 14, fontWeight: 500, color: r.tone === 'danger' ? t.danger : t.ink }}>
                {r.label}
              </span>
              <Icon name="chev" size={16} color={t.inkFaint}/>
            </button>
          ))}
        </Card>
      </Section>

      <div style={{ textAlign: 'center', padding: '8px 0' }}>
        <BBLockup color={t.inkFaint} size={12}/>
        <div style={{ fontSize: 11, color: t.inkFaint, marginTop: 6 }}>v1.0 · MVP build</div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// OnboardingScreen — phone OTP welcome flow (overlay)
// ─────────────────────────────────────────────────────────────
function OnboardingScreen({ t, builder, step, onAdvance, onSkip }) {
  // Step 0: welcome, 1: phone, 2: otp, 3: complete
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 50,
      background: t.bg,
      display: 'flex', flexDirection: 'column',
      padding: '64px 22px 28px',
    }}>
      {/* skip */}
      {step < 3 && (
        <button onClick={onSkip} style={{
          position: 'absolute', top: 60, right: 22, background: 'transparent',
          border: 'none', color: t.inkMute, fontSize: 13, fontWeight: 600, cursor: 'pointer',
        }}>Skip</button>
      )}

      {step === 0 && (
        <>
          <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <div style={{ textAlign: 'center' }}>
              <BBMark size={64} color={t.accent}/>
              <div style={{
                fontSize: 32, fontWeight: 700, color: t.ink,
                marginTop: 22, letterSpacing: -0.6, lineHeight: 1.1,
              }}>
                Welcome to<br/>BuilderBridge.
              </div>
              <div style={{
                fontSize: 15, color: t.inkMute, marginTop: 14,
                lineHeight: 1.5, maxWidth: 280, margin: '14px auto 0',
              }}>
                One trusted home for your booking, payments, agreement and construction journey.
              </div>
            </div>
          </div>
          <Button t={t} icon="chev" onClick={onAdvance}>Continue</Button>
          <div style={{
            fontSize: 11.5, color: t.inkFaint, textAlign: 'center', marginTop: 12,
          }}>
            <Icon name="shield" size={12} strokeWidth={2} style={{ verticalAlign: '-2px', marginRight: 4 }}/>
            All data encrypted · IT Act 2000 compliant
          </div>
        </>
      )}

      {step === 1 && (
        <>
          <div style={{ marginTop: 24 }}>
            <BBMark size={32} color={t.accent}/>
            <div style={{ fontSize: 24, fontWeight: 700, color: t.ink, marginTop: 24, letterSpacing: -0.4 }}>
              Your phone number
            </div>
            <div style={{ fontSize: 14, color: t.inkMute, marginTop: 6, lineHeight: 1.4 }}>
              We'll send a one-time code to verify your identity.
            </div>
          </div>
          <div style={{ marginTop: 30 }}>
            <div style={{
              display: 'flex', alignItems: 'center', gap: 10,
              padding: '14px 16px', background: t.surface, borderRadius: 12,
              border: `1px solid ${t.lineStrong}`,
            }}>
              <span style={{ fontSize: 17, fontWeight: 600, color: t.inkMute }}>+91</span>
              <div style={{ width: 1, height: 22, background: t.line }}/>
              <span style={{ fontSize: 17, fontWeight: 600, color: t.ink, fontFeatureSettings: '"tnum"' }}>
                98480 12211
              </span>
            </div>
          </div>
          <div style={{ flex: 1 }}/>
          <Button t={t} onClick={onAdvance}>Send OTP</Button>
        </>
      )}

      {step === 2 && (
        <>
          <div style={{ marginTop: 24 }}>
            <BBMark size={32} color={t.accent}/>
            <div style={{ fontSize: 24, fontWeight: 700, color: t.ink, marginTop: 24, letterSpacing: -0.4 }}>
              Enter the 6-digit code
            </div>
            <div style={{ fontSize: 14, color: t.inkMute, marginTop: 6, lineHeight: 1.4 }}>
              Sent to +91 98480 12211 · <span style={{ color: t.accent, fontWeight: 600 }}>Resend in 28s</span>
            </div>
          </div>
          <div style={{ marginTop: 30, display: 'flex', gap: 8, justifyContent: 'center' }}>
            {[4, 8, 2, 1, '', ''].map((d, i) => (
              <div key={i} style={{
                width: 44, height: 54, borderRadius: 12,
                background: t.surface,
                border: `1.5px solid ${i === 4 ? t.accent : t.lineStrong}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 22, fontWeight: 700, color: t.ink,
                fontFeatureSettings: '"tnum"',
                boxShadow: i === 4 ? `0 0 0 4px ${t.accentSoft}` : 'none',
              }}>{d}</div>
            ))}
          </div>
          <div style={{ flex: 1 }}/>
          <Button t={t} onClick={onAdvance}>Verify</Button>
        </>
      )}

      {step === 3 && (
        <>
          <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                width: 84, height: 84, borderRadius: '50%', background: t.accentSoft,
                color: t.accent, display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon name="check" size={42} strokeWidth={2.4}/>
              </div>
              <div style={{ fontSize: 28, fontWeight: 700, color: t.ink, marginTop: 20, letterSpacing: -0.5, lineHeight: 1.15 }}>
                You're all set,<br/>{BUYER.name.split(' ')[0]}.
              </div>
              <div style={{ fontSize: 14, color: t.inkMute, marginTop: 12, lineHeight: 1.5, maxWidth: 300, margin: '12px auto 0' }}>
                Your {builder.project} journey is live. {builder.name} sees the same view you do — full transparency, end to end.
              </div>
            </div>
          </div>
          <Button t={t} icon="home" onClick={onAdvance}>Open my dashboard</Button>
        </>
      )}
    </div>
  );
}

Object.assign(window, {
  HomeScreen, InventoryScreen, EstimateScreen, PaymentsScreen,
  DocumentsScreen, AOSScreen, UpdatesScreen, ProfileScreen,
  OnboardingScreen,
  JOURNEY_STEPS, MILESTONES, ESTIMATE, DOCUMENTS, UPDATES,
  BUYER, SALES,
});
