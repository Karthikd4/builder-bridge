# BuilderBridge

**Mobile-first Builder CRM + Buyer Transparency Platform for real estate.**

Digitizes the property buying lifecycle — from enquiry to agreement of sale — improving trust, visibility, and operational efficiency between builders and buyers.

---

## MVP Scope

**Phase 1 (this repo):** Flutter buyer mobile app with on-device SQLite. No backend.
**Phase 2 (planned):** Spring Boot API + PostgreSQL. SQLite becomes offline cache.

---

## Repository Structure

```
builder-bridge/
├── design-references/          ← Claude Design prototypes (read-only reference)
│   ├── html/                   ← HTML prototype files
│   ├── jsx/                    ← React/JSX component sources
│   ├── screenshots/            ← Screen captures (visual ground truth)
│   ├── uploads/                ← PRD, sprint plans, brand assets
│   └── INDEX.md                ← Guide to all design reference files
├── flutter-app/                ← Flutter mobile app (MVP)  [created Sprint 0]
│   ├── lib/
│   │   ├── core/               ← Theme, navigation, database, shared widgets
│   │   └── features/           ← Feature modules (auth, inventory, payments…)
│   ├── pubspec.yaml
│   └── CLAUDE.md               ← Flutter-specific Claude Code instructions
└── README.md
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter 3.x (Dart) |
| Local Database | SQLite via `sqflite` |
| State Management | Riverpod (`flutter_riverpod`) |
| Navigation | `go_router` |
| Fonts | Google Fonts — Manrope, Fraunces, JetBrains Mono |
| Notifications | `flutter_local_notifications` |
| Backend (Phase 2) | Spring Boot 3 (Java 21) |
| Backend DB (Phase 2) | PostgreSQL 16 |

---

## 6-Week MVP Sprint Plan

| Sprint | Duration | Focus | Key Deliverable |
|---|---|---|---|
| Pre-Sprint | Days 1–2 | Scaffold + design references | Repo structure, Flutter project, design system |
| Sprint 1 | Week 1 | Foundation + Auth | Runnable app, design tokens, auth flow |
| Sprint 2 | Week 2 | Inventory + Projects | Tower/floor/unit browse with seeded data |
| Sprint 3 | Week 3 | Estimates + Booking | Cost estimate view, booking status |
| Sprint 4 | Week 4 | Payments + Dashboard | Payment timeline, due reminders, receipts |
| Sprint 5 | Week 5 | Documents + Support | AOS viewer, tickets, notification center |
| Sprint 6 | Week 6 | Polish + Demo-Ready | Pixel-perfect screens, full seed data, demo |

---

## Feature Modules

| Module | Screens |
|---|---|
| `auth` | Splash, Login (phone), OTP verification |
| `dashboard` | Home summary (next payment, booking status, open tickets) |
| `inventory` | Project overview, tower/floor grid, unit detail, filters |
| `booking` | Estimate detail, booking summary, reservation status |
| `payments` | Payment timeline, receipts, invoices |
| `documents` | AOS list, AOS detail viewer |
| `support` | Ticket list, ticket detail, create ticket |

---

## Design References

All UI must be built by referencing files in `design-references/`. Never copy code — recreate in Flutter/Dart.

**Start with:** `design-references/INDEX.md` — maps every design file to its Flutter target and sprint.

**Key files:**

| Reference | Use For |
|---|---|
| `jsx/tokens.jsx` | Color values, spacing, typography scale |
| `jsx/brand.jsx` | Logo, brand colors, builder config |
| `jsx/ui.jsx` | Component patterns (buttons, cards, badges, modals) |
| `jsx/screens.jsx` | Main buyer app screen flows |
| `jsx/screens-2.jsx` | Payment and notification screens |
| `jsx/inventory-explorer.jsx` | Inventory browse UI |
| `screenshots/*.png` | Visual ground truth for all screens |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.22+
- Dart 3.4+
- Android Studio or VS Code with Flutter extension
- Android emulator or iOS simulator

### Setup

```bash
cd flutter-app
flutter pub get
flutter run
```

### Code Generation (freezed models)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Analyze

```bash
flutter analyze
```

---

## Claude Code Skills & Agents

This project is built with **solo dev + Claude Code** (AI-assisted). The following skills and tools are configured for this tech stack.

### Active Skills

| Skill | Command | When to Use |
|---|---|---|
| **Code Reviewer** | `/review` | After each sprint — review Flutter/Dart changes |
| **Security Review** | `/security-review` | Before Sprint 6 release — check for data exposure, insecure storage |
| **Simplify** | `/simplify` | Mid-sprint — eliminate over-engineering, improve widget structure |
| **Init** | `/init` | Day 1 of project — generate `flutter-app/CLAUDE.md` with context |
| **Fewer Permission Prompts** | `/fewer-permission-prompts` | After Sprint 1 — reduce tool approval friction |
| **Caveman Review** | `/caveman-review` | Quick compressed code review comments |

### IDE MCP Tools (Real-time Validation)

| Tool | Purpose |
|---|---|
| `mcp__ide__getDiagnostics` | Catch Dart/Flutter errors and warnings in real time |
| `mcp__ide__executeCode` | Run Flutter unit tests inline without leaving Claude Code |

### Recommended Agent Usage

| Agent Type | When |
|---|---|
| `Explore` | Understand existing Flutter widget structure before adding new features |
| `Plan` | Design each sprint's implementation approach before coding |
| `general-purpose` | Debug complex Dart/SQLite issues, research pub.dev packages |

### Sprint Review Workflow

```
End of sprint:
1. /review         → catch logic and architecture issues
2. /simplify       → remove unnecessary abstraction
3. flutter analyze → zero errors gate
4. flutter run     → manual walkthrough on emulator
5. Compare screens vs design-references/screenshots/
```

---

## SQLite Schema (MVP)

```sql
-- Identity
users (id, phone, name, email, created_at)
sessions (id, user_id, token, expires_at)

-- Property
projects (id, name, builder_name, location, description)
towers (id, project_id, name, total_floors)
units (id, tower_id, floor, unit_no, type, area_sqft, status, base_price)

-- Commerce
estimates (id, unit_id, user_id, base_price, discounts, total, created_at)
bookings (id, unit_id, user_id, status, token_amount, booked_at)
payment_milestones (id, booking_id, label, amount, due_date, paid_at)
receipts (id, milestone_id, amount, receipt_url, uploaded_at)

-- Documents
documents (id, booking_id, type, name, status, file_path)

-- Support
tickets (id, user_id, booking_id, title, description, status, created_at)
ticket_comments (id, ticket_id, author, body, created_at)

-- Notifications
notifications (id, user_id, type, title, body, read_at, created_at)
```

---

## Feature Architecture Pattern

Every feature follows this structure:

```
features/<name>/
├── data/
│   ├── models/          ← Dart data classes (freezed + json_serializable)
│   └── repositories/    ← SQLite query methods
└── presentation/
    ├── screens/         ← Full-page StatelessWidget / ConsumerWidget
    ├── widgets/         ← Feature-specific smaller widgets
    └── providers/       ← Riverpod providers (StateNotifier / AsyncNotifier)
```

---

## Phase 2 — Spring Boot Backend (Post-MVP)

When backend is added:

- New folder: `spring-boot-api/` (Spring Boot 3, Java 21, Maven)
- Architecture: Modular monolith
- Domains: Identity, Builder, CRM, Finance, Document, Support
- Auth: JWT + RBAC
- DB: PostgreSQL 16
- Storage: AWS S3
- Notifications: Firebase Cloud Messaging
- Flutter app: SQLite becomes offline cache; `Dio` HTTP client replaces direct SQLite calls

---

## Definition of MVP Success

| Stakeholder | Success Criteria |
|---|---|
| Builder | Reduced spreadsheets, faster estimates, better lead visibility |
| Buyer | Mobile app adoption, transparent payment tracking, centralized documents |
| Business | Faster sales closure, improved buyer trust, easier builder onboarding |
