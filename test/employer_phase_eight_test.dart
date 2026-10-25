import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/employer/models/employer_demo_models.dart';
import 'package:careermatch_ai/features/employer/state/employer_demo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('submitted listing edits by id and shortlist avoids duplicates', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(employerDemoProvider.notifier);
    controller.setJobField('title', 'Backend Developer Intern');
    controller.setJobField('department', 'Engineering');
    final id = controller.submitDraft();
    expect(id, isNotNull);
    expect(controller.submitDraft(), isNull);
    expect(
      container.read(employerDemoProvider).listings.single.fields['title'],
      'Backend Developer Intern',
    );

    controller.setJobField('title', 'Second listing');
    final secondId = controller.submitDraft();
    expect(secondId, isNotNull);

    controller.updateListing(id!, {'title': 'Updated title'});
    final listings = container.read(employerDemoProvider).listings;
    expect(
      listings.firstWhere((item) => item.id == id).fields['title'],
      'Updated title',
    );
    expect(
      listings.firstWhere((item) => item.id == secondId).fields['title'],
      'Second listing',
    );
    controller.toggleShortlist('candidate-an');
    expect(container.read(employerDemoProvider).shortlistedCandidateIds, {
      'candidate-an',
    });
    controller.toggleShortlist('candidate-an');
    expect(
      container.read(employerDemoProvider).shortlistedCandidateIds,
      isEmpty,
    );
  });

  test(
    'interview invites are linked to candidate and job and deduplicated',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(employerDemoProvider.notifier);
      final invite = EmployerInterviewInvite(
        id: 'invite-1',
        candidateId: 'candidate-an',
        candidateName: 'Nguyễn Văn An',
        jobId: 'job-1',
        jobTitle: 'Backend Developer Intern',
        date: DateTime(2026, 10, 28),
        time: '09:00 - 09:45',
      );
      controller.addInterviewInvite(invite);
      controller.addInterviewInvite(invite);
      expect(
        container.read(employerDemoProvider).interviewInvites,
        hasLength(1),
      );
      expect(
        container
            .read(employerDemoProvider)
            .interviewInvites
            .single
            .candidateId,
        'candidate-an',
      );
      expect(
        container.read(employerDemoProvider).interviewInvites.single.jobId,
        'job-1',
      );
    },
  );

  testWidgets(
    'candidate filters change the displayed demo list and invalid IDs are not found',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const CareerMatchApp(),
        ),
      );
      appRouter.go('/employer/candidates/filters');
      await tester.pumpAndSettle();
      await tester.tap(find.text('At least 95%'));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(find.text('1 ứng viên phù hợp (demo)'), findsOneWidget);

      appRouter.go('/employer/candidates/unknown-id');
      await tester.pumpAndSettle();
      expect(find.text('Không tìm thấy ứng viên'), findsOneWidget);
    },
  );

  testWidgets(
    'interview invite requires a date before creating a local record',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final draft = container.read(employerDemoProvider.notifier);
      draft.setJobField('title', 'Backend Developer Intern');
      draft.setJobField('department', 'Engineering');
      draft.submitDraft();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const CareerMatchApp(),
        ),
      );
      appRouter.go('/employer/candidates/candidate-an/invite');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.event_available));
      await tester.pumpAndSettle();
      expect(container.read(employerDemoProvider).interviewInvites, isEmpty);
    },
  );

  testWidgets('all phase eight screens build from their registered routes', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final draft = container.read(employerDemoProvider.notifier);
    draft.setJobField('title', 'Backend Developer Intern');
    draft.setJobField('department', 'Engineering');
    final jobId = draft.submitDraft()!;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CareerMatchApp(),
      ),
    );
    final paths = [
      '/employer/jobs/submit',
      '/employer/jobs/pending?jobId=$jobId',
      '/employer/jobs/$jobId',
      '/employer/jobs/$jobId/edit',
      '/employer/candidates',
      '/employer/candidates/filters',
      '/employer/candidates/candidate-an',
      '/employer/shortlist',
      '/employer/candidates/candidate-an/invite',
      '/employer/interviews',
    ];
    for (final path in paths) {
      appRouter.go(path);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('phase eight routes are uniquely registered', (tester) async {
    final routes = appRouter.configuration.routes
        .whereType<GoRoute>()
        .where((r) => r.name?.startsWith('employer-') == true)
        .toList();
    expect(routes, hasLength(20));
    expect(routes.map((r) => r.path).toSet(), hasLength(20));
    expect(routes.map((r) => r.name).toSet(), hasLength(20));
  });
}
