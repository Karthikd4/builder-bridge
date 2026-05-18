// inventory-explorer.jsx — Full inventory tool: view switcher, filters, detail.
// Used both as a desktop sales-team experience and as a mobile buyer experience.

function InventoryExplorer({ t, mode = 'buyer', setMode, layout = 'desktop', defaultView = 'tower' }) {
  const [view, setView] = React.useState(defaultView);
  const [filters, setFilters] = React.useState({ ...EMPTY_FILTERS });
  const [selected, setSelected] = React.useState(null);
  const [floor, setFloor] = React.useState(15);
  const [shortlist, setShortlist] = React.useState([]);
  const [filtersOpen, setFiltersOpen] = React.useState(false);

  const filtered = React.useMemo(() => applyFilters(ALL_UNITS, filters), [filters]);
  const counts = React.useMemo(() => countByStatus(ALL_UNITS), []);
  const filteredIds = React.useMemo(() => new Set(filtered.map((u) => u.id)), [filtered]);
  const filterCount = (filters.status.length + filters.facing.length + filters.type.length
                       + (filters.floorMin !== 1 ? 1 : 0) + (filters.floorMax !== 22 ? 1 : 0));

  const onShortlist = (u) => {
    if (shortlist.find((x) => x.id === u.id)) {
      setShortlist(shortlist.filter((x) => x.id !== u.id));
    } else if (shortlist.length < 3) {
      setShortlist([...shortlist, u]);
    }
  };
  const isShortlisted = selected && !!shortlist.find((x) => x.id === selected.id);

  // ─── DESKTOP LAYOUT ─────────────────────────────────────────
  if (layout === 'desktop') {
    return (
      <div style={{
        background: t.bg, color: t.ink, borderRadius: 16,
        border: `1px solid ${t.line}`, overflow: 'hidden',
        display: 'grid',
        gridTemplateColumns: '260px 1fr 320px',
        minHeight: 620,
      }}>
        {/* Left rail: filters */}
        <div style={{
          padding: 20, borderRight: `1px solid ${t.line}`,
          background: t.surface, overflowY: 'auto',
        }}>
          <div style={{ fontSize: 14, fontWeight: 700, color: t.ink, marginBottom: 16, letterSpacing: -0.1 }}>
            Filters {filterCount > 0 && <span style={{ color: t.accent, fontWeight: 700 }}>· {filterCount}</span>}
          </div>
          <FilterPanel t={t} filters={filters} setFilters={setFilters} counts={counts}/>
          <div style={{
            marginTop: 24, paddingTop: 16, borderTop: `1px solid ${t.line}`,
            fontSize: 11, color: t.inkFaint, lineHeight: 1.5,
          }}>
            <div style={{ fontWeight: 600, color: t.inkMute }}>
              Showing <span style={{ color: t.ink, fontWeight: 700 }}>{filtered.length}</span> of {ALL_UNITS.length} units
            </div>
            <div style={{ marginTop: 4 }}>
              {filtered.filter((u) => u.status === 'available').length} available · {filtered.filter((u) => u.status === 'reserved').length} reserved
            </div>
          </div>
        </div>

        {/* Main canvas */}
        <div style={{ padding: 20, overflowY: 'auto' }}>
          <div style={{
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            marginBottom: 16, gap: 12, flexWrap: 'wrap',
          }}>
            <div>
              <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
                {TOWER_CONFIG.project} · {TOWER_CONFIG.block}
              </div>
              <div style={{ fontSize: 18, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>
                Tower inventory · {ALL_UNITS.length} units
              </div>
            </div>
            <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
              {setMode && <ModeToggle t={t} mode={mode} onChange={setMode}/>}
              <ViewSwitcher t={t} view={view} onChange={setView}/>
            </div>
          </div>

          {view === 'tower' && (
            <TowerView t={t} units={ALL_UNITS} selected={selected}
              onSelect={setSelected}
              dimmedIds={filterCount > 0 ? filteredIds : null}/>
          )}
          {view === 'floor' && (
            <FloorView t={t} units={ALL_UNITS} floor={floor} onFloorChange={setFloor}
              selected={selected} onSelect={setSelected}
              floorRange={[Math.max(1, filters.floorMin), Math.min(22, filters.floorMax)]}/>
          )}
          {view === 'grid' && (
            <GridView t={t} units={ALL_UNITS} selected={selected}
              onSelect={setSelected}
              dimmedIds={filterCount > 0 ? filteredIds : null}/>
          )}

          {/* Legend strip */}
          <div style={{
            display: 'flex', gap: 16, marginTop: 14, flexWrap: 'wrap',
            padding: '12px 14px', background: t.surface, borderRadius: 10,
            border: `1px solid ${t.line}`,
          }}>
            {Object.keys(STATUS).map((k) => {
              const s = STATUS[k];
              return (
                <div key={k} style={{ display: 'inline-flex', alignItems: 'center', gap: 8, fontSize: 12 }}>
                  <span style={{ width: 12, height: 12, borderRadius: 3, background: s.color }}/>
                  <span style={{ color: t.ink, fontWeight: 600 }}>{s.label}</span>
                  <span style={{ color: t.inkFaint, fontFeatureSettings: '"tnum"' }}>{counts[k]}</span>
                </div>
              );
            })}
            <div style={{ flex: 1 }}/>
            <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8, fontSize: 12 }}>
              <span style={{
                width: 12, height: 12, borderRadius: 3, background: t.accent,
                boxShadow: `0 0 0 1.5px ${t.accent} inset`,
              }}/>
              <span style={{ color: t.ink, fontWeight: 600 }}>Selected</span>
            </div>
          </div>
        </div>

        {/* Right rail: detail + shortlist */}
        <div style={{
          padding: 20, borderLeft: `1px solid ${t.line}`,
          background: t.surface, display: 'flex', flexDirection: 'column', gap: 14,
          overflowY: 'auto',
        }}>
          <UnitDetailCard t={t} unit={selected} mode={mode}
            onShortlist={onShortlist} isShortlisted={isShortlisted}
            onClose={() => setSelected(null)}/>
          {mode === 'buyer' && <ShortlistTray t={t} items={shortlist}
            onRemove={(u) => setShortlist(shortlist.filter((x) => x.id !== u.id))}
            onClear={() => setShortlist([])}/>}
          {mode === 'sales' && selected && (
            <div style={{
              padding: 14, borderRadius: 12,
              background: t.surfaceMute, border: `1px solid ${t.line}`,
              fontSize: 12, color: t.inkMute, lineHeight: 1.5,
            }}>
              <div style={{ fontSize: 10.5, fontWeight: 700, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase', marginBottom: 6 }}>
                Pipeline
              </div>
              <div style={{ color: t.ink, fontWeight: 600 }}>3 leads enquired for similar units</div>
              <div style={{ marginTop: 4 }}>Last activity: Sai Krishna · 2h ago</div>
            </div>
          )}
        </div>
      </div>
    );
  }

  // ─── MOBILE LAYOUT ──────────────────────────────────────────
  // When embedded inside a host scroll container, fall back to natural
  // flow — the host already handles its own top bar + scrolling.
  if (layout === 'embedded') {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', gap: 14, padding: '14px 14px 100px', position: 'relative' }}>
        <div>
          <div style={{ fontSize: 11, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
            {TOWER_CONFIG.project} · {TOWER_CONFIG.block}
          </div>
          <div style={{
            display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
            marginTop: 2,
          }}>
            <div style={{ fontSize: 19, fontWeight: 700, color: t.ink, letterSpacing: -0.3 }}>
              Inventory · {filtered.length}
            </div>
            <ViewSwitcher t={t} view={view} onChange={setView}/>
          </div>
        </div>

        <StatusFilterChips t={t} filters={filters} setFilters={setFilters} counts={counts}/>

        <button onClick={() => setFiltersOpen(true)} style={{
          alignSelf: 'flex-start',
          fontSize: 12, fontWeight: 600, color: t.accent,
          background: 'transparent', border: 'none', cursor: 'pointer',
          padding: 0, display: 'inline-flex', alignItems: 'center', gap: 4,
        }}>
          <Icon name="filter" size={14}/>
          More filters{filterCount > 0 && ` · ${filterCount}`}
        </button>

        {view === 'tower' && (
          <TowerView t={t} units={ALL_UNITS} selected={selected} onSelect={setSelected}
            dimmedIds={filterCount > 0 ? filteredIds : null}
            density="comfortable"/>
        )}
        {view === 'floor' && (
          <FloorView t={t} units={ALL_UNITS} floor={floor} onFloorChange={setFloor}
            selected={selected} onSelect={setSelected}
            floorRange={[Math.max(1, filters.floorMin), Math.min(22, filters.floorMax)]}/>
        )}
        {view === 'grid' && (
          <GridView t={t} units={ALL_UNITS} selected={selected} onSelect={setSelected}
            dimmedIds={filterCount > 0 ? filteredIds : null}/>
        )}

        {selected && (
          <div style={{
            position: 'fixed', bottom: 80, left: 14, right: 14, zIndex: 80,
            maxHeight: '54%', overflowY: 'auto',
            background: t.surface, borderRadius: 16,
            boxShadow: t.shadowLg,
            border: `1px solid ${t.line}`,
          }}>
            <div style={{
              width: 36, height: 4, background: t.lineStrong, borderRadius: 999,
              margin: '8px auto',
            }}/>
            <div style={{ padding: '0 12px 12px' }}>
              <UnitDetailCard t={t} unit={selected} mode={mode}
                onShortlist={onShortlist} isShortlisted={isShortlisted}
                onClose={() => setSelected(null)}/>
            </div>
          </div>
        )}

        {filtersOpen && (
          <div style={{
            position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)',
            zIndex: 90, display: 'flex', alignItems: 'flex-end',
          }} onClick={() => setFiltersOpen(false)}>
            <div onClick={(e) => e.stopPropagation()} style={{
              width: '100%', maxHeight: '80%', overflowY: 'auto',
              background: t.surface, borderRadius: '20px 20px 0 0',
              padding: '14px 18px 20px',
              boxShadow: t.shadowLg,
            }}>
              <div style={{
                width: 36, height: 4, background: t.lineStrong, borderRadius: 999,
                margin: '0 auto 14px',
              }}/>
              <div style={{
                display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                marginBottom: 16,
              }}>
                <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>Filters</div>
                <button onClick={() => setFiltersOpen(false)} style={{
                  fontSize: 13, fontWeight: 600, color: t.accent,
                  background: 'transparent', border: 'none', cursor: 'pointer',
                }}>Done</button>
              </div>
              <FilterPanel t={t} filters={filters} setFilters={setFilters} counts={counts} compact/>
            </div>
          </div>
        )}
      </div>
    );
  }

  // ─── MOBILE LAYOUT (FULLSCREEN) ─────────────────────────────
  return (
    <div style={{
      background: t.bg, color: t.ink, height: '100%',
      display: 'flex', flexDirection: 'column', position: 'relative', overflow: 'hidden',
    }}>
      {/* Header */}
      <div style={{
        padding: '14px 16px 10px', borderBottom: `1px solid ${t.line}`,
        display: 'flex', flexDirection: 'column', gap: 10, background: t.surface,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div>
            <div style={{ fontSize: 10.5, fontWeight: 600, color: t.inkFaint, letterSpacing: 0.5, textTransform: 'uppercase' }}>
              {TOWER_CONFIG.project}
            </div>
            <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>
              Inventory · {filtered.length}
            </div>
          </div>
          <ViewSwitcher t={t} view={view} onChange={setView}/>
        </div>
        <StatusFilterChips t={t} filters={filters} setFilters={setFilters} counts={counts}/>
        <button onClick={() => setFiltersOpen(true)} style={{
          alignSelf: 'flex-start',
          fontSize: 12, fontWeight: 600, color: t.accent,
          background: 'transparent', border: 'none', cursor: 'pointer',
          padding: 0, display: 'inline-flex', alignItems: 'center', gap: 4,
        }}>
          <Icon name="filter" size={14}/>
          More filters{filterCount > 0 && ` · ${filterCount}`}
        </button>
      </div>

      {/* Canvas */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '12px 14px 100px' }}>
        {view === 'tower' && (
          <TowerView t={t} units={ALL_UNITS} selected={selected} onSelect={setSelected}
            dimmedIds={filterCount > 0 ? filteredIds : null}
            density="comfortable"/>
        )}
        {view === 'floor' && (
          <FloorView t={t} units={ALL_UNITS} floor={floor} onFloorChange={setFloor}
            selected={selected} onSelect={setSelected}
            floorRange={[Math.max(1, filters.floorMin), Math.min(22, filters.floorMax)]}/>
        )}
        {view === 'grid' && (
          <GridView t={t} units={ALL_UNITS} selected={selected} onSelect={setSelected}
            dimmedIds={filterCount > 0 ? filteredIds : null}/>
        )}
      </div>

      {/* Unit detail half-sheet */}
      {selected && (
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0,
          maxHeight: '64%', overflowY: 'auto',
          background: t.surface, borderRadius: '16px 16px 0 0',
          boxShadow: t.shadowLg,
          paddingBottom: 12,
        }}>
          <div style={{
            width: 36, height: 4, background: t.lineStrong, borderRadius: 999,
            margin: '8px auto',
          }}/>
          <div style={{ padding: '0 14px' }}>
            <UnitDetailCard t={t} unit={selected} mode={mode}
              onShortlist={onShortlist} isShortlisted={isShortlisted}
              onClose={() => setSelected(null)}/>
          </div>
        </div>
      )}

      {/* Filter sheet */}
      {filtersOpen && (
        <div style={{
          position: 'absolute', inset: 0, background: 'rgba(0,0,0,0.4)',
          zIndex: 90, display: 'flex', alignItems: 'flex-end',
        }} onClick={() => setFiltersOpen(false)}>
          <div onClick={(e) => e.stopPropagation()} style={{
            width: '100%', maxHeight: '80%', overflowY: 'auto',
            background: t.surface, borderRadius: '20px 20px 0 0',
            padding: '14px 18px 20px',
            boxShadow: t.shadowLg,
          }}>
            <div style={{
              width: 36, height: 4, background: t.lineStrong, borderRadius: 999,
              margin: '0 auto 14px',
            }}/>
            <div style={{
              display: 'flex', alignItems: 'center', justifyContent: 'space-between',
              marginBottom: 16,
            }}>
              <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>Filters</div>
              <button onClick={() => setFiltersOpen(false)} style={{
                fontSize: 13, fontWeight: 600, color: t.accent,
                background: 'transparent', border: 'none', cursor: 'pointer',
              }}>Done</button>
            </div>
            <FilterPanel t={t} filters={filters} setFilters={setFilters} counts={counts} compact/>
          </div>
        </div>
      )}
    </div>
  );
}

Object.assign(window, { InventoryExplorer });
