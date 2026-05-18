// ui.jsx — Shared UI primitives for BuilderBridge. Pure presentational pieces.

// ─────────────────────────────────────────────────────────────
// Icon — line, 24x24, currentColor. Pulled from a curated set.
// Names mapped to inline path strings so we don't pull in icon font.
// ─────────────────────────────────────────────────────────────
const ICONS = {
  home:     'M3 12 12 4l9 8M5 10v9a1 1 0 0 0 1 1h4v-6h4v6h4a1 1 0 0 0 1-1v-9',
  receipt:  'M6 3h12v18l-3-2-3 2-3-2-3 2V3zM9 8h6M9 12h6M9 16h4',
  folder:   'M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7z',
  bell:     'M6 8a6 6 0 0 1 12 0v5l2 3H4l2-3V8zM10 19a2 2 0 0 0 4 0',
  user:     'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 21a8 8 0 0 1 16 0',
  back:     'M15 5l-7 7 7 7',
  chev:     'M9 6l6 6-6 6',
  chevDown: 'M6 9l6 6 6-6',
  close:    'M6 6l12 12M18 6L6 18',
  check:    'M5 12l5 5L20 7',
  plus:     'M12 5v14M5 12h14',
  download: 'M12 4v12m0 0-4-4m4 4 4-4M5 20h14',
  filter:   'M4 6h16M7 12h10M10 18h4',
  search:   'M11 4a7 7 0 1 0 0 14 7 7 0 0 0 0-14zm5.5 12L21 20',
  building: 'M5 21V5a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v16M9 8h2M9 12h2M9 16h2M13 8h2M13 12h2M13 16h2M3 21h18',
  doc:      'M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9l-6-6zM14 3v6h6M9 13h6M9 17h4',
  rupee:    'M6 4h12M6 8h12M9 4c3 0 4 1 4 3s-1 3-4 3H6l7 10',
  pin:      'M12 21s7-7 7-12a7 7 0 0 0-14 0c0 5 7 12 7 12zM12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6z',
  clock:    'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7v5l3 2',
  shield:   'M12 3 4 6v6c0 5 3.5 8 8 9 4.5-1 8-4 8-9V6l-8-3zM9 12l2 2 4-4',
  key:      'M14 3a5 5 0 1 0-4.6 7L4 14.4V20h5.5l.6-.6V18h2v-2h2v-2.6L14 13a5 5 0 0 0 0-10z',
  layers:   'M12 3 2 8l10 5 10-5-10-5zM2 16l10 5 10-5M2 12l10 5 10-5',
  call:     'M5 4h4l2 5-2 1a11 11 0 0 0 5 5l1-2 5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z',
  chat:     'M4 5h16v11H8l-4 4V5z',
  send:     'M3 20l18-8L3 4l3 8-3 8zM6 12h6',
  eye:      'M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12zM12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6z',
  grid:     'M4 4h7v7H4zM13 4h7v7h-7zM4 13h7v7H4zM13 13h7v7h-7z',
  hammer:   'M14 4 9 9l2 2 5-5M11 11l-7 7 2 2 7-7M14 4l3-1 4 4-1 3',
  sparkle:  'M12 3v6m0 6v6M3 12h6m6 0h6M6 6l3 3m6 6 3 3M18 6l-3 3m-6 6-3 3',
  lock:     'M6 11V8a6 6 0 0 1 12 0v3M5 11h14v9H5z',
  print:    'M6 9V3h12v6M6 18H4v-7h16v7h-2M6 14h12v7H6z',
  share:    'M16 6l-4-4-4 4M12 2v13M5 10v10h14V10',
  qr:       'M3 3h7v7H3zM14 3h7v7h-7zM3 14h7v7H3zM14 14h3v3h-3zM20 14v3M14 20h3M17 17h3',
};

function Icon({ name, size = 20, color = 'currentColor', strokeWidth = 1.6, style }) {
  const d = ICONS[name];
  if (!d) return null;
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none"
         style={{ flexShrink: 0, ...style }} aria-hidden="true">
      <path d={d} stroke={color} strokeWidth={strokeWidth}
            strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// Pill — status / category. Variant: solid | tint | line.
// ─────────────────────────────────────────────────────────────
function Pill({ children, variant = 'tint', tone = 'info', t, style }) {
  const map = {
    info:    { bg: t.infoSoft,   fg: t.info,   line: t.info },
    ok:      { bg: t.okSoft,     fg: t.ok,     line: t.ok },
    warn:    { bg: t.warnSoft,   fg: t.warn,   line: t.warn },
    danger:  { bg: t.dangerSoft, fg: t.danger, line: t.danger },
    neutral: { bg: t.surfaceMute, fg: t.inkMute, line: t.lineStrong },
    accent:  { bg: t.accentSoft, fg: t.accent, line: t.accent },
  }[tone];
  const css = {
    solid: { background: map.fg, color: t.dark ? '#0B1228' : '#fff' },
    tint:  { background: map.bg, color: map.fg },
    line:  { background: 'transparent', color: map.fg, border: `1px solid ${map.line}` },
  }[variant];
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 5,
      height: 22, padding: '0 8px', borderRadius: 999,
      fontSize: 11.5, fontWeight: 600, letterSpacing: 0.02,
      whiteSpace: 'nowrap',
      ...css, ...style,
    }}>{children}</span>
  );
}

// ─────────────────────────────────────────────────────────────
// Card — neutral surface with hairline. compact=less padding.
// ─────────────────────────────────────────────────────────────
function Card({ children, t, padding = 18, style }) {
  return (
    <div style={{
      background: t.surface, borderRadius: 16,
      border: `1px solid ${t.line}`,
      padding, boxShadow: t.shadow,
      ...style,
    }}>{children}</div>
  );
}

// ─────────────────────────────────────────────────────────────
// Section — labeled block with optional action.
// ─────────────────────────────────────────────────────────────
function Section({ label, action, children, t, style }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 10, ...style }}>
      {(label || action) && (
        <div style={{
          display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
          padding: '0 4px',
        }}>
          <div style={{
            fontSize: 12, fontWeight: 600, letterSpacing: 0.7,
            textTransform: 'uppercase', color: t.inkFaint,
          }}>{label}</div>
          {action && (
            <div style={{ fontSize: 13, fontWeight: 500, color: t.accent }}>{action}</div>
          )}
        </div>
      )}
      {children}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Button — primary | secondary | ghost. Full-width by default.
// ─────────────────────────────────────────────────────────────
function Button({ children, variant = 'primary', icon, t, fullWidth = true, onClick, style }) {
  const css = {
    primary:   { background: t.accent, color: t.accentInk, border: '1px solid transparent' },
    secondary: { background: t.surface, color: t.ink, border: `1px solid ${t.lineStrong}` },
    ghost:     { background: 'transparent', color: t.accent, border: '1px solid transparent' },
  }[variant];
  return (
    <button onClick={onClick} style={{
      width: fullWidth ? '100%' : undefined,
      minHeight: 48, padding: '0 18px', borderRadius: 12,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      fontFamily: 'inherit', fontSize: 15, fontWeight: 600, letterSpacing: -0.1,
      cursor: 'pointer',
      ...css, ...style,
    }}>
      {icon && <Icon name={icon} size={18} />}
      {children}
    </button>
  );
}

// ─────────────────────────────────────────────────────────────
// Blueprint Timeline — the signature visual. Horizontal scrollable
// row of milestone "piers". Done piers are filled, current pulses,
// upcoming are dashed. Subtle grid background evokes blueprint.
// ─────────────────────────────────────────────────────────────
function BlueprintTimeline({ steps, currentIdx, t }) {
  const cellW = 88;
  return (
    <div style={{
      position: 'relative',
      background: t.surfaceSunk,
      borderRadius: 14,
      padding: '20px 14px 16px',
      border: `1px solid ${t.line}`,
      overflow: 'hidden',
    }}>
      {/* blueprint grid background */}
      <svg width="100%" height="100%" style={{
        position: 'absolute', inset: 0, opacity: t.dark ? 0.18 : 0.35,
        pointerEvents: 'none',
      }}>
        <defs>
          <pattern id="bp-grid" width="14" height="14" patternUnits="userSpaceOnUse">
            <path d="M14 0H0V14" fill="none" stroke={t.lineStrong} strokeWidth="0.4"/>
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#bp-grid)"/>
      </svg>

      <div style={{
        position: 'relative', display: 'flex', overflowX: 'auto',
        scrollbarWidth: 'none', paddingBottom: 4,
      }} className="hide-scroll">
        {steps.map((s, i) => {
          const done = i < currentIdx;
          const current = i === currentIdx;
          const next = i === currentIdx + 1;
          const isLast = i === steps.length - 1;
          return (
            <div key={s.label} style={{
              minWidth: cellW, position: 'relative',
              display: 'flex', flexDirection: 'column', alignItems: 'center',
            }}>
              {/* connector to next */}
              {!isLast && (
                <div style={{
                  position: 'absolute', top: 16, left: '50%', width: cellW, height: 2,
                  background: done ? t.accent : t.lineStrong,
                  opacity: done ? 1 : 0.6,
                  zIndex: 0,
                }} />
              )}
              {/* pier (milestone marker) */}
              <div style={{
                width: 32, height: 32, borderRadius: '50%',
                background: done ? t.accent : (current ? t.surface : t.surfaceMute),
                border: `${current ? 2 : 1}px solid ${current ? t.accent : (done ? t.accent : t.lineStrong)}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                position: 'relative', zIndex: 1,
                boxShadow: current ? `0 0 0 4px ${t.accentSoft}` : 'none',
              }}>
                {done ? (
                  <Icon name="check" size={16} color={t.accentInk} strokeWidth={2.4} />
                ) : (
                  <span style={{
                    fontSize: 12, fontWeight: 700,
                    color: current ? t.accent : t.inkFaint,
                    fontFeatureSettings: '"tnum"',
                  }}>{i + 1}</span>
                )}
              </div>
              <div style={{
                marginTop: 8, fontSize: 11.5, fontWeight: current ? 700 : 500,
                color: done ? t.ink : (current ? t.ink : t.inkFaint),
                textAlign: 'center', letterSpacing: -0.1, lineHeight: 1.25,
              }}>{s.label}</div>
              {s.sub && (
                <div style={{
                  fontSize: 10.5, color: t.inkFaint, marginTop: 2,
                  textAlign: 'center',
                }}>{s.sub}</div>
              )}
            </div>
          );
        })}
      </div>
      <style>{`.hide-scroll::-webkit-scrollbar{display:none}`}</style>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Payment Ring — donut with milestone ticks around the perimeter.
// Distinctive: shows paid/agreed totals at centre, with ticks showing
// each milestone position (color-coded paid/upcoming/overdue).
// ─────────────────────────────────────────────────────────────
function PaymentRing({ size = 200, milestones, t }) {
  const stroke = 14;
  const r = (size - stroke) / 2 - 8;
  const c = 2 * Math.PI * r;

  const total = milestones.reduce((s, m) => s + m.amount, 0);
  const paid = milestones.filter((m) => m.status === 'paid').reduce((s, m) => s + m.amount, 0);
  const pct = paid / total;

  // ticks: position each milestone as a tick on outer ring
  let acc = 0;
  const ticks = milestones.map((m) => {
    const start = acc / total;
    acc += m.amount;
    const mid = (start + (m.amount / total) / 2) * 2 * Math.PI - Math.PI / 2;
    const x1 = size / 2 + (r + stroke / 2 + 3) * Math.cos(mid);
    const y1 = size / 2 + (r + stroke / 2 + 3) * Math.sin(mid);
    const x2 = size / 2 + (r + stroke / 2 + 10) * Math.cos(mid);
    const y2 = size / 2 + (r + stroke / 2 + 10) * Math.sin(mid);
    const color = m.status === 'paid' ? t.ok
                : m.status === 'overdue' ? t.danger
                : m.status === 'due' ? t.warn
                : t.inkFaint;
    return { ...m, x1, y1, x2, y2, color };
  });

  return (
    <div style={{ position: 'relative', width: size, height: size }}>
      <svg width={size} height={size}>
        {/* track */}
        <circle cx={size / 2} cy={size / 2} r={r}
                stroke={t.surfaceSunk} strokeWidth={stroke} fill="none" />
        {/* progress arc */}
        <circle cx={size / 2} cy={size / 2} r={r}
                stroke={t.accent} strokeWidth={stroke} fill="none"
                strokeDasharray={`${c * pct} ${c}`}
                strokeDashoffset={c / 4}
                transform={`rotate(-90 ${size / 2} ${size / 2})`}
                strokeLinecap="butt" />
        {/* milestone ticks */}
        {ticks.map((tk, i) => (
          <line key={i} x1={tk.x1} y1={tk.y1} x2={tk.x2} y2={tk.y2}
                stroke={tk.color} strokeWidth={2.4} strokeLinecap="round" />
        ))}
      </svg>
      <div style={{
        position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center', gap: 2,
      }}>
        <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
          Paid so far
        </div>
        <div style={{ fontSize: 26, fontWeight: 700, color: t.ink, letterSpacing: -0.5, fontFeatureSettings: '"tnum"' }}>
          {formatINR(paid)}
        </div>
        <div style={{ fontSize: 12, color: t.inkMute, fontFeatureSettings: '"tnum"' }}>
          of {formatINR(total)}
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Top bar — slim, with builder lockup on left, optional trailing.
// ─────────────────────────────────────────────────────────────
function TopBar({ t, leading, title, subtitle, trailing, back, onBack }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10,
      padding: '60px 18px 10px',     // 60px clears iOS status bar
      background: t.navBg,
      borderBottom: `1px solid ${t.line}`,
      backdropFilter: 'saturate(180%) blur(20px)',
      WebkitBackdropFilter: 'saturate(180%) blur(20px)',
    }}>
      {back && (
        <button onClick={onBack} style={{
          width: 36, height: 36, borderRadius: 10,
          background: t.surfaceMute, border: 'none', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          color: t.ink,
        }}>
          <Icon name="back" size={18} />
        </button>
      )}
      {leading}
      <div style={{ flex: 1, minWidth: 0 }}>
        {title && <div style={{
          fontSize: 16, fontWeight: 700, color: t.ink, letterSpacing: -0.2,
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
        }}>{title}</div>}
        {subtitle && <div style={{
          fontSize: 12, color: t.inkMute, marginTop: 1,
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
        }}>{subtitle}</div>}
      </div>
      {trailing}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Bottom tab bar — 5 tabs.
// ─────────────────────────────────────────────────────────────
function BottomTabs({ t, current, onChange }) {
  const tabs = [
    { key: 'home',      label: 'Home',      icon: 'home' },
    { key: 'payments',  label: 'Payments',  icon: 'rupee' },
    { key: 'documents', label: 'Documents', icon: 'folder' },
    { key: 'updates',   label: 'Updates',   icon: 'bell' },
    { key: 'profile',   label: 'Profile',   icon: 'user' },
  ];
  return (
    <div style={{
      display: 'flex', alignItems: 'stretch',
      background: t.navBg, borderTop: `1px solid ${t.line}`,
      backdropFilter: 'saturate(180%) blur(20px)',
      WebkitBackdropFilter: 'saturate(180%) blur(20px)',
      padding: '6px 6px 26px',
    }}>
      {tabs.map((tab) => {
        const active = current === tab.key;
        return (
          <button key={tab.key} onClick={() => onChange(tab.key)} style={{
            flex: 1, display: 'flex', flexDirection: 'column',
            alignItems: 'center', gap: 3, padding: '8px 4px 4px',
            background: 'transparent', border: 'none', cursor: 'pointer',
            color: active ? t.accent : t.inkFaint,
          }}>
            <Icon name={tab.icon} size={22} strokeWidth={active ? 2 : 1.6} />
            <span style={{
              fontSize: 10.5, fontWeight: active ? 700 : 500,
              letterSpacing: 0.1,
            }}>{tab.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Stat row — label + value, often used in lists like estimate breakdown.
// ─────────────────────────────────────────────────────────────
function Row({ label, value, sub, t, strong, style }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
      gap: 12, ...style,
    }}>
      <div style={{ minWidth: 0 }}>
        <div style={{
          fontSize: 14, fontWeight: strong ? 600 : 500,
          color: strong ? t.ink : t.inkMute,
        }}>{label}</div>
        {sub && <div style={{ fontSize: 12, color: t.inkFaint, marginTop: 1 }}>{sub}</div>}
      </div>
      <div style={{
        fontSize: strong ? 16 : 14, fontWeight: strong ? 700 : 600,
        color: t.ink, fontFeatureSettings: '"tnum"', letterSpacing: -0.1,
        whiteSpace: 'nowrap',
      }}>{value}</div>
    </div>
  );
}

Object.assign(window, {
  Icon, Pill, Card, Section, Button, BlueprintTimeline,
  PaymentRing, TopBar, BottomTabs, Row,
});
