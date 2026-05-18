// spec-parts-2.jsx — Sections 04-09 of the BuilderBridge design spec.
// Loaded after spec-parts.jsx — relies on Container, SectionBlock etc.

// ─────────────────────────────────────────────────────────────
// User Journeys — 3 horizontal swimlanes
// ─────────────────────────────────────────────────────────────
const JOURNEYS = [
  {
    id: 'enquiry-to-token',
    persona: 'Priya & Vivek · prospective buyers',
    title: 'Enquiry to token',
    timing: 'Day 0 → Day 18 typical',
    color: 'var(--accent)',
    quote: '"We saw the project on Sunday. Token by Friday. The app held our nerve."',
    steps: [
      { t: 'Submit enquiry',    s: 'Website form / referral', screen: 'Sales side', actor: 'sales' },
      { t: 'Onboard via SMS',   s: 'Phone OTP · 30 sec',       screen: 'OTP',         actor: 'buyer' },
      { t: 'Schedule visit',    s: 'Pick date / slot',         screen: 'Home · Prospect', actor: 'buyer' },
      { t: 'On-site walk',      s: 'Karthik Rao escorts',      screen: 'In person',   actor: 'sales' },
      { t: 'Browse inventory',  s: 'Tower elevation grid',     screen: 'Inventory',   actor: 'buyer' },
      { t: 'Get cost estimate', s: 'Itemised PDF, v1',         screen: 'Estimate',    actor: 'sales' },
      { t: 'Negotiate',         s: 'v2 with discount',         screen: 'Estimate',    actor: 'both' },
      { t: 'Pay token',         s: 'NEFT confirmation',        screen: 'Payments',    actor: 'buyer' },
    ],
  },
  {
    id: 'booking-to-aos',
    persona: 'Arjun Reddy · token holder',
    title: 'Token to signed AOS',
    timing: 'Day 18 → Day 35 typical',
    color: 'var(--warn)',
    quote: '"Lawyer flagged clause 7.1. I commented in the app. Done in 48 hours."',
    steps: [
      { t: 'Booking confirmed', s: 'Letter generated',         screen: 'Home',        actor: 'system' },
      { t: 'AOS draft v1',      s: 'Builder uploads',          screen: 'AOS',         actor: 'sales' },
      { t: 'Read & comment',    s: 'Flag clauses 4.2, 7.1',    screen: 'AOS · Review', actor: 'buyer' },
      { t: 'Revised draft v2',  s: 'Builder addresses',        screen: 'AOS',         actor: 'sales' },
      { t: 'Approve',           s: 'Buyer signs off',          screen: 'AOS · Review', actor: 'buyer' },
      { t: 'DocuSign',          s: 'Aadhaar eSign',            screen: 'AOS · Sign',  actor: 'buyer' },
      { t: 'Archive final',     s: 'Signed copy in vault',     screen: 'Documents',   actor: 'system' },
    ],
  },
  {
    id: 'construction',
    persona: 'Sneha Patel · agreement holder',
    title: 'Through construction to keys',
    timing: 'Day 35 → handover (~18 months)',
    color: 'var(--ok)',
    quote: '"Monthly slab updates. Two clicks to see what my money built."',
    steps: [
      { t: 'Foundation due',    s: '6-day reminder',           screen: 'Updates',     actor: 'system' },
      { t: 'Pay milestone',     s: 'NEFT · receipt back',      screen: 'Payments',    actor: 'buyer' },
      { t: 'Loan disbursement', s: 'HDFC releases tranche',    screen: 'Loan',        actor: 'bank' },
      { t: 'Construction photo', s: '6th-floor slab cast',     screen: 'Updates',     actor: 'sales' },
      { t: 'Raise ticket',      s: 'Pool view clarification',  screen: 'Support',     actor: 'buyer' },
      { t: 'Resolve · SLA-met', s: 'Sai Krishna replies',      screen: 'Support',     actor: 'sales' },
      { t: 'Snag walk',         s: '2 weeks pre-handover',     screen: 'Future scope', actor: 'both' },
      { t: 'Registration',      s: 'Date slot booked',         screen: 'Future scope', actor: 'system' },
      { t: 'Handover',          s: 'Keys, snag, clubhouse',    screen: 'Future scope', actor: 'system' },
    ],
  },
];

function ActorBadge({ actor }) {
  const m = {
    buyer:  { l: 'Buyer',   c: 'var(--accent)' },
    sales:  { l: 'Sales',   c: 'var(--warn)' },
    system: { l: 'Auto',    c: 'var(--ink-mute)' },
    bank:   { l: 'Bank',    c: '#7A5AE0' },
    both:   { l: 'Both',    c: '#1A8597' },
  }[actor] || { l: 'Other', c: 'var(--ink-faint)' };
  return (
    <span className="mono" style={{
      fontSize: 9.5, fontWeight: 700, letterSpacing: 0.6, textTransform: 'uppercase',
      padding: '2px 6px', borderRadius: 4,
      background: m.c, color: '#fff', flexShrink: 0,
    }}>{m.l}</span>
  );
}

function SpecJourneys() {
  return (
    <SectionBlock divider bg="var(--surface)"
      kicker="03 · User journeys"
      title="Three buyers. Eighteen months. One app."
      lede="From the buyer's first call to handover day, the flat-purchase lifecycle spans most of a year and a half. We've mapped three representative journeys; every screen in the IA exists because one of them needs it."
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: 32 }}>
        {JOURNEYS.map((j, ji) => (
          <div key={j.id} style={{
            padding: 28, borderRadius: 18,
            background: 'var(--surface-mute)', border: '1px solid var(--line)',
          }}>
            <div style={{
              display: 'flex', alignItems: 'flex-start', gap: 24,
              marginBottom: 24, flexWrap: 'wrap',
            }}>
              <div style={{ flex: 1, minWidth: 240 }}>
                <div className="mono" style={{
                  fontSize: 11, fontWeight: 700, letterSpacing: 0.8,
                  textTransform: 'uppercase', color: j.color,
                }}>Journey 0{ji + 1} · {j.timing}</div>
                <h3 className="serif" style={{
                  fontSize: 32, fontWeight: 500, margin: '8px 0 4px',
                  color: 'var(--ink)', letterSpacing: -0.6,
                }}>{j.title}</h3>
                <div style={{ fontSize: 13, color: 'var(--ink-mute)', fontWeight: 500 }}>
                  {j.persona}
                </div>
              </div>
              <div style={{
                maxWidth: 420, padding: '14px 18px',
                background: 'var(--surface)', borderRadius: 12,
                borderLeft: `3px solid ${j.color}`,
              }}>
                <p className="serif" style={{
                  fontSize: 15, fontStyle: 'italic', color: 'var(--ink)',
                  margin: 0, lineHeight: 1.5, textWrap: 'pretty',
                }}>{j.quote}</p>
              </div>
            </div>

            {/* swimlane */}
            <div style={{
              display: 'flex', overflowX: 'auto', paddingBottom: 8,
            }} className="hide-scroll">
              {j.steps.map((step, i) => (
                <div key={i} style={{
                  display: 'flex', alignItems: 'stretch', flexShrink: 0,
                }}>
                  {/* connector before */}
                  {i > 0 && (
                    <div style={{
                      width: 24, display: 'flex', alignItems: 'center', justifyContent: 'center',
                    }}>
                      <svg width="24" height="2"><line x1="0" y1="1" x2="24" y2="1"
                        stroke="var(--line-strong)" strokeWidth="1.5" strokeDasharray="3 3"/></svg>
                    </div>
                  )}
                  <div style={{
                    width: 160, padding: 14, borderRadius: 10,
                    background: 'var(--surface)', border: '1px solid var(--line)',
                    display: 'flex', flexDirection: 'column', gap: 6,
                  }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 6, justifyContent: 'space-between' }}>
                      <span className="mono" style={{
                        fontSize: 10, fontWeight: 700, color: 'var(--ink-faint)',
                      }}>{String(i + 1).padStart(2, '0')}</span>
                      <ActorBadge actor={step.actor}/>
                    </div>
                    <div style={{
                      fontSize: 13.5, fontWeight: 700, color: 'var(--ink)',
                      letterSpacing: -0.1, lineHeight: 1.25,
                    }}>{step.t}</div>
                    <div style={{
                      fontSize: 11.5, color: 'var(--ink-mute)', lineHeight: 1.35,
                    }}>{step.s}</div>
                    <div className="mono" style={{
                      fontSize: 10, fontWeight: 600, color: 'var(--accent)',
                      marginTop: 2, paddingTop: 6, borderTop: '1px dashed var(--line)',
                    }}>{step.screen}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </SectionBlock>
  );
}

// ─────────────────────────────────────────────────────────────
// Screen hierarchy — sitemap with live mini previews
// ─────────────────────────────────────────────────────────────
function SpecHierarchy({ t, builder }) {
  const groups = [
    {
      title: 'Auth flow',
      sub: 'One-time. After this the buyer lives in the tab world.',
      screens: [
        { id: 'splash', label: 'Welcome', mode: 'onb', step: 0 },
        { id: 'phone',  label: 'Phone',   mode: 'onb', step: 1 },
        { id: 'otp',    label: 'OTP',     mode: 'onb', step: 2 },
        { id: 'done',   label: 'Ready',   mode: 'onb', step: 3 },
      ],
    },
    {
      title: 'Tab landings',
      sub: 'The 5 destinations of the bottom bar — the entire app, two taps away.',
      screens: [
        { id: 'home',      label: 'Home',      tab: 'home' },
        { id: 'payments',  label: 'Payments',  tab: 'payments' },
        { id: 'documents', label: 'Documents', tab: 'documents' },
        { id: 'updates',   label: 'Updates',   tab: 'updates' },
        { id: 'profile',   label: 'Profile',   tab: 'profile' },
      ],
    },
    {
      title: 'Push / overlay screens',
      sub: 'Reached via cards on Home or rows in Payments / Profile. Always have a back button.',
      screens: [
        { id: 'unit',      label: 'Unit detail',   overlay: 'unit' },
        { id: 'inventory', label: 'Inventory',     overlay: 'inventory' },
        { id: 'estimate',  label: 'Cost estimate', overlay: 'estimate' },
        { id: 'aos',       label: 'AOS viewer',    overlay: 'aos' },
        { id: 'receipts',  label: 'Receipts',      overlay: 'receipts' },
        { id: 'loan',      label: 'Loan',          overlay: 'loan' },
        { id: 'tickets',   label: 'Support',       overlay: 'tickets' },
      ],
    },
  ];

  return (
    <SectionBlock
      kicker="04 · Screen hierarchy"
      title="Every screen, at a glance."
      lede="Auth on top. Five tab landings in the middle. Seven overlay screens reachable from contextual entry points. Thirteen surfaces in total — fewer than most banking apps, more than most concierge apps."
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: 56 }}>
        {groups.map((g) => (
          <div key={g.title}>
            <div style={{ marginBottom: 18, maxWidth: 720 }}>
              <h3 className="serif" style={{
                fontSize: 24, fontWeight: 500, margin: 0, color: 'var(--ink)', letterSpacing: -0.3,
              }}>{g.title}</h3>
              <p style={{ fontSize: 14, color: 'var(--ink-mute)', margin: '6px 0 0', lineHeight: 1.5 }}>
                {g.sub}
              </p>
            </div>
            <div style={{
              display: 'grid',
              gridTemplateColumns: `repeat(auto-fill, minmax(220px, 1fr))`,
              gap: 16,
            }}>
              {g.screens.map((s) => (
                <ScreenThumb key={s.id} t={t} builder={builder} screen={s}/>
              ))}
            </div>
          </div>
        ))}
      </div>
    </SectionBlock>
  );
}

// Renders a tiny preview of the screen content (no device chrome, just the surface).
function ScreenThumb({ t, builder, screen }) {
  const stage = 'signed';
  let body;
  if (screen.mode === 'onb') {
    body = (
      <div style={{ position: 'relative', width: '100%', height: '100%', background: t.bg }}>
        <OnboardingScreen t={t} builder={builder} step={screen.step}
                          onAdvance={() => {}} onSkip={() => {}}/>
      </div>
    );
  } else if (screen.overlay === 'unit')      body = <UnitDetailScreen t={t} builder={builder} nav={() => {}}/>;
  else if (screen.overlay === 'inventory')   body = <InventoryScreen t={t} builder={builder} nav={() => {}}/>;
  else if (screen.overlay === 'estimate')    body = <EstimateScreen t={t} builder={builder}/>;
  else if (screen.overlay === 'aos')         body = <AOSScreen t={t} builder={builder} stage={stage} nav={() => {}}/>;
  else if (screen.overlay === 'receipts')    body = <ReceiptsScreen t={t}/>;
  else if (screen.overlay === 'loan')        body = <LoanScreen t={t} builder={builder}/>;
  else if (screen.overlay === 'tickets')     body = <TicketsScreen t={t}/>;
  else if (screen.tab === 'home')            body = <HomeScreen t={t} builder={builder} stage={stage} nav={() => {}}/>;
  else if (screen.tab === 'payments')        body = <PaymentsScreen t={t} builder={builder} nav={() => {}}/>;
  else if (screen.tab === 'documents')       body = <DocumentsScreen t={t} builder={builder} nav={() => {}}/>;
  else if (screen.tab === 'updates')         body = <UpdatesScreen t={t}/>;
  else if (screen.tab === 'profile')         body = <ProfileScreen t={t} builder={builder} nav={() => {}}/>;

  const W = 402, H = 874, scale = 0.4;
  return (
    <div style={{
      background: 'var(--surface)', borderRadius: 14,
      border: '1px solid var(--line)', overflow: 'hidden',
      display: 'flex', flexDirection: 'column',
    }}>
      <div style={{
        width: '100%', height: H * scale,
        background: t.bg, overflow: 'hidden', position: 'relative',
      }}>
        <div style={{
          width: W, height: H,
          transform: `scale(${scale})`, transformOrigin: 'top left',
          color: t.ink, overflow: 'hidden',
        }}>
          {body}
        </div>
      </div>
      <div style={{ padding: '10px 12px 12px', borderTop: '1px solid var(--line)' }}>
        <div style={{
          fontSize: 13.5, fontWeight: 700, color: 'var(--ink)', letterSpacing: -0.1,
        }}>{screen.label}</div>
        <div className="mono" style={{ fontSize: 10, color: 'var(--ink-faint)', marginTop: 2, letterSpacing: 0.3 }}>
          {screen.mode === 'onb' ? `auth/${screen.id}`
           : screen.overlay ? `overlay/${screen.overlay}`
           : `tab/${screen.tab}`}
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { JOURNEYS, ActorBadge, SpecJourneys, SpecHierarchy, ScreenThumb });
