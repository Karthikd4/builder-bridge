# BuilderBridge — MVP Sprint Plan

## Delivery Model
- Mobile-first platform
- 2-member AI-assisted team
- Shared backend APIs
- Buyer mobile app
- Builder web portal

---

# Sprint Structure

| Sprint | Duration | Focus |
|---|---|---|
| Sprint 0 | 3 Days | Foundation |
| Sprint 1 | Week 1 | Auth + Builder Setup |
| Sprint 2 | Week 2 | CRM + Inventory |
| Sprint 3 | Week 3 | Estimates + Booking |
| Sprint 4 | Week 4 | Payments + Buyer Dashboard |
| Sprint 5 | Week 5 | AOS + Tickets + Notifications |
| Sprint 6 | Week 6 | Stabilization + Production |

---

# Sprint 0 — Foundation

## Backend
- Spring Boot setup
- PostgreSQL setup
- JWT auth
- RBAC
- Docker setup
- Audit logging

## Mobile App
- React Native project
- Navigation setup
- Theme system
- API client

## Web Portal
- React admin portal
- Shared layouts
- Routing

---

# Sprint 1 — Identity & Project Setup

## Backend APIs
- User APIs
- Builder APIs
- Project APIs
- Tower APIs
- Unit APIs

## Mobile Screens
- Login
- OTP verification
- Dashboard shell

## Web Screens
- Builder onboarding
- Project setup
- Unit management

## Deliverables
Builder can configure:
- Projects
- Towers
- Inventory

---

# Sprint 2 — CRM & Inventory

## Backend
- Enquiry APIs
- Activity tracking
- Visit scheduling
- Inventory filters

## Web Portal
- Lead pipeline
- Visit scheduling
- Activity timeline

## Mobile App
- Project details
- Unit details
- Visit tracking

## Deliverables
Complete enquiry-to-visit flow operational.

---

# Sprint 3 — Estimates & Booking

## Backend
- Pricing engine
- Estimate generation
- Negotiation tracking
- Booking APIs

## Web Portal
- Estimate generation
- Discount management
- Booking confirmation

## Mobile App
- Estimate viewing
- Booking summary
- Reservation visibility

## Deliverables
Sales and booking workflows operational.

---

# Sprint 4 — Payments & Buyer Dashboard

## Backend
- Payment milestone APIs
- Receipt uploads
- Invoice management
- Notification triggers

## Mobile App
- Payment timeline
- Due reminders
- Receipt access
- Invoice downloads

## Web Portal
- Payment operations
- Receipt validations
- Milestone management

## Deliverables
Buyer payment lifecycle operational.

---

# Sprint 5 — AOS, Tickets & Notifications

## Backend
- AOS workflows
- DocuSign integration
- Ticket APIs
- Notification engine

## Mobile App
- AOS viewer
- Ticket creation
- Notification center

## Web Portal
- AOS management
- Ticket assignment
- SLA tracking

## Deliverables
Buyer transparency portal operational.

---

# Sprint 6 — Stabilization & Production

## Tasks
- Regression testing
- Mobile optimization
- API optimization
- UAT fixes
- Production deployment

## Deliverables
Production-ready MVP.

---

# Recommended Architecture

## Backend
- Spring Boot modular monolith

## Mobile App
- React Native

## Web Portal
- React JS

## Database
- PostgreSQL

## Storage
- AWS S3

## Notifications
- Firebase Cloud Messaging

---

# Suggested Backend Domains

## Identity
- Users
- Roles
- Sessions

## Builder Domain
- Builders
- Projects
- Towers
- Units

## CRM Domain
- Leads
- Visits
- Activities

## Finance Domain
- Estimates
- Payments
- Receipts

## Document Domain
- AOS
- Uploads
- Agreements

## Support Domain
- Tickets
- Comments
- SLA logs

---

# MVP Scope Control

## Do NOT Build in MVP
- AI features
- Community social networking
- Public marketplace
- Real-time chat
- Payment gateway
- Complex analytics

---

# Definition of MVP Success

## Builder Side
- Reduced spreadsheets
- Faster estimates
- Better lead visibility

## Buyer Side
- Mobile app adoption
- Transparent payment tracking
- Centralized documents

## Business Side
- Faster sales closure
- Improved buyer trust
- Easier builder onboarding
