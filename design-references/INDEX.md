# BuilderBridge Design References — Index

All files here are Claude Design prototypes (HTML/JSX). Read them as source of truth for colors, layout, components, and screen flows. Do NOT copy code structure — recreate in Flutter.

---

## Start Here

| File | What It Contains |
|---|---|
| `html/BuilderBridge - Design Spec.html` | PRIMARY: Full design system, IA, wireframes, UX principles |
| `html/BuilderBridge - All Screens.html` | Screen gallery — all screens in one view |
| `html/BuilderBridge - Buyer App.html` | Buyer app focused view |
| `html/BuilderBridge - Buyer App (standalone).html` | Self-contained 1.5MB bundle |
| `html/BuilderBridge - Inventory System.html` | Inventory module deep-dive |

---

## Design System (JSX)

| File | Flutter Target |
|---|---|
| `jsx/tokens.jsx` | `lib/core/theme/app_colors.dart` + `app_typography.dart` |
| `jsx/brand.jsx` | `lib/core/theme/app_theme.dart` (BBMark, brand config) |
| `jsx/ui.jsx` | `lib/core/widgets/` (BBButton, BBCard, BBBadge, BBModal) |

### Key Design Tokens (from tokens.jsx)

| Token | Value | Flutter |
|---|---|---|
| `--ink` | Primary text | `AppColors.ink` |
| `--ink-mute` | Secondary text | `AppColors.inkMute` |
| `--ink-faint` | Tertiary text | `AppColors.inkFaint` |
| `--bg` | Page background | `AppColors.bg` |
| `--surface` | Card background | `AppColors.surface` |
| `--accent` | Brand accent | `AppColors.accent` |
| `--ok` | Success/available | `AppColors.ok` |
| `--warn` | Warning/reserved | `AppColors.warn` |
| `--danger` | Error/booked | `AppColors.danger` |
| `--line` | Dividers/borders | `AppColors.line` |
| Manrope | Body font | `GoogleFonts.manrope()` |
| Fraunces | Serif headings | `GoogleFonts.fraunces()` |
| JetBrains Mono | Code/mono | `GoogleFonts.jetBrainsMono()` |

---

## Screen References (JSX)

| File | Screens It Covers | Sprint |
|---|---|---|
| `jsx/screens.jsx` | Login, OTP, Dashboard, Inventory, Payments, AOS | 1–5 |
| `jsx/screens-2.jsx` | Payment timeline, notifications, support | 4–5 |
| `jsx/ios-frame.jsx` | iOS mobile frame wrapper (ignore in Flutter) | — |

---

## Inventory System (JSX)

| File | What It Covers | Sprint |
|---|---|---|
| `jsx/inventory-data.jsx` | Sample data structure for seed JSON | 2 |
| `jsx/inventory-explorer.jsx` | Main browse UI (tower/floor/unit) | 2 |
| `jsx/inventory-controls.jsx` | Filter panel, search bar | 2 |
| `jsx/inventory-views.jsx` | Grid, list, map view modes | 2 |
| `jsx/inventory-spec.jsx` | Unit detail specification | 2 |
| `jsx/inventory-spec-2.jsx` | Unit spec variant 2 | 2 |
| `jsx/inventory-spec-3.jsx` | Unit spec variant 3 | 2 |

---

## Design Spec Sections (JSX)

| File | Contents |
|---|---|
| `jsx/spec-parts.jsx` | Design guidelines, color system, typography |
| `jsx/spec-parts-2.jsx` | Component library documentation |
| `jsx/spec-parts-3.jsx` | Screen patterns and navigation |
| `jsx/spec-parts-4.jsx` | Interaction patterns and states |

---

## Screenshots (Visual Ground Truth)

Use these for pixel-level comparison during Sprint 6 polish pass.

| File | Screen |
|---|---|
| `screenshots/01-home.png` – `05-home.png` | Home/dashboard iterations |
| `screenshots/01-21-inv-color.png` – `08-21-inv-color.png` | Inventory color-coded unit states |
| `screenshots/01-12-spec-scrolled.png` – `07-12-spec-scrolled.png` | Spec/detail screen |
| `screenshots/25-buyer-inventory.png` | Buyer inventory browse |
| `screenshots/26-buyer-inv-2.png` | Buyer inventory variant 2 |
| `screenshots/27-buyer-inv-3.png` | Buyer inventory variant 3 |
| `screenshots/23-live-mid.png` | Live/payment mid-flow |
| `screenshots/20-inv-hero.png` | Inventory hero view |
| `screenshots/09-scroll.png` | Scrolled content view |
| `screenshots/11-spec-top.png` | Spec top section |

---

## Documentation

| File | Contents |
|---|---|
| `uploads/mvp_sprint_plan.md` | Original 6-sprint delivery roadmap |
| `uploads/overall_project_phases.md` | Phase 0–4 strategic roadmap |
| `uploads/BuilderBridge_Phase1_PRD.docx` | Full product requirements document |
| `uploads/Builder Bridge Image1.jpeg` | Brand image asset |
| `uploads/Builder Bridge Image2.jpeg` | Brand image asset |
