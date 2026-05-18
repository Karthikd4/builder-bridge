// brand.jsx — BuilderBridge wordmark, mark, and white-label builder configs.

// ─────────────────────────────────────────────────────────────
// BB Mark — two pillars + arch. The "bridge" between builder and buyer.
// ─────────────────────────────────────────────────────────────
function BBMark({ size = 28, color = 'currentColor', strokeWidth = 2.2 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none" aria-hidden="true">
      {/* arch */}
      <path d="M5 17 Q 16 5, 27 17" stroke={color} strokeWidth={strokeWidth}
            strokeLinecap="round" fill="none" />
      {/* pillars */}
      <rect x="5" y="17" width="2.4" height="10" rx="0.6" fill={color} />
      <rect x="24.6" y="17" width="2.4" height="10" rx="0.6" fill={color} />
      {/* deck */}
      <rect x="3" y="27" width="26" height="2" rx="0.8" fill={color} />
      {/* keystone */}
      <circle cx="16" cy="9.1" r="1.6" fill={color} />
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// Wordmark — "BuilderBridge" with subtle ligature where the two 'B's meet
// ─────────────────────────────────────────────────────────────
function BBWordmark({ color = 'currentColor', size = 18, mono = false }) {
  return (
    <span style={{
      fontFamily: 'Söhne, "Inter", system-ui, sans-serif',
      fontSize: size, fontWeight: 600, letterSpacing: '-0.02em',
      color, lineHeight: 1, display: 'inline-flex', alignItems: 'center',
    }}>
      Builder<span style={{ fontWeight: 500, opacity: mono ? 1 : 0.7 }}>Bridge</span>
    </span>
  );
}

function BBLockup({ color = 'currentColor', size = 16, gap = 8 }) {
  return (
    <div style={{ display: 'inline-flex', alignItems: 'center', gap, color }}>
      <BBMark size={size * 1.5} color={color} />
      <BBWordmark color={color} size={size} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// White-label builder configurations
// ─────────────────────────────────────────────────────────────
const BUILDERS = {
  builderbridge: {
    key: 'builderbridge',
    name: 'BuilderBridge',
    accent: '#3457D5',          // signature indigo
    accentInk: '#FFFFFF',
    accentSoft: '#EEF2FF',
    tagline: 'Buyer + Builder, on one bridge.',
    project: 'Pavilion Heights',
    location: 'Kondapur, Hyderabad',
    rera: 'P02400006789',
    unit: 'A-1502',
    block: 'Block A · 15th floor',
    typology: '3 BHK · 2,140 sq ft',
    agreedPrice: 21850000, // ₹2.18 Cr
  },
  vue: {
    key: 'vue',
    name: 'Vue Constructions',
    accent: '#0F3D5F',         // navy
    accentInk: '#FFFFFF',
    accentSoft: '#E5EEF5',
    tagline: 'Spaces with perspective.',
    project: 'Vue Pavilion',
    location: 'Tellapur, Hyderabad',
    rera: 'P02400012204',
    unit: 'A-1502',
    block: 'Tower A · 15th floor',
    typology: '3 BHK · 2,140 sq ft',
    agreedPrice: 21850000,
  },
  myhome: {
    key: 'myhome',
    name: 'My Home',
    accent: '#B5302A',         // brand red
    accentInk: '#FFFFFF',
    accentSoft: '#FBEAE8',
    tagline: 'Crafted to last.',
    project: 'My Home Apas',
    location: 'Kokapet, Hyderabad',
    rera: 'P02400005413',
    unit: 'T2-2308',
    block: 'Tower 2 · 23rd floor',
    typology: '4 BHK · 3,260 sq ft',
    agreedPrice: 41200000,
  },
  aparna: {
    key: 'aparna',
    name: 'Aparna',
    accent: '#2F6A3B',         // forest green
    accentInk: '#FFFFFF',
    accentSoft: '#E6F0E7',
    tagline: 'Live the difference.',
    project: 'Aparna Sarovar Zicon',
    location: 'Nallagandla, Hyderabad',
    rera: 'P02400008820',
    unit: 'C-1104',
    block: 'Block C · 11th floor',
    typology: '3 BHK · 1,975 sq ft',
    agreedPrice: 18450000,
  },
  asbi: {
    key: 'asbi',
    name: 'ASBI Infra',
    accent: '#1D4F73',         // steel
    accentInk: '#FFFFFF',
    accentSoft: '#E8EFF5',
    tagline: 'Engineered residences.',
    project: 'ASBI Pinnacle',
    location: 'Gachibowli, Hyderabad',
    rera: 'P02400009111',
    unit: 'B-906',
    block: 'Block B · 9th floor',
    typology: '2 BHK · 1,420 sq ft',
    agreedPrice: 12750000,
  },
  rajapushpa: {
    key: 'rajapushpa',
    name: 'Rajapushpa',
    accent: '#6A3D8A',         // royal purple
    accentInk: '#FFFFFF',
    accentSoft: '#F0E8F5',
    tagline: 'Address of distinction.',
    project: 'Rajapushpa Atria',
    location: 'Gachibowli, Hyderabad',
    rera: 'P02400003302',
    unit: 'D-2104',
    block: 'Tower D · 21st floor',
    typology: '3 BHK · 2,310 sq ft',
    agreedPrice: 24300000,
  },
};

const BUILDER_KEYS = Object.keys(BUILDERS);

Object.assign(window, { BBMark, BBWordmark, BBLockup, BUILDERS, BUILDER_KEYS });
