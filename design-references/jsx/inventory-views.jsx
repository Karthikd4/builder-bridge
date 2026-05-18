// inventory-views.jsx — Three views over the same tower data.
// TowerView, FloorView, GridView. All share a "unit click → onSelect" contract.

// ─────────────────────────────────────────────────────────────
// TowerView — the glance view. Vertical building shape, color = status.
// Best for "where am I?" and quick pattern recognition.
// ─────────────────────────────────────────────────────────────
function TowerView({ t, units, selected, onSelect, dimmedIds = null, density = 'comfortable' }) {
  const cellH = density === 'compact' ? 12 : density === 'dense' ? 9 : 16;
  const gap   = density === 'compact' ? 2 : density === 'dense' ? 1 : 3;
  const byFloor = {};
  units.forEach((u) => {
    if (!byFloor[u.floor]) byFloor[u.floor] = [];
    byFloor[u.floor].push(u);
  });
  // Build floors array top-down (highest first visually)
  const maxFloor = Math.max(...units.map((u) => u.floor), 22);
  const minFloor = Math.min(...units.map((u) => u.floor), 1);
  const floorIdxs = [];
  for (let f = maxFloor; f >= minFloor; f--) floorIdxs.push(f);

  return (
    <div style={{
      background: t.surfaceSunk, padding: 14, borderRadius: 14,
      border: `1px solid ${t.line}`,
    }}>
      <div style={{ display: 'flex', gap: 8 }}>
        {/* floor labels */}
        <div style={{
          width: 28, display: 'flex', flexDirection: 'column', gap,
          paddingTop: 1,
        }}>
          {floorIdxs.map((f) => {
            const showLabel = f === maxFloor || f === minFloor || f % 5 === 0 || f === selected?.floor;
            return (
              <div key={f} style={{
                height: cellH,
                fontSize: 9.5, fontWeight: 600,
                color: f === selected?.floor ? t.accent : t.inkFaint,
                fontFeatureSettings: '"tnum"',
                display: 'flex', alignItems: 'center', justifyContent: 'flex-end',
                paddingRight: 6,
              }}>
                {showLabel ? `F${f}` : ''}
              </div>
            );
          })}
          {/* ground */}
          <div style={{ height: 8 }}/>
        </div>
        {/* units */}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap }}>
          {floorIdxs.map((f) => {
            const row = (byFloor[f] || []).sort((a, b) => a.position - b.position);
            return (
              <div key={f} style={{ display: 'flex', gap }}>
                {row.map((u) => {
                  const s = STATUS[u.status];
                  const isSel = selected?.id === u.id;
                  const dimmed = dimmedIds && !dimmedIds.has(u.id);
                  return (
                    <button key={u.id} onClick={() => onSelect(u)} style={{
                      flex: 1, height: cellH, padding: 0,
                      border: `1px solid ${isSel ? t.accent : t.dark ? 'rgba(255,255,255,0.12)' : 'rgba(0,0,0,0.08)'}`,
                      background: isSel ? t.accent : s.color,
                      borderRadius: cellH >= 14 ? 3 : 2,
                      cursor: 'pointer', position: 'relative',
                      opacity: dimmed ? 0.12 : 1,
                      transition: 'opacity 120ms, box-shadow 120ms',
                      boxShadow: isSel ? `0 0 0 2px ${t.surfaceSunk}, 0 0 0 3px ${t.accent}` : 'none',
                    }} title={`${u.id} · ${u.type} · ${s.label}`}>
                      {u.isMine && (
                        <span style={{
                          position: 'absolute', top: -3, right: -3,
                          width: 6, height: 6, borderRadius: '50%',
                          background: t.accent, border: `1px solid ${t.surfaceSunk}`,
                        }}/>
                      )}
                    </button>
                  );
                })}
              </div>
            );
          })}
          {/* ground line */}
          <div style={{
            height: 6, background: t.lineStrong, borderRadius: 2, marginTop: 4,
          }}/>
          <div style={{
            display: 'flex', justifyContent: 'space-between', fontSize: 9.5,
            color: t.inkFaint, fontWeight: 600, paddingTop: 4, letterSpacing: 0.4,
          }}>
            <span>← WEST</span>
            <span>POOL VIEW ↓</span>
            <span>EAST →</span>
          </div>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// FloorView — one floor, top-down. Shows actual position layout.
// Best for "what does this floor look like?"
// ─────────────────────────────────────────────────────────────
function FloorView({ t, units, floor, onFloorChange, selected, onSelect, floorRange = [1, 22] }) {
  const floorUnits = units.filter((u) => u.floor === floor).sort((a, b) => a.position - b.position);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      {/* floor selector */}
      <div style={{
        display: 'flex', alignItems: 'center', gap: 10,
        padding: '10px 14px', background: t.surface, borderRadius: 10,
        border: `1px solid ${t.line}`,
      }}>
        <button onClick={() => onFloorChange(Math.max(floorRange[0], floor - 1))}
                disabled={floor <= floorRange[0]}
                style={iconBtn(t, floor <= floorRange[0])}>
          <Icon name="chev" size={14} style={{ transform: 'rotate(180deg)' }}/>
        </button>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 4 }}>
          <div style={{
            display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
          }}>
            <span style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, textTransform: 'uppercase', letterSpacing: 0.5 }}>
              Floor
            </span>
            <span style={{ fontSize: 11, color: t.inkFaint, fontFeatureSettings: '"tnum"' }}>
              {floor} / {floorRange[1]}
            </span>
          </div>
          <input type="range" min={floorRange[0]} max={floorRange[1]} value={floor}
                 onChange={(e) => onFloorChange(Number(e.target.value))}
                 style={{ width: '100%', accentColor: t.accent }}/>
        </div>
        <button onClick={() => onFloorChange(Math.min(floorRange[1], floor + 1))}
                disabled={floor >= floorRange[1]}
                style={iconBtn(t, floor >= floorRange[1])}>
          <Icon name="chev" size={14}/>
        </button>
      </div>

      {/* floor plate */}
      <div style={{
        background: t.surfaceSunk, padding: 24, borderRadius: 14,
        border: `1px solid ${t.line}`, position: 'relative',
      }}>
        {/* compass */}
        <div style={{
          position: 'absolute', top: 18, right: 18,
          width: 36, height: 36, borderRadius: '50%',
          border: `1px solid ${t.lineStrong}`, background: t.surface,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          flexDirection: 'column',
        }}>
          <svg width="24" height="24" viewBox="0 0 24 24">
            <path d="M12 4 L9 18 L12 14 L15 18 Z" fill={t.danger} />
            <text x="12" y="3" textAnchor="middle" fontSize="6" fill={t.inkMute} fontWeight="700">N</text>
          </svg>
        </div>

        {/* Floor label */}
        <div style={{
          position: 'absolute', top: 18, left: 22,
          fontSize: 13, fontWeight: 700, color: t.ink, letterSpacing: -0.2,
        }}>Floor {floor}</div>

        <svg viewBox="0 0 600 320" style={{ width: '100%', height: 'auto', marginTop: 20 }}>
          <defs>
            <pattern id={`fp-grid-${floor}`} width="20" height="20" patternUnits="userSpaceOnUse">
              <path d="M20 0H0V20" fill="none" stroke={t.lineStrong} strokeWidth="0.3"/>
            </pattern>
          </defs>
          <rect x="0" y="0" width="600" height="320" fill={`url(#fp-grid-${floor})`} opacity="0.5"/>

          {/* Central corridor */}
          <rect x="20" y="148" width="560" height="24" fill={t.surfaceMute} stroke={t.lineStrong} strokeWidth="0.8"/>
          <text x="300" y="164" textAnchor="middle" fontSize="9" fill={t.inkFaint} fontWeight="600" letterSpacing="2">CORRIDOR</text>
          {/* Lift core */}
          <rect x="265" y="148" width="70" height="24" fill={t.surfaceSunk} stroke={t.lineStrong} strokeWidth="0.8"/>
          <text x="300" y="164" textAnchor="middle" fontSize="8" fill={t.inkMute} fontWeight="700">LIFTS</text>

          {/* 4 units around the corridor — positions:
              p1 (top-left, west-corner)   p2 (top-right, east-corner)
              p3 (bot-left, west-corner)   p4 (bot-right, east-corner)
              Note: per data model, p1/p2 are east-facing; p3/p4 are west-facing.
              For visual clarity, lay them out as:
              ┌──────┬──────┐
              │  p1  │  p2  │  ← North side (East-facing in our data)
              ├──────┼──────┤  ← Corridor + lifts
              │  p3  │  p4  │  ← South side (West-facing)
              └──────┴──────┘
          */}
          {floorUnits.map((u) => {
            const layout = {
              1: { x: 20,  y: 20,  w: 280, h: 128 }, // top-left
              2: { x: 300, y: 20,  w: 280, h: 128 }, // top-right
              3: { x: 20,  y: 172, w: 280, h: 128 }, // bot-left
              4: { x: 300, y: 172, w: 280, h: 128 }, // bot-right
            }[u.position];
            const s = STATUS[u.status];
            const isSel = selected?.id === u.id;
            return (
              <FloorUnitShape key={u.id} t={t} u={u} s={s} isSel={isSel}
                              layout={layout} onSelect={onSelect}/>
            );
          })}
        </svg>
      </div>

      {/* facing legend */}
      <div style={{
        display: 'flex', justifyContent: 'space-between', padding: '0 14px',
        fontSize: 10.5, fontWeight: 700, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase',
      }}>
        <span>← WEST FACADE</span>
        <span>EAST FACADE →</span>
      </div>
    </div>
  );
}

function FloorUnitShape({ t, u, s, isSel, layout, onSelect }) {
  return (
    <g style={{ cursor: 'pointer' }} onClick={() => onSelect(u)}>
      <rect x={layout.x + 2} y={layout.y + 2}
            width={layout.w - 4} height={layout.h - 4}
            fill={t.dark ? s.softDark : s.soft}
            stroke={isSel ? t.accent : s.color}
            strokeWidth={isSel ? 3 : 1.5}
            rx="3"/>
      {/* Premium star for pool-view units */}
      {u.premium && (
        <circle cx={layout.x + layout.w - 14} cy={layout.y + 12} r="4"
                fill={s.color} opacity="0.85"/>
      )}
      {/* Unit number */}
      <text x={layout.x + 12} y={layout.y + 24} fontSize="14" fontWeight="700"
            fill={isSel ? t.accent : t.ink}
            fontFamily="Manrope, system-ui">{u.id}</text>
      {/* Type + sqft */}
      <text x={layout.x + 12} y={layout.y + 42} fontSize="11" fontWeight="600"
            fill={t.inkMute}>
        {u.type} · {u.sqft.toLocaleString('en-IN')} sq ft
      </text>
      {/* Status pill */}
      <rect x={layout.x + 12} y={layout.y + layout.h - 28}
            width="62" height="18" rx="9" fill={s.color}/>
      <text x={layout.x + 43} y={layout.y + layout.h - 15} textAnchor="middle"
            fontSize="9.5" fontWeight="700" fill="#fff" letterSpacing="0.4">
        {s.label.toUpperCase()}
      </text>
      {/* Facing + view */}
      <text x={layout.x + layout.w - 12} y={layout.y + layout.h - 14}
            textAnchor="end" fontSize="10" fill={t.inkFaint} fontWeight="600">
        {u.facing} · {u.view} view
      </text>
    </g>
  );
}

// ─────────────────────────────────────────────────────────────
// GridView — data-first matrix. Rows = floors, cols = positions.
// Best for "how does the whole project look?" at scale.
// Each cell shows unit id + type + status color.
// ─────────────────────────────────────────────────────────────
function GridView({ t, units, selected, onSelect, dimmedIds = null }) {
  const byFloor = {};
  units.forEach((u) => {
    if (!byFloor[u.floor]) byFloor[u.floor] = [];
    byFloor[u.floor].push(u);
  });
  const maxFloor = Math.max(...units.map((u) => u.floor), 22);
  const floorIdxs = [];
  for (let f = maxFloor; f >= 1; f--) floorIdxs.push(f);

  return (
    <div style={{
      background: t.surface, borderRadius: 14,
      border: `1px solid ${t.line}`, overflow: 'hidden',
    }}>
      {/* header */}
      <div style={{
        display: 'grid', gridTemplateColumns: '52px repeat(4, 1fr)',
        background: t.surfaceMute, padding: '8px 12px',
        borderBottom: `1px solid ${t.line}`,
        fontSize: 10.5, fontWeight: 700, color: t.inkFaint, letterSpacing: 0.6,
        textTransform: 'uppercase', gap: 6,
      }}>
        <div></div>
        {[
          { l: '2BHK · E', sub: 'Pool · Corner' },
          { l: '3BHK · E', sub: 'Pool · Inner' },
          { l: '3BHK · W', sub: 'City · Inner' },
          { l: '4BHK · W', sub: 'Sunset · Corner' },
        ].map((h, i) => (
          <div key={i} style={{ textAlign: 'center', lineHeight: 1.3 }}>
            <div>{h.l}</div>
            <div style={{ fontSize: 9.5, fontWeight: 500, textTransform: 'none', letterSpacing: 0, color: t.inkFaint }}>{h.sub}</div>
          </div>
        ))}
      </div>
      <div style={{ maxHeight: 460, overflowY: 'auto' }} className="hide-scroll">
        {floorIdxs.map((f) => {
          const row = (byFloor[f] || []).sort((a, b) => a.position - b.position);
          // Skip empty rows
          if (row.length === 0) return null;
          return (
            <div key={f} style={{
              display: 'grid', gridTemplateColumns: '52px repeat(4, 1fr)',
              gap: 6, padding: '6px 12px',
              borderBottom: `1px solid ${t.line}`,
              alignItems: 'center',
            }}>
              <div style={{
                fontSize: 11, fontWeight: 700, color: t.inkMute,
                fontFeatureSettings: '"tnum"', letterSpacing: 0.2,
              }}>F{String(f).padStart(2, '0')}</div>
              {[1,2,3,4].map((p) => {
                const u = row.find((x) => x.position === p);
                if (!u) return <div key={p}/>;
                const s = STATUS[u.status];
                const isSel = selected?.id === u.id;
                const dimmed = dimmedIds && !dimmedIds.has(u.id);
                return (
                  <button key={p} onClick={() => onSelect(u)} style={{
                    background: t.dark ? s.softDark : s.soft,
                    border: `1.5px solid ${isSel ? t.accent : s.color}`,
                    borderRadius: 6, padding: '6px 8px',
                    cursor: 'pointer', textAlign: 'left',
                    opacity: dimmed ? 0.18 : 1,
                    position: 'relative', minHeight: 38,
                    transition: 'opacity 120ms',
                  }}>
                    <div style={{
                      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                    }}>
                      <span style={{
                        fontSize: 12, fontWeight: 700, color: t.ink,
                        fontFeatureSettings: '"tnum"',
                      }}>{u.id}</span>
                      <span style={{
                        width: 8, height: 8, borderRadius: '50%', background: s.color,
                      }}/>
                    </div>
                    <div style={{
                      fontSize: 10, color: t.inkMute, marginTop: 2,
                      fontFeatureSettings: '"tnum"',
                    }}>
                      {s.label}
                      {u.isMine && <span style={{ color: t.accent, fontWeight: 700, marginLeft: 4 }}>• yours</span>}
                    </div>
                  </button>
                );
              })}
            </div>
          );
        })}
      </div>
    </div>
  );
}

function iconBtn(t, disabled) {
  return {
    width: 32, height: 32, borderRadius: 8,
    background: t.surfaceMute, border: 'none', cursor: disabled ? 'not-allowed' : 'pointer',
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    color: disabled ? t.inkFaint : t.ink,
    opacity: disabled ? 0.5 : 1,
  };
}

Object.assign(window, {
  TowerView, FloorView, FloorUnitShape, GridView, iconBtn,
});
