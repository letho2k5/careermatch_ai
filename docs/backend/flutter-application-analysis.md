# Commit 01 — Existing Flutter application analysis

## Scope and evidence

This analysis is based on the current Flutter source, `pubspec.yaml`, route table, state/model files, tests, and repository file inventory. It describes the implementation as it exists before backend work; demo records are not treated as production data.

## Repository and platform baseline

- Application: Flutter/Dart package `careermatch_ai`.
- Dart constraint: `^3.13.5` in `pubspec.yaml`.
- UI state: `flutter_riverpod ^3.4.3`; navigation: `go_router ^18.1.1`; local file selection: `file_picker ^13.1.0`.
- No backend workspace, `package.json`, NestJS config, Prisma schema, SQL migration, or Docker Compose file was found in the repository inventory.
- `lib/main.dart` starts `CareerMatchApp` inside `ProviderScope`; the app uses `appRouter` from `lib/app/app_router.dart`.
- Flutter CLI baseline could not be obtained in this run: `E:\HOCKY1NAM4\UXUI\flutter\bin\flutter.bat --version` produced no output for about 35 seconds and was interrupted. Flutter SDK version and current test baseline are therefore unverified.
- Git branch at analysis time: `tho/feature/backend-postgresql`; remote `origin` points to the repository provided by the owner. Six existing Flutter files were already modified and are explicitly outside this analysis commit.

## Screen and route inventory

The router contains 100 named routes plus `/`, an unnamed redirect to `/splash`. The route-to-feature/file mapping follows the imports and builders in `app_router.dart`.

| Feature group | Named route coverage | Main Flutter implementation files | Current behavior/data source |
|---|---|---|---|
| Student entry, profile, CV | `/splash`, `/welcome`, `/onboarding-one`, `/onboarding-two`, `/choose-role`, `/student-signup`, `/email-verification`, `/student-login`, `/forgot-password`, `/reset-password`, `/student-home`, `/student-profile-setup-1`, `/student-profile-setup-2`, `/education`, `/student-skills`, `/student-experience`, `/cv-upload`, `/cv-progress`, `/cv-analysis-result`, `/cv-edit-skills` | `features/onboarding/screens/onboarding_screens.dart`; `features/auth/screens/auth_screens.dart`; `features/student_home/student_home_screen.dart`; `features/student_profile/{student_draft.dart,screens/*}`; `features/cv/screens/*` | Riverpod in-memory student draft; auth and CV analysis are demo UI. Selected CV metadata stays in memory; no upload endpoint or durable profile store exists. |
| Job discovery and applications | `/jobs/home`, `/jobs/search`, `/jobs/suggestions`, `/jobs/results`, `/jobs/filters`, `/jobs/sort`, `/jobs/recommended`, `/jobs/saved`, `/jobs/:jobId/compare-skills`, `/jobs/:jobId/save-confirmation`, `/jobs/:jobId/apply`, `/jobs/:jobId/select-cv`, `/jobs/:jobId/application-review`, `/applications`, `/applications/:applicationId/success`, `/applications/:applicationId/timeline`, `/applications/:applicationId`, `/companies/:companyId`, `/jobs/:jobId/match`, `/jobs/:jobId` | `features/jobs/screens/*`; `features/jobs/{models,state}/*`; shared demo job cards in `features/jobs/widgets/*` | Jobs are `demoJobs`; search/filter/sort/saved state and application drafts/records are Riverpod session state. There is no remote job source or submission API. |
| Career development | `/career`, `/career/skills`, `/career/skill-gap`, `/career/missing-skill/:skillId`, `/career/skill-priority`, `/career/resources`, `/career/resource/:resourceId`, `/career/goals`, `/career/goals/:goalId`, `/career/roadmap`, `/career/roadmap/milestones`, `/career/roadmap/milestones/:milestoneId`, `/career/progress`, `/career/assessment`, `/career/assessment/question`, `/career/assessment/result`, `/career/interview-practice`, `/career/interview-practice/question`, `/career/interview-practice/feedback`, `/career/ai-privacy` | `features/career_guidance/screens/*`; `features/career_guidance/{models,state,data}/*`; `features/career_guidance/widgets/*` | Static demo resources and rule-based/in-session progress, assessment, goal, and interview data; no AI service or learning-provider integration. |
| Employer | `/employer/signup`, `/employer/login`, `/employer/company/setup`, `/employer/company/profile`, `/employer/company/verification`, `/employer/dashboard`, `/employer/jobs`, `/employer/jobs/create/step-1`, `/employer/jobs/create/step-2`, `/employer/jobs/create/preview`, `/employer/jobs/submit`, `/employer/jobs/pending`, `/employer/jobs/:jobId/edit`, `/employer/jobs/:jobId`, `/employer/candidates/filters`, `/employer/candidates/:candidateId/invite`, `/employer/candidates/:candidateId`, `/employer/candidates`, `/employer/shortlist`, `/employer/interviews` | `features/employer/screens/*`; `features/employer/{models,state}/*` | Company, listing, candidate, shortlist and interview flows are local demo state; no real account, company verification, job publishing, email, or applicant data source. |
| Admin | `/admin/login`, `/admin/dashboard`, `/admin/companies/pending`, `/admin/companies/:companyId/review`, `/admin/companies/:companyId/approve`, `/admin/companies/:companyId/reject`, `/admin/jobs/pending`, `/admin/jobs/:jobId/review`, `/admin/jobs/:jobId/approve`, `/admin/jobs/:jobId/reject`, `/admin/users`, `/admin/users/:userId`, `/admin/reports`, `/admin/reports/:reportId`, `/admin/skills`, `/admin/notifications`, `/admin/settings`, `/admin/empty`, `/admin/error`, `/admin/success` | `features/admin/screens/*`; `features/admin/{widgets,state}/*` | Admin queues, counts, moderation and user updates are demo state; no server-side authorization or persisted moderation records. |

## Existing models and state boundaries

- `CareerDraft` and related education/experience structures are defined in `features/student_profile/student_draft.dart` and exposed through `careerDraftProvider`.
- `Job` and `demoJobs` are in `features/jobs/models/job.dart`. Search query, draft/applied filters, sorting, and saved IDs are managed by `jobDiscoveryProvider` in `features/jobs/state/job_discovery_state.dart`.
- `ApplicationDraft` and `JobApplication` are in `features/jobs/models/job_application.dart`; `jobApplicationProvider` in `features/jobs/state/job_application_state.dart` stores drafts and submitted demo applications only in memory.
- Career guidance has its own models, demo data, and provider in `features/career_guidance/`.
- Employer and Admin each have separate local models/state providers. No API repository, HTTP client/service, token/session persistence layer, or shared backend DTO layer was found.
- Passwords and auth screens are not connected to an identity provider. CV selection does not upload file bytes to a server.

## Backend-relevant capability map

The UI implies these future API domains: authentication/session and roles; student profile/skills/interests/resumes; employer profile/company verification; jobs/search/skills/saved jobs; applications and employer candidate workflow; career assessment/matches/skill gaps/roadmaps/resources; notifications; administration/moderation/audit; dashboard aggregates.

Before implementation, API contracts need to distinguish server-persisted records from current demo-only affordances. In particular, demo-only analytics, verification marks, assessment feedback, match scores, and statuses must not be represented as real decisions or events without an explicit server-backed source.

## Risks and sequencing notes

1. Flutter command startup currently hangs without output, so the SDK/test baseline must be diagnosed before making Flutter integration changes.
2. No PostgreSQL connection details or credentials are present. Database-dependent work must use safe local development configuration and must not run destructive migrations.
3. No backend exists in this repository, so NestJS/Prisma would be a new subsystem, not an extension of an existing service.
4. API integration will eventually touch the six pre-existing modified Flutter files if auth/profile/CV screens are part of the first integration slice. Those files are intentionally untouched by this analysis and must be reviewed separately before any such edit.
5. Existing feature state resets with process lifetime; server persistence and offline/error/loading states will need explicit contracts rather than implicit assumptions.

## Current result

This commit records the application baseline only. It does not create a backend, alter Flutter behavior, add dependencies, or modify platform configuration.
