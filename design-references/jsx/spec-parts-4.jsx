// spec-parts-4.jsx — Sections 07-09 of the BuilderBridge design spec.

// ─────────────────────────────────────────────────────────────
// 07 · Component library
// ─────────────────────────────────────────────────────────────
function SpecComponents({ t, builder }) {
  return (
    <SectionBlock divider
      kicker="07 · Component recommendations"
      title="A small, sturdy kit. Reused everywhere."
      lede="Twelve primitives carry the entire app. No exceptions — if a new pattern is needed, it gets added here first, then used."
    >
      <div style={{
        display: 'grid', gap: 18,
        gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
      }}>
        {/* Pills */}
        <CompCard label="Pill" sub="Status, category, count" notes="6 tones × 3 variants. 11.5px, 22px tall.">
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            <Pill t={t} tone="ok"    variant="tint"><Icon name="check" size={11} strokeWidth={2.5}/> Paid</Pill>
            <Pill t={t} tone="warn"  variant="tint">Due 28 May</Pill>
            <Pill t={t} tone="danger" variant="tint">Overdue</Pill>
            <Pill t={t} tone="info"  variant="tint">In review</Pill>
            <Pill t={t} tone="accent" variant="solid">Yours</Pill>
            <Pill t={t} tone="neutral" variant="line">Closed</Pill>
          </div>
        </CompCard>

        {/* Button */}
        <CompCard label="Button" sub="Primary, secondary, ghost" notes="48pt min height. Full-width default.">
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <Button t={t} icon="check">Pay ₹43.7 L</Button>
            <Button t={t} variant="secondary" icon="download">Download PDF</Button>
            <Button t={t} variant="ghost">Not now</Button>
          </div>
        </CompCard>

        {/* Avatar / brand */}
        <CompCard label="Brand mark" sub="Mark, wordmark, lockup" notes="One mark. Two pillars + arch.">
          <div style={{ display: 'flex', flexDirection: 'column', gap: 14, alignItems: 'flex-start' }}>
            <BBMark size={36} color="var(--accent)"/>
            <BBWordmark size={20} color="var(--ink)"/>
            <BBLockup size={14}/>
          </div>
        </CompCard>

        {/* Card */}
        <CompCard label="Card" sub="Neutral surface, hairline" notes="16pt radius, 18pt padding default.">
          <Card t={t} padding={14} style={{ width: '100%' }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: t.ink }}>Foundation milestone</div>
            <div style={{ fontSize: 12, color: t.inkMute, marginTop: 4 }}>₹43.70 L due 28 May</div>
          </Card>
        </CompCard>

        {/* Row */}
        <CompCard label="Row" sub="Label + value + optional sub" notes="Stat tables. Tabular numerals.">
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10, width: '100%' }}>
            <Row t={t} label="Agreed price" value="₹2.18 Cr" strong/>
            <Row t={t} label="Carpet area" value="1,720 sq ft"/>
            <Row t={t} label="Discount applied" sub="approved by Sai Krishna" value="−₹12.65 L"/>
          </div>
        </CompCard>

        {/* Section header */}
        <CompCard label="Section" sub="Label + optional action" notes="Uppercase tracking. Anchors blocks.">
          <Section t={t} label="Your journey" action="See all">
            <Card t={t} padding={12} style={{ width: '100%' }}>
              <div style={{ fontSize: 11, color: t.inkFaint }}>(content goes here)</div>
            </Card>
          </Section>
        </CompCard>

        {/* Timeline */}
        <CompCard label="Blueprint timeline" sub="Signature visual"
                  notes="Horizontal pier markers on a faint grid. Done filled, current ringed.">
          <div style={{ width: '100%' }}>
            <BlueprintTimeline t={t} steps={JOURNEY_STEPS.slice(0, 5)} currentIdx={3}/>
          </div>
        </CompCard>

        {/* Payment ring */}
        <CompCard label="Payment ring" sub="Signature visual" notes="Ring with milestone ticks colour-coded by status.">
          <div style={{ display: 'flex', justifyContent: 'center', padding: 6, width: '100%' }}>
            <PaymentRing t={t} milestones={MILESTONES} size={160}/>
          </div>
        </CompCard>

        {/* Top bar */}
        <CompCard label="Top bar" sub="Branded leading + title/sub + trailing"
                  notes="Adapts: builder mark on tab pages, back arrow on overlays.">
          <div style={{ width: '100%', border: '1px solid var(--line)', borderRadius: 10, overflow: 'hidden' }}>
            <TopBar t={t}
              leading={(
                <div style={{
                  width: 36, height: 36, borderRadius: 10, background: t.accent,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: '#fff', flexShrink: 0,
                }}><BBMark size={20} color="#fff"/></div>
              )}
              title={builder.project}
              subtitle={`${builder.location} · RERA`}
              trailing={(
                <div style={{
                  width: 36, height: 36, borderRadius: 10, background: t.surfaceMute,
                  display: 'flex', alignItems: 'center', justifyContent: 'center', color: t.ink,
                }}><Icon name="bell" size={18}/></div>
              )}
            />
          </div>
        </CompCard>

        {/* Bottom tabs */}
        <CompCard label="Bottom tabs" sub="Always-on, 5 destinations" notes="Active = brand accent; no badge clutter.">
          <div style={{ width: '100%', border: '1px solid var(--line)', borderRadius: 10, overflow: 'hidden' }}>
            <BottomTabs t={t} current="home" onChange={() => {}}/>
          </div>
        </CompCard>

        {/* Form field */}
        <CompCard label="Field" sub="Phone, OTP, search" notes="Big tap targets. Minimal typing.">
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8, width: '100%' }}>
            <div style={{
              display: 'flex', alignItems: 'center', gap: 10,
              padding: '12px 14px', background: t.surface, borderRadius: 12,
              border: `1px solid ${t.lineStrong}`,
            }}>
              <span style={{ fontSize: 15, fontWeight: 600, color: t.inkMute }}>+91</span>
              <div style={{ width: 1, height: 20, background: t.line }}/>
              <span style={{ fontSize: 15, fontWeight: 600, color: t.ink, fontFeatureSettings: '"tnum"' }}>
                98480 12211
              </span>
            </div>
            <div style={{ display: 'flex', gap: 6 }}>
              {[4, 8, 2, 1, '', ''].map((d, i) => (
                <div key={i} style={{
                  flex: 1, height: 42, borderRadius: 10,
                  background: t.surface,
                  border: `1.5px solid ${i === 4 ? t.accent : t.lineStrong}`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: 18, fontWeight: 700, color: t.ink,
                  fontFeatureSettings: '"tnum"',
                }}>{d}</div>
              ))}
            </div>
          </div>
        </CompCard>

        {/* Icon set */}
        <CompCard label="Icons" sub="Line, 24×24, currentColor" notes="One-line stroke set. Never a logo as icon.">
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(8, 1fr)', gap: 8 }}>
            {['home','receipt','folder','bell','user','rupee','shield','key',
              'doc','layers','call','chat','clock','eye','sparkle','lock'
            ].map((n) => (
              <div key={n} style={{
                aspectRatio: '1 / 1',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: t.inkMute, background: t.surfaceMute, borderRadius: 6,
              }}>
                <Icon name={n} size={18}/>
              </div>
            ))}
          </div>
        </CompCard>
      </div>
    </SectionBlock>
  );
}

function CompCard({ label, sub, notes, children }) {
  return (
    <div style={{
      background: 'var(--surface)', borderRadius: 16,
      border: '1px solid var(--line)', overflow: 'hidden',
      display: 'flex', flexDirection: 'column',
    }}>
      <div style={{ padding: '14px 16px', borderBottom: '1px solid var(--line)' }}>
        <div style={{ fontSize: 13.5, fontWeight: 700, color: 'var(--ink)', letterSpacing: -0.1 }}>{label}</div>
        <div style={{ fontSize: 11.5, color: 'var(--ink-mute)', marginTop: 2 }}>{sub}</div>
      </div>
      <div style={{
        flex: 1, padding: 16, background: 'var(--bg)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        minHeight: 110,
      }}>
        {children}
      </div>
      {notes && (
        <div style={{
          padding: '10px 16px', borderTop: '1px solid var(--line)',
          fontSize: 11.5, color: 'var(--ink-faint)', fontStyle: 'italic',
          lineHeight: 1.4,
        }}>{notes}</div>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// 08 · Mobile UX best practices
// ─────────────────────────────────────────────────────────────
function SpecUXPrinciples() {
  const items = [
    {
      title: 'Minimise typing. Always.',
      do: 'OTP, biometrics, pre-fill from sales CRM. Tap-to-select over type-to-input. Three-tap booking confirmations.',
      dont: 'Onboarding forms with 8 fields. Re-asking for the buyer\'s name on every screen.',
    },
    {
      title: 'Make money legible.',
      do: 'Indian numbering (lakhs, crores). Tabular numerals for every figure. Currency symbol always.',
      dont: '"21,850,000.00". Default Roboto digits where 1 and 7 collide.',
    },
    {
      title: 'Surface the next action.',
      do: 'One "Next up" card on Home. Stage-aware copy. A single primary CTA per screen.',
      dont: 'A long list of pending items. Five buttons of equal visual weight.',
    },
    {
      title: 'Timeline > status text.',
      do: 'Show milestones on a horizontal track. A glance answers "where am I?".',
      dont: '"Status: pending verification (step 4 of 9)". No buyer reads this.',
    },
    {
      title: 'Confidence through citation.',
      do: 'Every figure attributes its source — NEFT ref, approver name, version, timestamp.',
      dont: 'Unsourced totals. "Updated recently" without a date.',
    },
    {
      title: 'Documents are dwellings, not downloads.',
      do: 'In-app viewer first, with comments and version chips. Download is a side door.',
      dont: 'Forcing a PDF download to read the AOS. Buyers lose track of versions across email.',
    },
    {
      title: '44pt minimum hit targets.',
      do: 'Buttons, tappable rows, list items, tab targets all ≥ 44pt vertically. Comfortable thumb zones.',
      dont: '12pt action links buried mid-card. Two icons sharing 32pt.',
    },
    {
      title: 'Builder branding, not platform branding.',
      do: 'My Home or Aparna logo at the top of every screen. Their RERA number visible. Buyers trust their builder, not us.',
      dont: 'BuilderBridge wordmark louder than the builder\'s. Generic chrome.',
    },
    {
      title: 'Privacy is a toggle, not a policy.',
      do: 'Owner can hide name/family from co-owners. PII visibility settings front-and-centre in Profile.',
      dont: 'Burying privacy in legal copy. Defaulting to "share everything".',
    },
    {
      title: 'Notifications respect calendars.',
      do: 'SMS for payment dues > 7 days out. In-app + push at T-2. SMS at T-0 only for critical.',
      dont: 'A daily ping for the same upcoming milestone. Overdue alerts at 11pm.',
    },
    {
      title: 'Offline-friendly key surfaces.',
      do: 'Last-seen AOS, latest receipt, current payment schedule cached locally.',
      dont: 'A "no internet" page for the buyer who just wants to glance at their booking letter at a wedding.',
    },
    {
      title: 'Sales rep, one tap away.',
      do: 'Call + chat buttons in the Profile sales-rep card. Always reachable.',
      dont: 'Routing every question through a generic helpdesk form.',
    },
  ];
  return (
    <SectionBlock bg="var(--surface)"
      kicker="08 · Mobile UX best practices"
      title="Twelve rules to design by."
      lede="The previous sections describe what to build. This section is what to remember while building it. Each rule has a Do and a Don't — the second matters more than the first."
    >
      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: 14,
      }}>
        {items.map((p, i) => (
          <div key={i} style={{
            padding: 22, borderRadius: 14,
            background: 'var(--bg)', border: '1px solid var(--line)',
          }}>
            <div style={{ display: 'flex', alignItems: 'flex-start', gap: 10, marginBottom: 12 }}>
              <span className="mono" style={{
                fontSize: 11, fontWeight: 700, color: 'var(--accent)',
                background: 'var(--accent-soft)', padding: '2px 6px', borderRadius: 4,
                flexShrink: 0,
              }}>{String(i + 1).padStart(2, '0')}</span>
              <h3 style={{
                fontSize: 16, fontWeight: 700, margin: 0,
                color: 'var(--ink)', letterSpacing: -0.2, lineHeight: 1.3,
              }}>{p.title}</h3>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              <RuleLine kind="do" text={p.do}/>
              <RuleLine kind="dont" text={p.dont}/>
            </div>
          </div>
        ))}
      </div>
    </SectionBlock>
  );
}

function RuleLine({ kind, text }) {
  const ok = kind === 'do';
  return (
    <div style={{ display: 'flex', alignItems: 'flex-start', gap: 8 }}>
      <span style={{
        flexShrink: 0, marginTop: 1,
        width: 18, height: 18, borderRadius: '50%',
        background: ok ? 'var(--ok)' : 'var(--danger)',
        color: '#fff',
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        fontSize: 11, fontWeight: 800,
      }}>{ok ? '✓' : '✗'}</span>
      <span style={{
        fontSize: 12.5, lineHeight: 1.5, color: 'var(--ink-mute)',
      }}>
        <strong style={{ color: 'var(--ink)' }}>{ok ? 'Do · ' : "Don't · "}</strong>
        {text}
      </span>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────────────────────
function SpecFooter() {
  return (
    <footer style={{
      padding: '64px 0 56px', borderTop: '1px solid var(--line)',
      background: 'var(--bg)',
    }}>
      <Container>
        <div style={{
          display: 'flex', justifyContent: 'space-between', gap: 24, flexWrap: 'wrap',
        }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16, maxWidth: 380 }}>
            <BBLockup size={16}/>
            <p style={{ fontSize: 13.5, color: 'var(--ink-mute)', margin: 0, lineHeight: 1.5 }}>
              A Builder CRM + Buyer Transparency Platform for Hyderabad's residential developers.
              Phase 1 — pre-sales to Agreement of Sale.
            </p>
          </div>
          <div style={{ display: 'grid', gap: 24, gridTemplateColumns: '1fr 1fr' }}>
            <FooterCol title="Artefacts" links={[
              { l: 'Buyer prototype', href: 'BuilderBridge - Buyer App.html' },
              { l: 'All screens canvas', href: 'BuilderBridge - All Screens.html' },
            ]}/>
            <FooterCol title="Source documents" links={[
              { l: 'PRD · Phase 1', href: 'uploads/BuilderBridge_Phase1_PRD.docx' },
              { l: 'MVP sprint plan', href: 'uploads/mvp_sprint_plan.md' },
              { l: 'Overall phases', href: 'uploads/overall_project_phases.md' },
            ]}/>
          </div>
        </div>
        <div style={{
          marginTop: 48, paddingTop: 22, borderTop: '1px solid var(--line)',
          fontSize: 12, color: 'var(--ink-faint)',
          display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap',
        }}>
          <span>Design specification · v1.0 · May 2026</span>
          <span className="mono">Confidential · For internal review</span>
        </div>
      </Container>
    </footer>
  );
}

function FooterCol({ title, links }) {
  return (
    <div>
      <div className="mono" style={{
        fontSize: 11, fontWeight: 700, letterSpacing: 0.6,
        color: 'var(--ink-faint)', textTransform: 'uppercase', marginBottom: 12,
      }}>{title}</div>
      <ul style={{ margin: 0, padding: 0, listStyle: 'none', display: 'flex', flexDirection: 'column', gap: 8 }}>
        {links.map((l) => (
          <li key={l.l}>
            <a href={l.href} style={{
              fontSize: 13.5, color: 'var(--ink)', textDecoration: 'none',
              borderBottom: '1px solid var(--line)', paddingBottom: 1,
            }}>{l.l}</a>
          </li>
        ))}
      </ul>
    </div>
  );
}

Object.assign(window, {
  SpecComponents, CompCard, SpecUXPrinciples, RuleLine, SpecFooter, FooterCol,
});
