// inventory-spec-2.jsx — Sections 03-05 of the inventory spec doc.

// ─────────────────────────────────────────────────────────────
// Section 3: Filter & interaction model
// ─────────────────────────────────────────────────────────────
function InvFiltersDoc({ t }) {
  const [filters, setFilters] = React.useState({ ...EMPTY_FILTERS, status: ['available'] });
  const counts = countByStatus(ALL_UNITS);
  const filtered = applyFilters(ALL_UNITS, filters);

  return (
    <SectionBlock divider
      kicker="03 · Filter model"
      title="Four facets, three contexts."
      lede="Buyers compose; sales filters. Both need the same four facets — status, facing, type, floor range — surfaced in shapes that suit the surface. We use chips, sidebars, and sheets, never more."
    >
      <div style={{
        display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 28,
        marginBottom: 32,
      }}>
        {/* Left: live filter panel */}
        <div style={{
          padding: 24, borderRadius: 16,
          background: 'var(--surface)', border: '1px solid var(--line)',
        }}>
          <div style={{
            fontSize: 11, fontWeight: 700, color: 'var(--accent)',
            letterSpacing: 0.6, textTransform: 'uppercase', marginBottom: 10,
          }} className="mono">Try it</div>
          <FilterPanel t={t} filters={filters} setFilters={setFilters} counts={counts}/>
          <div style={{
            marginTop: 18, paddingTop: 14, borderTop: '1px solid var(--line)',
            fontSize: 13, color: 'var(--ink-mute)',
          }}>
            <span>Matching </span>
            <span className="mono" style={{ color: 'var(--ink)', fontWeight: 700 }}>{filtered.length}</span>
            <span> of {ALL_UNITS.length} units</span>
          </div>
        </div>

        {/* Right: explanation */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          {[
            {
              t: 'Status — the headline filter',
              s: 'Buyers default to "available". Sales default to all. Multi-select; chip stripe collapses to a horizontal scroll on mobile. The count badge on each chip is the second most-glanced number after the unit price.',
            },
            {
              t: 'Facing — east or west',
              s: 'Most Hyderabad buyers care deeply about facing for Vastu and morning light. We treat it as a first-class filter, not a sort.',
            },
            {
              t: 'Unit type — 2/3/4 BHK',
              s: 'Tied to the tower\'s position pattern. Selecting a type implicitly reveals which positions in the floor plan match.',
            },
            {
              t: 'Floor range — dual slider',
              s: 'Higher floors mean view; lower means quick stair access. Dual handles let buyers express both ends of their preference in one gesture.',
            },
          ].map((f, i) => (
            <div key={i} style={{
              padding: 16, borderRadius: 12,
              background: 'var(--bg)', border: '1px solid var(--line)',
            }}>
              <div style={{ fontSize: 13.5, fontWeight: 700, color: 'var(--ink)' }}>{f.t}</div>
              <div style={{ fontSize: 12.5, color: 'var(--ink-mute)', marginTop: 4, lineHeight: 1.5 }}>{f.s}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Filter surfaces */}
      <div>
        <h3 className="serif" style={{
          fontSize: 24, fontWeight: 500, color: 'var(--ink)', letterSpacing: -0.3,
          margin: '0 0 14px',
        }}>Where filters live, per surface</h3>
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: 12,
        }}>
          {[
            { c: 'Desktop sales', p: 'Persistent left sidebar', l: '260px wide. Always open. State persists.',  color: 'var(--accent)' },
            { c: 'Desktop buyer', p: 'Top chip bar + sidebar',  l: 'Status chips above the canvas. Other facets in sidebar.', color: 'var(--ok)' },
            { c: 'Mobile (both)', p: 'Chip strip + sheet',       l: 'Status chips visible at top. "More filters" opens a bottom sheet.', color: 'var(--warn)' },
          ].map((c, i) => (
            <div key={i} style={{
              padding: 16, borderRadius: 12,
              background: 'var(--surface)', border: '1px solid var(--line)',
              display: 'flex', flexDirection: 'column', gap: 6,
            }}>
              <div style={{
                fontSize: 11, fontWeight: 700, color: c.color,
                letterSpacing: 0.4, textTransform: 'uppercase',
              }} className="mono">{c.c}</div>
              <div style={{ fontSize: 15, fontWeight: 700, color: 'var(--ink)' }}>{c.p}</div>
              <div style={{ fontSize: 12, color: 'var(--ink-mute)', lineHeight: 1.5 }}>{c.l}</div>
            </div>
          ))}
        </div>
      </div>
    </SectionBlock>
  );
}

// ─────────────────────────────────────────────────────────────
// Section 4: Interaction models — buyer vs sales
// ─────────────────────────────────────────────────────────────
function InvInteractionModels({ t }) {
  return (
    <SectionBlock bg="var(--surface)"
      kicker="04 · Interaction models"
      title="One canvas. Two ways to use it."
      lede="The same tower behaves like a shopping window for a buyer and a CRM for a sales manager. Both share the canvas and palette; only the right rail and the verbs change."
    >
      <div style={{
        display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24,
      }}>
        {[
          {
            role: 'Buyer',
            tone: 'var(--accent)',
            tagline: 'Find a flat. Shortlist it. Tell sales when you want to visit.',
            actions: [
              { v: 'Filter', s: 'Compose facets to narrow 88 → ~6 units. The rest dim, never disappear — buyers see what they\'re ruling out.' },
              { v: 'Tap to inspect', s: 'A half-sheet rises with status, area, price, and view. Closes with a swipe down or backdrop tap.' },
              { v: 'Shortlist up to 3', s: 'Tray sticks to the bottom of the screen showing the three slots. Crucially: ask the buyer to choose, not to add infinitely.' },
              { v: 'Request a visit', s: 'Single CTA on available units. Pre-fills the unit; buyer only picks a date.' },
            ],
            quote: '"We had narrowed it to 1502 and 1602 the night before. The Sunday morning visit was 20 minutes — we already knew which we wanted."',
          },
          {
            role: 'Sales',
            tone: 'var(--warn)',
            tagline: 'See pipeline pressure at a glance. Change status with a tap. Assign leads.',
            actions: [
              { v: 'Scan the tower', s: 'The default tower view is itself a dashboard — color density across floors tells you which blocks are stuck.' },
              { v: 'Bulk select', s: 'Shift-drag in grid view marks multiple units. Status change applies to all. Audit logged.' },
              { v: 'Change status', s: 'Available → Reserved → Booked → Sold is a one-step button per unit. Backward transitions require a reason note.' },
              { v: 'Assign lead', s: 'Reserved + Booked carry the buyer name in the unit detail. Pipeline panel shows next-best leads for similar units.' },
            ],
            quote: '"Sai opens it at 9am. He can see what closed overnight, what\'s warm, what\'s gone cold. Used to take 40 minutes of WhatsApp."',
          },
        ].map((m) => (
          <div key={m.role} style={{
            padding: 28, borderRadius: 18,
            background: 'var(--bg)', border: `1px solid var(--line)`,
            borderTop: `4px solid ${m.tone}`,
            display: 'flex', flexDirection: 'column', gap: 14,
          }}>
            <div style={{
              display: 'flex', alignItems: 'center', gap: 10,
            }}>
              <div style={{
                width: 40, height: 40, borderRadius: 10, background: m.tone,
                color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                <Icon name={m.role === 'Buyer' ? 'user' : 'building'} size={20} strokeWidth={2}/>
              </div>
              <div>
                <div className="mono" style={{
                  fontSize: 11, fontWeight: 700, color: m.tone,
                  letterSpacing: 0.5, textTransform: 'uppercase',
                }}>{m.role} mode</div>
                <h3 className="serif" style={{
                  fontSize: 22, fontWeight: 500, color: 'var(--ink)',
                  margin: 0, letterSpacing: -0.3,
                }}>{m.tagline}</h3>
              </div>
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {m.actions.map((a, i) => (
                <div key={i} style={{
                  display: 'flex', gap: 12, alignItems: 'flex-start',
                  padding: '12px 14px', background: 'var(--surface)',
                  borderRadius: 10, border: '1px solid var(--line)',
                }}>
                  <span className="mono" style={{
                    fontSize: 10, fontWeight: 700, color: m.tone, letterSpacing: 0.6,
                    minWidth: 14,
                  }}>0{i+1}</span>
                  <div>
                    <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--ink)' }}>{a.v}</div>
                    <div style={{ fontSize: 12, color: 'var(--ink-mute)', marginTop: 3, lineHeight: 1.5 }}>{a.s}</div>
                  </div>
                </div>
              ))}
            </div>
            <p className="serif" style={{
              fontSize: 14, fontStyle: 'italic', color: 'var(--ink-mute)',
              padding: '12px 16px', borderLeft: `3px solid ${m.tone}`,
              margin: '4px 0 0', lineHeight: 1.5, textWrap: 'pretty',
            }}>{m.quote}</p>
          </div>
        ))}
      </div>

      {/* difference table */}
      <div style={{
        marginTop: 36, padding: 24, borderRadius: 14,
        background: 'var(--bg)', border: '1px solid var(--line)',
      }}>
        <h3 className="serif" style={{
          fontSize: 22, fontWeight: 500, color: 'var(--ink)',
          margin: '0 0 12px', letterSpacing: -0.3,
        }}>What changes between the modes</h3>
        <div style={{
          display: 'grid',
          gridTemplateColumns: '1.4fr 1fr 1fr',
          fontSize: 13, color: 'var(--ink)',
        }}>
          <div style={{ fontWeight: 700, padding: '10px 12px', borderBottom: '1px solid var(--line)' }}></div>
          <div style={{ fontWeight: 700, padding: '10px 12px', borderBottom: '1px solid var(--line)', color: 'var(--accent)' }}>Buyer</div>
          <div style={{ fontWeight: 700, padding: '10px 12px', borderBottom: '1px solid var(--line)', color: 'var(--warn)' }}>Sales</div>
          {[
            ['Default filter',           'Status = Available',           'No status filter applied'],
            ['Default view',             'Tower elevation',              'Tower elevation'],
            ['Right-rail extras',        'Shortlist tray (up to 3)',     'Lead pipeline for selected unit'],
            ['Primary CTA on available', 'Request a site visit',         'Mark as reserved'],
            ['Visible to user',          'Status colors + price ranges', '+ buyer names · token dates · SLAs'],
            ['Bulk operations',          'None',                         'Shift-drag select + change status'],
            ['Audit trail',              'Read-only',                    'Every status change logged'],
          ].map((row, i) => row.map((c, j) => (
            <div key={`${i}-${j}`} style={{
              padding: '10px 12px',
              borderBottom: i < 6 ? '1px solid var(--line)' : 'none',
              color: j === 0 ? 'var(--ink-mute)' : 'var(--ink)',
              fontWeight: j === 0 ? 500 : 500,
            }}>{c}</div>
          )))}
        </div>
      </div>
    </SectionBlock>
  );
}

Object.assign(window, { InvFiltersDoc, InvInteractionModels });
