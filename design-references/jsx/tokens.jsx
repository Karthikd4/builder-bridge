// tokens.jsx — Design tokens for BuilderBridge.
// Two themes (light, dark). Brand accent is per-builder, set elsewhere.

// Darken a hex by mix-with-black amount (0..1). Pure math, no color-mix dep.
function darken(hex, amount = 0.3) {
  const h = String(hex).replace('#', '');
  const x = h.length === 3 ? h.replace(/./g, (c) => c + c) : h;
  const n = parseInt(x, 16);
  const r = Math.round(((n >> 16) & 255) * (1 - amount));
  const g = Math.round(((n >> 8) & 255) * (1 - amount));
  const b = Math.round((n & 255) * (1 - amount));
  return `rgb(${r}, ${g}, ${b})`;
}

// Hex to rgba string helper
function hexToRgba(hex, a) {
  const h = String(hex).replace('#', '');
  const x = h.length === 3 ? h.replace(/./g, (c) => c + c) : h;
  const n = parseInt(x, 16);
  const r = (n >> 16) & 255, g = (n >> 8) & 255, b = n & 255;
  return `rgba(${r}, ${g}, ${b}, ${a})`;
}

const LIGHT = {
  bg: '#F6F5F0',              // warm paper (subtle, "blueprint margin")
  surface: '#FFFFFF',
  surfaceMute: '#F2F1EB',
  surfaceSunk: '#EDEBE4',
  line: 'rgba(11, 18, 40, 0.08)',
  lineStrong: 'rgba(11, 18, 40, 0.16)',
  ink: '#0B1228',             // primary text
  inkMute: '#4A5168',
  inkFaint: '#8A91A4',
  // semantic
  ok: '#1F8A5B',
  okSoft: '#E2F1EA',
  warn: '#B26A0F',
  warnSoft: '#F8EEDC',
  danger: '#C0392B',
  dangerSoft: '#F8E2DE',
  info: '#2356C7',
  infoSoft: '#E6EDFB',
  // chrome
  navBg: 'rgba(255,255,255,0.86)',
  shadow: '0 1px 0 rgba(11,18,40,0.04), 0 6px 20px rgba(11,18,40,0.04)',
  shadowLg: '0 1px 0 rgba(11,18,40,0.04), 0 20px 40px rgba(11,18,40,0.10)',
};

const DARK = {
  bg: '#0A0F1F',
  surface: '#131A2E',
  surfaceMute: '#1A2238',
  surfaceSunk: '#0F1424',
  line: 'rgba(255,255,255,0.08)',
  lineStrong: 'rgba(255,255,255,0.18)',
  ink: '#F1F0EA',
  inkMute: '#A8AFC2',
  inkFaint: '#6C748A',
  ok: '#3BB47E',
  okSoft: 'rgba(59,180,126,0.16)',
  warn: '#E0A24A',
  warnSoft: 'rgba(224,162,74,0.16)',
  danger: '#E07767',
  dangerSoft: 'rgba(224,119,103,0.16)',
  info: '#6F92E8',
  infoSoft: 'rgba(111,146,232,0.16)',
  navBg: 'rgba(19,26,46,0.86)',
  shadow: '0 1px 0 rgba(0,0,0,0.4), 0 6px 20px rgba(0,0,0,0.25)',
  shadowLg: '0 1px 0 rgba(0,0,0,0.4), 0 20px 40px rgba(0,0,0,0.45)',
};

function useTokens(dark, builder) {
  return React.useMemo(() => {
    const base = dark ? DARK : LIGHT;
    return {
      ...base,
      dark,
      accent: builder.accent,
      accentInk: builder.accentInk,
      accentDark: darken(builder.accent, 0.35),
      accentSoft: dark
        ? hexToRgba(builder.accent, 0.22)
        : builder.accentSoft,
      builder,
    };
  }, [dark, builder]);
}

// Hex to rgba string helper (used in useTokens above)
// Currency helpers — Indian numbering (lakhs/crores).
function formatINR(n, opts = {}) {
  const { compact = true, decimals = null } = opts;
  if (compact) {
    if (n >= 10000000) {
      const v = n / 10000000;
      const d = decimals ?? (v >= 10 ? 1 : 2);
      return `₹${v.toFixed(d)} Cr`;
    }
    if (n >= 100000) {
      const v = n / 100000;
      const d = decimals ?? (v >= 10 ? 1 : 2);
      return `₹${v.toFixed(d)} L`;
    }
    if (n >= 1000) return `₹${(n / 1000).toFixed(0)}K`;
    return `₹${n.toLocaleString('en-IN')}`;
  }
  return `₹${n.toLocaleString('en-IN')}`;
}

Object.assign(window, { LIGHT, DARK, useTokens, formatINR, darken, hexToRgba });
