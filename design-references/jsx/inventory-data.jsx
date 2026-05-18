// inventory-data.jsx — Single source of truth for the tower inventory model.
// 22 floors × 4 positions = 88 units. Deterministic generator.

const TOWER_CONFIG = {
  project: 'Pavilion Heights',
  block: 'Block A',
  floors: 22,
  unitsPerFloor: 4,
  // Pattern repeats every floor:
  // position 1: 2BHK East-facing pool-view corner unit
  // position 2: 3BHK East-facing pool-view inner unit
  // position 3: 3BHK West-facing city-view inner unit
  // position 4: 4BHK West-facing sunset-view corner unit
  unitTypePattern: ['2BHK', '3BHK', '3BHK', '4BHK'],
  facingPattern:   ['East', 'East', 'West', 'West'],
  viewPattern:     ['Pool', 'Pool', 'City', 'Sunset'],
  sqftPattern:     [1320, 1820, 2140, 2940],
  basePricePerSqft: 8750,
  floorRisePerFloor: 150,
  // Ground floor amenities reserved (typically lobby, retail)
  groundFloorReserved: true,
};

function generateUnits() {
  const units = [];
  const cfg = TOWER_CONFIG;
  for (let f = 1; f <= cfg.floors; f++) {
    for (let p = 0; p < cfg.unitsPerFloor; p++) {
      const type   = cfg.unitTypePattern[p];
      const facing = cfg.facingPattern[p];
      const view   = cfg.viewPattern[p];
      const sqft   = cfg.sqftPattern[p];
      // Deterministic "seed" for status — no Math.random so renders are stable.
      const seed = ((f * 31 + p * 17) * 2654435761) >>> 0;
      const r = seed % 100;

      // Sales-velocity model: lower floors sell out first; pool views go faster.
      let status;
      if (f <= 4) {
        status = r < 55 ? 'sold' : r < 78 ? 'booked' : r < 90 ? 'reserved' : 'available';
      } else if (f <= 10) {
        status = r < 30 ? 'sold' : r < 55 ? 'booked' : r < 70 ? 'reserved' : 'available';
      } else if (f <= 18) {
        status = r < 18 ? 'sold' : r < 35 ? 'booked' : r < 50 ? 'reserved' : 'available';
      } else {
        status = r < 8  ? 'sold' : r < 22 ? 'booked' : r < 35 ? 'reserved' : 'available';
      }
      // Pool-view premium: more demand → bias toward booked
      if (view === 'Pool' && status === 'available' && r > 45) {
        status = r % 2 ? 'booked' : 'reserved';
      }
      // The featured "your" unit
      const isMine = f === 15 && p === 1;
      if (isMine) status = 'booked';

      const price = Math.round((sqft * cfg.basePricePerSqft + (f - 1) * cfg.floorRisePerFloor * sqft) / 100000) * 100000;

      units.push({
        id: `A-${String(f).padStart(2, '0')}${String(p + 1).padStart(2, '0')}`,
        floor: f, position: p + 1,
        type, facing, view, sqft, price, status,
        premium: view === 'Pool',
        corner: p === 0 || p === 3,
        isMine,
      });
    }
  }
  return units;
}

const ALL_UNITS = generateUnits();

// ─────────────────────────────────────────────────────────────
// Status palette — a separate concern from theme tokens. These colors
// are the same in light/dark; the system below adapts the surrounding
// surface, not the status itself, so a "sold" cell reads identically
// across modes. Brand accent overlays status when a unit is selected.
// ─────────────────────────────────────────────────────────────
const STATUS = {
  available: {
    label: 'Available',
    color: '#2A8C56',
    soft:  '#E0F0E5',
    softDark: 'rgba(42, 140, 86, 0.18)',
    description: 'Open inventory — ready for site visit or booking.',
    velocity: 'goes in 24–72h for pool-view units',
  },
  reserved: {
    label: 'Reserved',
    color: '#C57A1E',
    soft:  '#FAEFDB',
    softDark: 'rgba(197, 122, 30, 0.18)',
    description: 'Token paid; 7-day exclusive hold before booking.',
    velocity: '5-day average to booking',
  },
  booked: {
    label: 'Booked',
    color: '#5C45B5',
    soft:  '#ECE6F8',
    softDark: 'rgba(92, 69, 181, 0.20)',
    description: 'AOS signed; unit committed to a buyer.',
    velocity: '12–18 months to handover',
  },
  sold: {
    label: 'Sold',
    color: '#6E7686',
    soft:  '#EAECEF',
    softDark: 'rgba(110, 118, 134, 0.16)',
    description: 'Possession granted; off-market.',
    velocity: 'closed',
  },
};

// Helper: count by status from a list
function countByStatus(units) {
  return Object.keys(STATUS).reduce((acc, k) => {
    acc[k] = units.filter((u) => u.status === k).length;
    return acc;
  }, {});
}

// Helper: filter units by current filter state
function applyFilters(units, filters) {
  return units.filter((u) => {
    if (filters.status && filters.status.length && !filters.status.includes(u.status)) return false;
    if (filters.facing && filters.facing.length && !filters.facing.includes(u.facing)) return false;
    if (filters.type   && filters.type.length   && !filters.type.includes(u.type))   return false;
    if (filters.floorMin != null && u.floor < filters.floorMin) return false;
    if (filters.floorMax != null && u.floor > filters.floorMax) return false;
    return true;
  });
}

const EMPTY_FILTERS = { status: [], facing: [], type: [], floorMin: 1, floorMax: 22 };

Object.assign(window, {
  TOWER_CONFIG, ALL_UNITS, STATUS, generateUnits,
  countByStatus, applyFilters, EMPTY_FILTERS,
});
