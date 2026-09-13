# Phase 1 architecture

## Product map and navigation

The primary navigation is deliberately small: **الرئيسية**, **الجامعة**, **المهام**, **الشقة**, and **المزيد**. Calendar, notes, wallet, purchases, notifications, and settings live in More or are linked contextually from the dashboard. A structured quick-add sheet offers the most frequent creation flows.

```text
الرئيسية → Today / upcoming / financial snapshot / quick add
الجامعة → academic period → subject → lectures, items, files, notes, grades, schedule
المهام → personal tasks and recurrence
الشقة → people / responsibilities / fund / purchases / debts
المزيد → calendar / notes / wallet / purchases / notifications / settings
```

## App architecture

Feature-first layers are used throughout: `presentation` (widgets), `application` (state/use cases), `domain` (entities and rules), and `data` (repositories, cache, Firebase adapters). UI never calculates balances or schedules notifications directly. The initial Provider app state is intentionally small; feature-scoped controllers replace it as features arrive.

```text
lib/core          theme, routing, error/result types, app services
lib/shared        reusable UI and utilities
lib/features/*    feature-specific presentation/application/domain/data
```

All V1 UI uses Arabic RTL with `Locale('ar')`. Copy is kept inside a future-ready localization boundary; Phase 2 should move labels to ARB files before broad feature development.

## Core models

| Area | Primary entities |
|---|---|
| Academic | AcademicYear, Stage, Semester, Subject, ClassMeeting, Lecture, AcademicItem, Attachment |
| Productivity | PersonalTask, RecurrenceRule, Reminder, Note, ChecklistItem |
| Apartment | ApartmentMember, Responsibility, ResponsibilityOccurrence, FundPeriod, Contribution |
| Finance | LedgerEntry, Purchase, Debt, Reimbursement, Shop |

IDs are generated client-side. Dates are stored as UTC timestamps; UI formats in local device time. Financial amounts use integer IQD only.

## Firestore schema

All private records live under `users/{uid}`. No apartment member receives authentication access.

```text
users/{uid}
  academicYears/{id}          semesters/{id}              subjects/{id}
  lectures/{id}               academicItems/{id}           personalTasks/{id}
  notes/{id}                  apartmentMembers/{id}        responsibilities/{id}
  responsibilityOccurrences/{id}
  fundPeriods/{id}            contributions/{id}           purchases/{id}
  shops/{id}                  ledgerEntries/{id}           debts/{id}
  notificationJobs/{id}       syncOperations/{id}
```

Documents include `createdAt`, `updatedAt`, and optional `deletedAt`. Queries always filter by active/archive state and use pagination. Required indexes will be added with each query rather than speculatively.

### Security rule principle

Every Firestore and Storage request must satisfy `request.auth.uid == userId`. Client-provided owner IDs are never trusted. Server timestamps are used where appropriate. Firebase configuration is environment-specific and intentionally not included in this repository.

## Storage structure

```text
users/{uid}/subjects/{subjectId}/lectures/{lectureId}/{attachmentId}
users/{uid}/academic-items/{itemId}/{attachmentId}
users/{uid}/notes/{noteId}/{attachmentId}
users/{uid}/purchases/{purchaseId}/receipt/{attachmentId}
```

Metadata (original name, MIME type, size, linked entity, uploaded time) remains in Firestore. Uploads are queued locally and retried; a failed upload never removes the local record.

## Notification architecture

A single `NotificationCoordinator` will accept normalized `Reminder` records from tasks, academic items, classes, and responsibilities. It calculates local notification jobs, assigns Android channels by importance, persists job IDs, handles Done/Snooze/Open actions, and applies a capped overdue cadence: urgent hourly, important every two hours, normal every three hours. Each schedule is cancelled/rebuilt only through the coordinator.

## Financial ledger

`LedgerEntry` is immutable and is the source for balances. Corrections are reversal entries, never silent edits. A purchase paid personally creates one personal-wallet debit and its linked apartment purchase. For equal member sharing, the payer's own share is excluded from their receivable: 10,000 IQD / 5 members means 2,000 own share and 8,000 receivable. This is covered by automated tests.

## Assumptions

- Android is the first target; platform folders will be generated with Flutter once its SDK is installed.
- Authentication starts with anonymous/local development and upgrades to email/Google sign-in in the Firebase integration phase.
- Local persistence is repository-backed; the concrete SQLite/Isar choice is deferred until Flutter tooling is available and the model query patterns are in place.
