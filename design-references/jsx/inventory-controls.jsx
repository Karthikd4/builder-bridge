// inventory-controls.jsx — Filters, unit detail, comparison drawer, mode toggle.

// ─────────────────────────────────────────────────────────────
// FilterChips — horizontal scrollable bar for status. Each chip is a
// toggle. Used on mobile + as the top row on desktop.
// ─────────────────────────────────────────────────────────────
function StatusFilterChips({ t, filters, setFilters, counts }) {
  const order = ['available', 'reserved', 'booked', 'sold'];
  const toggle = (k) => {
    const arr = filters.status.includes(k)
      ? filters.status.filter((x) => x !== k)
      : [...filters.status, k];
    setFilters({ ...filters, status: arr });
  };
  return (
    <div style={{ display: 'flex', gap: 8, overflowX: 'auto', padding: 1 }} className="hide-scroll">
      {order.map((k) => {
        const s = STATUS[k];
        const on = filters.status.length === 0 || filters.status.includes(k);
        return (
          <button key={k} onClick={() => toggle(k)} style={{
            flexShrink: 0, display: 'inline-flex', alignItems: 'center', gap: 8,
            padding: '8px 12px 8px 10px', borderRadius: 999,
            border: `1px solid ${on ? s.color : t.line}`,
            background: on ? (t.dark ? s.softDark : s.soft) : t.surface,
            color: on ? s.color : t.inkFaint,
            cursor: 'pointer', fontSize: 12.5, fontWeight: 600,
            opacity: filters.status.length === 0 ? 0.85 : on ? 1 : 0.55,
          }}>
            <span style={{
              width: 9, height: 9, borderRadius: '50%', background: s.color,
              flexShrink: 0,
            }}/>
            {s.label}
            <span style={{
              fontSize: 11, fontWeight: 700, color: on ? s.color : t.inkFaint,
              padding: '1px 7px', borderRadius: 99,
              background: on ? (t.dark ? 'rgba(255,255,255,0.06)' : 'rgba(255,255,255,0.8)') : t.surfaceMute,
              fontFeatureSettings: '"tnum"',
            }}>{counts[k]}</span>
          </button>
        );
      })}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Multi-select chip group — used for facing, type
// ─────────────────────────────────────────────────────────────
function ChipGroup({ t, label, options, value, onChange }) {
  const toggle = (v) => {
    const arr = value.includes(v) ? value.filter((x) => x !== v) : [...value, v];
    onChange(arr);
  };
  const allOff = value.length === 0;
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
      <div style={{
        fontSize: 10.5, fontWeight: 700, color: t.inkFaint,
        letterSpacing: 0.5, textTransform: 'uppercase',
      }}>{label}</div>
      <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
        {options.map((opt) => {
          const v = typeof opt === 'object' ? opt.value : opt;
          const l = typeof opt === 'object' ? opt.label : opt;
          const on = value.includes(v);
          return (
            <button key={v} onClick={() => toggle(v)} style={{
              padding: '7px 12px', borderRadius: 8,
              border: `1px solid ${on ? t.accent : t.line}`,
              background: on ? t.accentSoft : t.surface,
              color: on ? t.accent : t.ink,
              cursor: 'pointer', fontSize: 12.5, fontWeight: 600,
              opacity: allOff ? 0.85 : on ? 1 : 0.5,
            }}>{l}</button>
          );
        })}
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// FloorRange slider — dual handles
// ─────────────────────────────────────────────────────────────
function FloorRange({ t, value, onChange, min = 1, max = 22 }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
      }}>
        <span style={{
          fontSize: 10.5, fontWeight: 700, color: t.inkFaint,
          letterSpacing: 0.5, textTransform: 'uppercase',
        }}>Floor range</span>
        <span style={{ fontSize: 12, fontWeight: 600, color: t.ink, fontFeatureSettings: '"tnum"' }}>
          F{value.min} – F{value.max}
        </span>
      </div>
      {/* Dual range, rendered as one track + 2 overlapping inputs */}
      <div style={{ position: 'relative', height: 22, padding: '8px 0' }}>
        <div style={{
          position: 'absolute', left: 0, right: 0, top: 12, height: 4,
          background: t.surfaceMute, borderRadius: 2,
        }}/>
        <div style={{
          position: 'absolute', top: 12, height: 4,
          left: `${((value.min - min) / (max - min)) * 100}%`,
          right: `${(1 - (value.max - min) / (max - min)) * 100}%`,
          background: t.accent, borderRadius: 2,
        }}/>
        <input type="range" min={min} max={max} value={value.min}
               onChange={(e) => onChange({ ...value, min: Math.min(Number(e.target.value), value.max) })}
               style={dualRangeStyle()}/>
        <input type="range" min={min} max={max} value={value.max}
               onChange={(e) => onChange({ ...value, max: Math.max(Number(e.target.value), value.min) })}
               style={dualRangeStyle()}/>
      </div>
    </div>
  );
}
function dualRangeStyle() {
  return {
    position: 'absolute', inset: 0,
    width: '100%', height: 22,
    margin: 0, padding: 0, background: 'transparent',
    appearance: 'none', WebkitAppearance: 'none',
    pointerEvents: 'none',
  };
}

// ─────────────────────────────────────────────────────────────
// Combined FilterPanel — used on desktop sidebar and mobile sheet
// ─────────────────────────────────────────────────────────────
function FilterPanel({ t, filters, setFilters, counts, compact = false }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: compact ? 16 : 22 }}>
      <ChipGroup t={t} label="Status"
        options={[
          { value: 'available', label: 'Available' },
          { value: 'reserved',  label: 'Reserved' },
          { value: 'booked',    label: 'Booked' },
          { value: 'sold',      label: 'Sold' },
        ]}
        value={filters.status}
        onChange={(v) => setFilters({ ...filters, status: v })}/>

      <ChipGroup t={t} label="Facing"
        options={['East', 'West']}
        value={filters.facing}
        onChange={(v) => setFilters({ ...filters, facing: v })}/>

      <ChipGroup t={t} label="Unit type"
        options={['2BHK', '3BHK', '4BHK']}
        value={filters.type}
        onChange={(v) => setFilters({ ...filters, type: v })}/>

      <FloorRange t={t}
        value={{ min: filters.floorMin, max: filters.floorMax }}
        onChange={(v) => setFilters({ ...filters, floorMin: v.min, floorMax: v.max })}/>

      <button onClick={() => setFilters({ ...EMPTY_FILTERS })}
              style={{
                alignSelf: 'flex-start',
                fontSize: 12, fontWeight: 600, color: t.accent,
                background: 'transparent', border: 'none', cursor: 'pointer',
                padding: '4px 0',
              }}>
        Reset filters
      </button>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// UnitDetailCard — the right-side / bottom-sheet detail. Adapts to mode.
// ─────────────────────────────────────────────────────────────
function UnitDetailCard({ t, unit, mode = 'buyer', onClose, onShortlist, isShortlisted, onAssign }) {
  if (!unit) {
    return (
      <div style={{
        padding: 32, border: `1px dashed ${t.lineStrong}`,
        borderRadius: 14, textAlign: 'center', color: t.inkFaint,
      }}>
        <Icon name="building" size={28} color={t.inkFaint} style={{ margin: '0 auto 10px' }}/>
        <div style={{ fontSize: 14, fontWeight: 600 }}>Select a unit</div>
        <div style={{ fontSize: 12, marginTop: 4, lineHeight: 1.4 }}>
          Tap a square on the tower or a row in the grid to see details.
        </div>
      </div>
    );
  }
  const s = STATUS[unit.status];
  return (
    <div style={{
      background: t.surface, borderRadius: 14, border: `1px solid ${t.line}`,
      overflow: 'hidden', display: 'flex', flexDirection: 'column',
    }}>
      {/* head with status band */}
      <div style={{
        backgroundColor: s.color,
        backgroundImage: `linear-gradient(135deg, ${s.color} 0%, ${darken(s.color, 0.2)} 100%)`,
        padding: '14px 16px', color: '#fff',
      }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between' }}>
          <div>
            <div style={{ fontSize: 10.5, fontWeight: 700, letterSpacing: 0.6, opacity: 0.85, textTransform: 'uppercase' }}>
              {s.label} {unit.isMine && '· Your booking'}
            </div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 4 }}>
              <span style={{ fontSize: 26, fontWeight: 700, letterSpacing: -0.5, lineHeight: 1 }}>
                {unit.id}
              </span>
              <span style={{ fontSize: 13, opacity: 0.85 }}>{unit.type}</span>
            </div>
            <div style={{ fontSize: 12, opacity: 0.85, marginTop: 4 }}>
              {unit.facing}-facing · {unit.view} view · {unit.corner ? 'Corner unit' : 'Inner unit'}
            </div>
          </div>
          {onClose && (
            <button onClick={onClose} style={{
              width: 28, height: 28, borderRadius: 8, background: 'rgba(255,255,255,0.18)',
              border: 'none', cursor: 'pointer', color: '#fff',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              backdropFilter: 'blur(6px)',
            }}>
              <Icon name="close" size={14} strokeWidth={2.4}/>
            </button>
          )}
        </div>
      </div>

      {/* facts */}
      <div style={{ padding: '14px 16px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {[
          { l: 'Carpet area',    v: `${Math.round(unit.sqft * 0.8).toLocaleString('en-IN')} sq ft` },
          { l: 'Built-up area',  v: `${unit.sqft.toLocaleString('en-IN')} sq ft` },
          { l: 'Floor',          v: `${unit.floor} of 22` },
          { l: 'Price per sq ft', v: formatINR(Math.round(unit.price / unit.sqft / 100) * 100) },
          { l: 'Indicative all-in', v: formatINR(unit.price), strong: true },
        ].map((r, i, arr) => (
          <div key={i} style={{
            display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
            paddingBottom: i === arr.length - 1 ? 0 : 10,
            borderBottom: i === arr.length - 1 ? 'none' : `1px solid ${t.line}`,
          }}>
            <span style={{ fontSize: 13, color: t.inkMute }}>{r.l}</span>
            <span style={{
              fontSize: r.strong ? 16 : 13, fontWeight: r.strong ? 700 : 600,
              color: t.ink, fontFeatureSettings: '"tnum"',
            }}>{r.v}</span>
          </div>
        ))}
      </div>

      {/* sales mode extras */}
      {mode === 'sales' && unit.status === 'reserved' && (
        <div style={{
          padding: '10px 16px 14px',
          background: t.warnSoft, borderTop: `1px solid ${t.line}`,
          fontSize: 12, color: t.inkMute, lineHeight: 1.5,
        }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: t.warn, letterSpacing: 0.5, textTransform: 'uppercase' }}>
            Reserved by lead
          </div>
          <div style={{ marginTop: 4, color: t.ink, fontWeight: 600 }}>Priya Reddy · 7-day hold</div>
          <div style={{ color: t.inkMute, fontSize: 11.5 }}>Expires 30 May · Sai Krishna owns</div>
        </div>
      )}

      {/* CTAs */}
      <div style={{
        padding: '12px 14px', borderTop: `1px solid ${t.line}`,
        display: 'flex', gap: 8,
      }}>
        {mode === 'buyer' ? (
          <>
            <Button t={t} variant="secondary" icon={isShortlisted ? 'check' : 'plus'}
                    onClick={() => onShortlist && onShortlist(unit)}
                    fullWidth={true}>
              {isShortlisted ? 'Shortlisted' : 'Shortlist'}
            </Button>
            {unit.status === 'available' && (
              <Button t={t} variant="primary" icon="pin"
                      onClick={() => {}} fullWidth={true}>
                Visit
              </Button>
            )}
          </>
        ) : (
          <>
            <Button t={t} variant="secondary" icon="user"
                    onClick={() => onAssign && onAssign(unit)}
                    fullWidth={true}>
              Assign lead
            </Button>
            <Button t={t} variant="primary" icon="hammer"
                    onClick={() => {}} fullWidth={true}>
              Change status
            </Button>
          </>
        )}
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ShortlistTray — bottom drawer with up to 3 shortlisted units (buyer mode)
// ─────────────────────────────────────────────────────────────
function ShortlistTray({ t, items, onRemove, onClear }) {
  if (items.length === 0) return null;
  return (
    <div style={{
      background: t.surface, borderRadius: 14,
      border: `1px solid ${t.line}`, overflow: 'hidden',
      boxShadow: t.shadow,
    }}>
      <div style={{
        padding: '10px 14px', borderBottom: `1px solid ${t.line}`,
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <span style={{ fontSize: 12, fontWeight: 700, color: t.ink, letterSpacing: -0.1 }}>
          Shortlist · {items.length}/3
        </span>
        <button onClick={onClear} style={{
          fontSize: 11, fontWeight: 600, color: t.inkFaint,
          background: 'transparent', border: 'none', cursor: 'pointer',
        }}>Clear</button>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 1, background: t.line }}>
        {[0, 1, 2].map((i) => {
          const u = items[i];
          if (!u) {
            return (
              <div key={i} style={{
                background: t.surfaceMute, padding: '12px 10px',
                fontSize: 11, color: t.inkFaint, textAlign: 'center', fontWeight: 600,
              }}>Empty slot</div>
            );
          }
          const s = STATUS[u.status];
          return (
            <div key={i} style={{
              background: t.surface, padding: '12px 10px', position: 'relative',
            }}>
              <button onClick={() => onRemove(u)} style={{
                position: 'absolute', top: 6, right: 6,
                width: 18, height: 18, borderRadius: 6,
                background: t.surfaceMute, border: 'none', cursor: 'pointer',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: t.inkMute,
              }}>
                <Icon name="close" size={11} strokeWidth={2.4}/>
              </button>
              <div style={{
                width: 6, height: 6, borderRadius: '50%', background: s.color,
                marginBottom: 6,
              }}/>
              <div style={{ fontSize: 13, fontWeight: 700, color: t.ink, fontFeatureSettings: '"tnum"' }}>
                {u.id}
              </div>
              <div style={{ fontSize: 10.5, color: t.inkMute }}>{u.type}</div>
              <div style={{ fontSize: 11, fontWeight: 700, color: t.ink, marginTop: 4, fontFeatureSettings: '"tnum"' }}>
                {formatINR(u.price)}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ModeToggle — swap between buyer and sales perspectives
// ─────────────────────────────────────────────────────────────
function ModeToggle({ t, mode, onChange }) {
  return (
    <div style={{
      display: 'inline-flex', padding: 3, background: t.surfaceMute,
      borderRadius: 10, position: 'relative',
    }}>
      {['buyer', 'sales'].map((m) => (
        <button key={m} onClick={() => onChange(m)} style={{
          padding: '7px 14px', border: 'none', cursor: 'pointer',
          background: mode === m ? t.surface : 'transparent',
          color: mode === m ? t.ink : t.inkMute,
          fontSize: 12.5, fontWeight: 600,
          borderRadius: 8, position: 'relative',
          boxShadow: mode === m ? '0 1px 3px rgba(0,0,0,0.08)' : 'none',
          letterSpacing: 0.1,
          textTransform: 'capitalize',
        }}>{m === 'buyer' ? '👤  Buyer' : '⚙  Sales'}</button>
      ))}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// ViewSwitcher — pick between tower / floor / grid
// ─────────────────────────────────────────────────────────────
function ViewSwitcher({ t, view, onChange }) {
  const items = [
    { k: 'tower',  l: 'Tower',  icon: 'building' },
    { k: 'floor',  l: 'Floor',  icon: 'layers' },
    { k: 'grid',   l: 'Grid',   icon: 'grid' },
  ];
  return (
    <div style={{
      display: 'inline-flex', padding: 3, background: t.surfaceMute,
      borderRadius: 10,
    }}>
      {items.map((it) => (
        <button key={it.k} onClick={() => onChange(it.k)} style={{
          padding: '7px 12px 7px 10px', display: 'inline-flex', alignItems: 'center', gap: 6,
          border: 'none', cursor: 'pointer',
          background: view === it.k ? t.surface : 'transparent',
          color: view === it.k ? t.ink : t.inkMute,
          fontSize: 12.5, fontWeight: 600, borderRadius: 8,
          boxShadow: view === it.k ? '0 1px 3px rgba(0,0,0,0.08)' : 'none',
        }}>
          <Icon name={it.icon} size={14}/>
          {it.l}
        </button>
      ))}
    </div>
  );
}

Object.assign(window, {
  StatusFilterChips, ChipGroup, FloorRange, FilterPanel,
  UnitDetailCard, ShortlistTray, ModeToggle, ViewSwitcher,
});
