# BuilderBridge — Claude Project Intelligence

Claude Code reads this file at the start of every session. All implementation decisions must align with this context.

---

## Project Identity

**BuilderBridge** — Mobile-first Builder CRM + Buyer Transparency Platform for real estate.

Phase 1 (this repo): Flutter buyer app + on-device SQLite. No backend.
Phase 2 (planned): Spring Boot 3 API + PostgreSQL. SQLite becomes offline cache.

Team: Solo developer + Claude Code (AI-assisted).

---

## Architecture — Non-Negotiable Rules

### Flutter App
- Feature-first folder structure: `lib/features/<name>/`
- Repository pattern: all SQLite queries inside `*_repository.dart` only
- Riverpod only: no setState, no ChangeNotifier, no BLoC
- Immutable models: freezed data classes everywhere
- No `dynamic` types in domain layer
- DTOs separate from domain models
- Screens ≤ 200 lines — extract widgets aggressively
- No business logic in widgets
- `const` constructors wherever possible

### Design System
- Colors: `AppColors.*` only — no hardcoded hex
- Spacing: `AppSpacing.*` only — no magic numbers
- Typography: `AppTypography.*` — Manrope body, Fraunces headings
- Components: `BBButton`, `BBCard`, `BBBadge`, `BBLoadingState`, `BBEmptyState`, `BBErrorState`
- Status always via `BBBadge` — never custom chips

### Database
- Money stored as `INTEGER` (paise) — never `REAL`/`double`
- Dates stored as ISO 8601 TEXT
- All queries parameterized — never string interpolation in SQL
- Migrations version-incremented — never alter existing migration

---

## File Locations

| Purpose | Path |
|---|---|
| Flutter app | `flutter-app/` |
| Design references | `design-references/` |
| Design index | `design-references/INDEX.md` |
| Agent definitions | `.claude/agents/` |
| Skill definitions | `.claude/skills/` |
| Sprint plan | `.claude/plans/` |

---

## Design Reference Usage (MANDATORY)

Before implementing any screen, read:
1. `design-references/INDEX.md` — find the right reference files
2. `design-references/jsx/tokens.jsx` — exact color/spacing values
3. `design-references/jsx/screens.jsx` or matching file — screen layout
4. `design-references/screenshots/<screen>.png` — visual ground truth

Never implement a screen without checking design references first.

---

## Agent Reference

Invoke these agents for specific tasks:

| Task | Agent |
|---|---|
| Flutter architecture decisions | `.claude/agents/flutter-architect.md` |
| Riverpod state patterns | `.claude/agents/riverpod-expert.md` |
| UI component review | `.claude/agents/mobile-ui-reviewer.md` |
| General code review | `.claude/agents/code-reviewer.md` |
| Performance issues | `.claude/agents/performance-reviewer.md` |
| Security concerns | `.claude/agents/security-reviewer.md` |
| Testing strategy | `.claude/agents/testing-reviewer.md` |
| Offline/sync questions | `.claude/agents/offline-sync-expert.md` |
| API design (Phase 2) | `.claude/agents/api-reviewer.md` |
| UX/buyer experience | `.claude/agents/ux-reviewer.md` |
| Spring Boot (Phase 2) | `.claude/agents/backend-architect.md` |
| Platform-specific (iOS/Android) | `.claude/agents/mobile-expert.md` |
| Design system/tokens | `.claude/agents/frontend-architect.md` |

---

## Skill Reference

Use these patterns — don't invent new approaches:

| Task | Skill |
|---|---|
| New feature scaffold | `.claude/skills/flutter-feature-architecture.md` |
| Riverpod provider/notifier | `.claude/skills/riverpod-patterns.md` |
| SQLite repository | `.claude/skills/sqlite-patterns.md` |
| Navigation / go_router | `.claude/skills/go-router-patterns.md` + `navigation-patterns.md` |
| UI widgets | `.claude/skills/flutter-ui-patterns.md` |
| Forms | `.claude/skills/flutter-form-patterns.md` |
| Offline storage | `.claude/skills/offline-storage-patterns.md` |
| Local notifications | `.claude/skills/notification-patterns.md` |
| HTTP / API (Phase 2) | `.claude/skills/api-integration-patterns.md` |
| Spring Boot (Phase 2) | `.claude/skills/spring-boot-patterns.md` |
| Feature module full example | `.claude/skills/feature-module-patterns.md` |
| File upload | `.claude/skills/file-upload-patterns.md` |

---

## Sprint Status

| Sprint | Status | Deliverable |
|---|---|---|
| Pre-Sprint | ✅ Done | Design refs organized, README updated, agent/skill system created |
| Sprint 1 | ✅ Done | Flutter scaffold, design system, auth flow (login/OTP/success/dashboard shell) |
| Sprint 2 | ✅ Done | Inventory + project screens |
| Sprint 3 | ✅ Done | Estimates + booking |
| Sprint 4 | ✅ Done | Payments + dashboard |
| Sprint 5 | ✅ Done | Documents + support + notifications |
| Sprint 6 | ⏳ Next | Polish + demo-ready |

---

## Scope Boundaries (MVP — Do Not Build)

- Payment gateway (manual entry only)
- Real-time chat
- AI features
- Community/social features
- Complex analytics dashboards
- Public marketplace
- Spring Boot backend (Phase 2)
- DocuSign (Phase 2)

---

## Sprint Review Protocol

End of every sprint:
1. `flutter analyze` — zero errors gate
2. `/review` skill — code review pass
3. `/simplify` skill — remove over-engineering
4. `flutter run` on Android emulator — manual walkthrough
5. Compare screens vs `design-references/screenshots/`

---

## Key Design Tokens (verify in tokens.jsx before use)

```
--ink:       #0F0F0F   Primary text
--ink-mute:  #6B7280   Secondary text
--ink-faint: #D1D5DB   Tertiary / disabled
--line:      #E5E7EB   Borders / dividers
--bg:        #F9FAFB   Page background
--surface:   #FFFFFF   Card / surface
--accent:    (verify)  Brand accent / primary
--ok:        #16A34A   Success / available
--warn:      #D97706   Warning / reserved
--danger:    #DC2626   Error / booked
```

**Always verify hex values from `design-references/jsx/tokens.jsx` — override these if different.**

---

## Commit Convention

```
feat(auth): add OTP verification screen
fix(inventory): correct unit status color mapping
refactor(payments): extract milestone card widget
test(support): add ticket repository unit tests
```

Scope = feature name: auth, inventory, booking, payments, documents, support, core

## Claude Generation Rules

- Generate incrementally
- Never generate multiple features together
- Never create giant files
- Ask before introducing new dependencies
- Prefer modification over duplication
- Reuse existing widgets whenever possible
- Explain architecture before implementation
- Prefer composition over inheritance
- Avoid premature abstraction

## File Size Limits

- Screens: max 200 lines
- Widgets: max 150 lines
- Providers: max 150 lines
- Repositories: max 250 lines
- Extract aggressively when exceeding limits

## Riverpod Rules

- Async state via AsyncNotifier/AsyncValue
- No global mutable state
- Providers scoped per feature
- UI watches minimal provider surface
- Avoid unnecessary rebuilds

## Navigation Rules

- Centralized route definitions
- Typed route params where possible
- No navigation logic inside repositories
- Auth guards via router redirects only

## SQLite Rules

- Repository layer only accesses DB
- No raw queries in providers/widgets
- All writes transactional where applicable
- Use indexes for frequently queried fields

## MVP Implementation Order

1. Core app scaffold
2. Design system
3. Authentication
4. Dashboard
5. Inventory/projects
6. Booking flow
7. Payments
8. Documents
9. Support tickets
10. Notifications
11. Polish/testing

SQLite currently acts as local source of truth.
Phase 2 will introduce backend synchronization layer.
Repositories should remain backend-agnostic where possible.

## New Feature Checklist

Every feature must include:
- models
- repository
- providers
- screens
- reusable widgets
- loading state
- empty state
- error state
- routing
- tests (if applicable)
