// spec-parts.jsx — Sections of the BuilderBridge buyer app design spec.

// ─────────────────────────────────────────────────────────────
// Shared layout primitives
// ─────────────────────────────────────────────────────────────
function Container({ children, style }) {
  return (
    <div style={{
      maxWidth: 1180, margin: '0 auto', padding: '0 32px',
      ...style,
    }}>{children}</div>
  );
}

function SectionHeader({ kicker, title, lede }) {
  return (
    <div style={{ marginBottom: 40, maxWidth: 720 }}>
      <div className="mono" style={{
        fontSize: 12, fontWeight: 600, letterSpacing: 0.8,
        textTransform: 'uppercase', color: 'var(--accent)',
      }}>{kicker}</div>
      <h2 className="serif" style={{
        fontSize: 44, fontWeight: 500, color: 'var(--ink)',
        margin: '12px 0 12px', letterSpacing: -1, lineHeight: 1.05,
      }}>{title}</h2>
      {lede && <p style={{
        fontSize: 17, color: 'var(--ink-mute)', lineHeight: 1.55,
        margin: 0, textWrap: 'pretty',
      }}>{lede}</p>}
    </div>
  );
}

function SectionBlock({ kicker, title, lede, children, bg, divider }) {
  return (
    <section style={{
      padding: '110px 0 110px',
      background: bg || 'transparent',
      borderTop: divider ? '1px solid var(--line)' : 'none',
    }}>
      <Container>
        <SectionHeader kicker={kicker} title={title} lede={lede}/>
        {children}
      </Container>
    </section>
  );
}

// ─────────────────────────────────────────────────────────────
// Hero
// ─────────────────────────────────────────────────────────────
function SpecHero() {
  return (
    <section className="hero-grad" style={{
      paddingTop: 80, paddingBottom: 120,
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
            <a href="BuilderBridge - All Screens.html" style={{ color: 'inherit', textDecoration: 'none' }}>
              All screens canvas ›
            </a>
          </div>
        </div>

        <div className="mono" style={{
          fontSize: 12, fontWeight: 600, letterSpacing: 1,
          textTransform: 'uppercase', color: 'var(--accent)',
        }}>Buyer mobile app · Design specification · v1.0</div>

        <h1 className="serif" style={{
          fontSize: 88, fontWeight: 400, color: 'var(--ink)',
          margin: '20px 0 0', letterSpacing: -2.4, lineHeight: 1.0,
          maxWidth: 980, textWrap: 'balance',
        }}>
          Buying a flat,<br/>
          <span style={{ fontStyle: 'italic', color: 'var(--ink-mute)' }}>without the WhatsApp.</span>
        </h1>

        <p style={{
          fontSize: 19, color: 'var(--ink-mute)', lineHeight: 1.5,
          maxWidth: 720, margin: '32px 0 0', textWrap: 'pretty',
        }}>
          BuilderBridge gives buyers a single, secure place to track the months between booking
          and possession — payments, agreements, construction, the lot. This document is the
          strategic blueprint: how the app is organised, how buyers move through it, and what
          we put in front of them at every step.
        </p>

        <div style={{
          marginTop: 64, display: 'flex', flexWrap: 'wrap', gap: 14,
        }}>
          {[
            { k: '13', l: 'Buyer screens designed' },
            { k: '6', l: 'White-label builders' },
            { k: '5', l: 'Bottom-tab destinations' },
            { k: '6', l: 'Journey stages tracked' },
          ].map((s, i) => (
            <div key={i} style={{
              padding: '18px 22px', borderRadius: 14,
              background: 'var(--surface)', border: '1px solid var(--line)',
              minWidth: 180,
            }}>
              <div className="serif" style={{
                fontSize: 38, fontWeight: 500, color: 'var(--ink)',
                letterSpacing: -1, lineHeight: 1,
              }}>{s.k}</div>
              <div style={{ fontSize: 13, color: 'var(--ink-mute)', marginTop: 6 }}>{s.l}</div>
            </div>
          ))}
        </div>
      </Container>
    </section>
  );
}

// ─────────────────────────────────────────────────────────────
// Principles — Confident, Informed, Secure, Guided
// ─────────────────────────────────────────────────────────────
function SpecPrinciples() {
  const items = [
    {
      key: 'confident',
      title: 'Confident',
      lede: 'Every figure is sourced. Every status is dated. Nothing implied.',
      detail: 'Buyers face the largest cheque of their lives. The app earns trust by showing exactly who approved what, when. Cost estimates carry version chips. Payments carry NEFT references. Discounts carry approver names.',
      icon: 'shield',
    },
    {
      key: 'informed',
      title: 'Informed',
      lede: 'No buyer should ever call to ask "where are we now?"',
      detail: 'The home screen is a stage tracker. The next action is one tap. Construction milestones, AOS reviews, and payment dues are surfaced where the eye lands first, not buried in menus.',
      icon: 'eye',
    },
    {
      key: 'secure',
      title: 'Secure',
      lede: 'Family-grade documents deserve bank-grade handling.',
      detail: 'Phone OTP gates entry. Documents are watermarked in-app, not downloaded by default. PII visibility is buyer-controlled. The PRD\'s "IT Act 2000" line is the floor, not the goal.',
      icon: 'lock',
    },
    {
      key: 'guided',
      title: 'Guided',
      lede: 'The app names the next step in the buyer\'s own words.',
      detail: 'Stage-aware copy — "Review draft v2", "Pay foundation milestone", "Sign agreement". Never "you have 3 open items." The app behaves like a calm sales manager: one specific suggestion at a time.',
      icon: 'pin',
    },
  ];
  return (
    <SectionBlock divider
      kicker="01 · Product principles"
      title="The buyer should feel four things, in this order."
      lede="Every design decision in the spec below ladders up to one of these. If a screen makes a buyer feel less confident, less informed, less secure, or less guided, it is wrong."
    >
      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: 16,
      }}>
        {items.map((p, i) => (
          <div key={p.key} style={{
            padding: 28, borderRadius: 18, background: 'var(--surface)',
            border: '1px solid var(--line)',
            display: 'flex', flexDirection: 'column', gap: 14,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <div style={{
                width: 36, height: 36, borderRadius: 10, background: 'var(--accent-soft)',
                color: 'var(--accent)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon name={p.icon} size={20}/>
              </div>
              <div className="mono" style={{
                fontSize: 11, fontWeight: 600, letterSpacing: 0.6, color: 'var(--ink-faint)',
              }}>0{i + 1}</div>
            </div>
            <h3 className="serif" style={{
              fontSize: 28, fontWeight: 500, color: 'var(--ink)',
              margin: 0, letterSpacing: -0.5,
            }}>{p.title}</h3>
            <p style={{
              fontSize: 14.5, color: 'var(--ink)', fontWeight: 600, margin: 0,
              lineHeight: 1.4, textWrap: 'pretty',
            }}>{p.lede}</p>
            <p style={{
              fontSize: 13.5, color: 'var(--ink-mute)', margin: 0,
              lineHeight: 1.55, textWrap: 'pretty',
            }}>{p.detail}</p>
          </div>
        ))}
      </div>
    </SectionBlock>
  );
}

// ─────────────────────────────────────────────────────────────
// Information Architecture — tree diagram
// ─────────────────────────────────────────────────────────────
function SpecIA() {
  // Tree definition
  const tree = [
    { id: 'auth', label: 'Auth', kind: 'flow', items: [
      { id: 'welcome', label: 'Welcome / splash' },
      { id: 'phone',   label: 'Phone entry' },
      { id: 'otp',     label: 'OTP verify' },
      { id: 'done',    label: 'Account ready' },
    ]},
    { id: 'home', label: 'Home tab', kind: 'tab', primary: true, items: [
      { id: 'dashboard',  label: 'Dashboard', primary: true },
      { id: 'unitDetail', label: 'Unit detail' },
      { id: 'inventory',  label: 'Inventory grid' },
      { id: 'estimate',   label: 'Cost estimate' },
      { id: 'aos',        label: 'AOS viewer' },
    ]},
    { id: 'payments', label: 'Payments tab', kind: 'tab', items: [
      { id: 'schedule',  label: 'Schedule + ring', primary: true },
      { id: 'milestone', label: 'Milestone detail' },
      { id: 'receipts',  label: 'Receipts & invoices' },
      { id: 'loan',      label: 'Loan tracking' },
    ]},
    { id: 'docs', label: 'Documents tab', kind: 'tab', items: [
      { id: 'vault',  label: 'Vault (categorised)', primary: true },
      { id: 'viewer', label: 'PDF viewer + comments' },
      { id: 'signed', label: 'Signed AOS archive' },
    ]},
    { id: 'updates', label: 'Updates tab', kind: 'tab', items: [
      { id: 'feed',    label: 'Activity feed', primary: true },
      { id: 'tickets', label: 'Support tickets' },
      { id: 'ticketdetail', label: 'Ticket thread' },
    ]},
    { id: 'profile', label: 'Profile tab', kind: 'tab', items: [
      { id: 'me',       label: 'Profile + property', primary: true },
      { id: 'salesrep', label: 'Sales contact' },
      { id: 'settings', label: 'Settings / privacy' },
    ]},
  ];
  const kindStyle = (kind, primary) => kind === 'flow' ? {
    background: 'var(--warn)', color: '#fff',
  } : primary ? {
    background: 'var(--accent)', color: '#fff',
  } : {
    background: 'var(--surface)', color: 'var(--ink)', border: '1px solid var(--line)',
  };

  return (
    <SectionBlock
      kicker="02 · Information architecture"
      title="One auth flow. Five tabs. Thirteen destinations."
      lede="The buyer never has to remember a path. Auth is a one-time gate. The post-auth experience is a flat, 5-way split that maps to the four things a buyer actually thinks about — Home, Money, Paperwork, News, Me."
    >
      <div style={{
        background: 'var(--surface)', borderRadius: 18,
        border: '1px solid var(--line)', padding: 36, overflowX: 'auto',
      }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 18, minWidth: 980 }}>
          {/* Auth flow on top */}
          <IATreeRow
            stem={{ label: 'Auth gate', kind: 'flow' }}
            stemStyle={kindStyle('flow')}
            arrow={false}
            chips={tree[0].items}
            chipKind="flow"
          />
          <IADivider/>
          {/* App root */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{
              ...kindStyle('flow'),
              padding: '10px 16px', borderRadius: 10, fontWeight: 700, fontSize: 13,
            }}>BuilderBridge · App root</div>
            <div className="mono" style={{ fontSize: 11, color: 'var(--ink-faint)' }}>
              Bottom-tab container → 5 destinations
            </div>
          </div>
          {/* Tabs */}
          {tree.slice(1).map((tab) => (
            <IATreeRow key={tab.id}
              stem={{ label: tab.label, kind: tab.kind }}
              stemStyle={kindStyle(tab.kind, tab.primary)}
              arrow
              chips={tab.items}
              chipKind="screen"
            />
          ))}
        </div>
        {/* Legend */}
        <div style={{
          display: 'flex', gap: 16, paddingTop: 28, marginTop: 28,
          borderTop: '1px solid var(--line)', flexWrap: 'wrap',
        }}>
          {[
            { c: 'var(--warn)', t: '#fff', l: 'Auth flow (one-time)' },
            { c: 'var(--accent)', t: '#fff', l: 'Tab landing' },
            { c: 'var(--surface)', t: 'var(--ink)', l: 'Push / overlay screen', border: true },
          ].map((g, i) => (
            <div key={i} style={{ display: 'inline-flex', alignItems: 'center', gap: 8, fontSize: 12, color: 'var(--ink-mute)' }}>
              <span style={{
                width: 14, height: 14, borderRadius: 4, background: g.c,
                border: g.border ? '1px solid var(--line)' : 'none',
              }}/>
              {g.l}
            </div>
          ))}
        </div>
      </div>
    </SectionBlock>
  );
}

function IATreeRow({ stem, stemStyle, chips, chipKind, arrow }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
      <div style={{
        ...stemStyle,
        padding: '10px 14px', borderRadius: 10,
        fontSize: 12.5, fontWeight: 700, letterSpacing: 0.1,
        minWidth: 140, flexShrink: 0,
      }}>{stem.label}</div>
      {arrow && (
        <svg width="20" height="14" viewBox="0 0 20 14" style={{ flexShrink: 0 }}>
          <path d="M0 7h17m0 0l-5-5m5 5l-5 5" stroke="var(--line-strong)" strokeWidth="1.5"
                fill="none" strokeLinecap="round"/>
        </svg>
      )}
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        {chips.map((c) => (
          <span key={c.id} style={{
            padding: '8px 12px', borderRadius: 8,
            background: c.primary ? 'var(--accent-soft)' : 'var(--surface-mute)',
            color: c.primary ? 'var(--accent)' : 'var(--ink)',
            border: c.primary ? '1px solid var(--accent)' : '1px solid var(--line)',
            fontSize: 12.5, fontWeight: 500,
            display: 'inline-flex', alignItems: 'center', gap: 6,
          }}>
            {c.primary && <Icon name="home" size={12} strokeWidth={2}/>}
            {c.label}
          </span>
        ))}
      </div>
    </div>
  );
}
function IADivider() {
  return <div style={{ height: 1, background: 'var(--line)' }}/>;
}

Object.assign(window, {
  Container, SectionHeader, SectionBlock,
  SpecHero, SpecPrinciples, SpecIA,
  IATreeRow, IADivider,
});
