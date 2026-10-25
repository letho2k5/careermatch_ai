import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/employer/state/employer_demo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('ten admin routes are uniquely registered', () {
    final routes = appRouter.configuration.routes
        .whereType<GoRoute>()
        .where((route) => route.name?.startsWith('admin-') == true)
        .toList();
    expect(routes, hasLength(10));
    expect(routes.map((route) => route.path).toSet(), hasLength(10));
    expect(routes.map((route) => route.name).toSet(), hasLength(10));
  });

  testWidgets('admin login validates fields and opens demo dashboard', (
    tester,
  ) async {
    await _openApp(tester);
    appRouter.go('/admin/login');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Đăng nhập'));
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập email'), findsOneWidget);
    expect(find.text('Mật khẩu demo cần ít nhất 6 ký tự'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'moderator@example.edu',
    );
    await tester.enterText(find.byType(TextFormField).last, 'local-demo');
    await tester.ensureVisible(find.text('Đăng nhập'));
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();
    expect(find.text('Xin chào, Quản trị viên'), findsOneWidget);
  });

  testWidgets('dashboard counts equal pending company and job queues', (
    tester,
  ) async {
    await _openApp(tester);
    appRouter.go('/admin/dashboard');
    await tester.pumpAndSettle();
    expect(find.text('Doanh nghiệp chờ duyệt'), findsWidgets);
    expect(find.text('Tin chờ duyệt'), findsOneWidget);
    expect(find.text('3'), findsWidgets);

    appRouter.go('/admin/companies/pending');
    await tester.pumpAndSettle();
    expect(find.text('Công ty TNHH Công nghệ Sao Việt'), findsOneWidget);
    expect(find.text('ABC Digital Solutions JSC'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Tập đoàn Giáo dục FinTech Việt Nam'),
      260,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Tập đoàn Giáo dục FinTech Việt Nam'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    appRouter.go('/admin/jobs/pending');
    await tester.pumpAndSettle();
    expect(find.text('Backend Intern (Node.js / Go)'), findsOneWidget);
    expect(find.text('Junior UI/UX Designer'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Data Analyst Intern'),
      260,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Data Analyst Intern'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('company detail uses its id and handles unknown company IDs', (
    tester,
  ) async {
    await _openApp(tester);
    appRouter.go('/admin/companies/company-saoviet/review');
    await tester.pumpAndSettle();
    expect(find.text('Công ty TNHH Công nghệ Sao Việt'), findsOneWidget);
    expect(find.text('#DN-2024-089'), findsOneWidget);

    appRouter.go('/admin/companies/missing-company/review');
    await tester.pumpAndSettle();
    expect(find.text('Không tìm thấy doanh nghiệp'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('company approval updates state and pending count', (
    tester,
  ) async {
    final container = await _openApp(tester);
    appRouter.go('/admin/companies/company-saoviet/approve');
    await tester.pumpAndSettle();
    final confirmButton = find.widgetWithText(
      FilledButton,
      'Xác nhận phê duyệt',
    );
    expect(tester.widget<FilledButton>(confirmButton).onPressed, isNull);
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(
      container.read(employerDemoProvider).companyApplications.first.status,
      'Đã duyệt (demo)',
    );
    expect(find.text('Công ty TNHH Công nghệ Sao Việt'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets(
    'company rejection requires reason and removes company from queue',
    (tester) async {
      final container = await _openApp(tester);
      appRouter.go('/admin/companies/company-abc-digital/reject');
      await tester.pumpAndSettle();
      expect(find.text('ABC Digital Solutions JSC'), findsOneWidget);
      final rejectAction = find.byKey(
        const ValueKey('admin-company-reject-confirm'),
      );
      await tester.ensureVisible(rejectAction);
      final confirmButton = find.descendant(
        of: rejectAction,
        matching: find.byType(FilledButton),
      );
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng chọn lý do từ chối.'), findsOneWidget);

      await tester.ensureVisible(find.text('Thiếu giấy phép'));
      await tester.tap(find.text('Thiếu giấy phép'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(confirmButton);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      final application = container
          .read(employerDemoProvider)
          .companyApplications
          .firstWhere((item) => item.id == 'company-abc-digital');
      expect(application.status, 'Từ chối (demo)');
      expect(application.moderationReason, 'Thiếu giấy phép');
      expect(find.text('ABC Digital Solutions JSC'), findsNothing);
      expect(find.text('2'), findsOneWidget);
    },
  );

  testWidgets('job review is linked by id and handles unknown jobs', (
    tester,
  ) async {
    await _openApp(tester);
    appRouter.go('/admin/jobs/admin-job-backend-intern/review');
    await tester.pumpAndSettle();
    expect(find.text('Backend Intern (Node.js / Go)'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Node.js'),
      220,
      scrollable: _mainListScrollable(),
    );
    expect(find.text('Node.js'), findsOneWidget);

    appRouter.go('/admin/jobs/unknown-job/review');
    await tester.pumpAndSettle();
    expect(find.text('Không tìm thấy tin tuyển dụng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('job approval requires all checks and updates the queue', (
    tester,
  ) async {
    final container = await _openApp(tester);
    appRouter.go('/admin/jobs/admin-job-backend-intern/approve');
    await tester.pumpAndSettle();
    final checks = find.byType(CheckboxListTile);
    for (var index = 0; index < 3; index++) {
      await tester.ensureVisible(checks.at(index));
      await tester.tap(checks.at(index));
      await tester.pumpAndSettle();
    }
    final confirm = find.widgetWithText(FilledButton, 'Xác nhận duyệt demo');
    await tester.ensureVisible(confirm);
    await tester.tap(confirm);
    await tester.pumpAndSettle();

    final job = container
        .read(employerDemoProvider.notifier)
        .listing('admin-job-backend-intern');
    expect(job?.status, 'Đã duyệt (demo)');
    expect(find.text('Backend Intern (Node.js / Go)'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('job rejection requires a selected reason', (tester) async {
    final container = await _openApp(tester);
    appRouter.go('/admin/jobs/admin-job-uiux-junior/reject');
    await tester.pumpAndSettle();
    expect(find.text('Junior UI/UX Designer'), findsOneWidget);
    final rejectAction = find.byKey(const ValueKey('admin-job-reject-confirm'));
    await tester.ensureVisible(rejectAction);
    final confirmButton = find.descendant(
      of: rejectAction,
      matching: find.byType(FilledButton),
    );
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng chọn lý do từ chối.'), findsOneWidget);

    await tester.ensureVisible(find.text('Mức lương không phù hợp'));
    await tester.tap(find.text('Mức lương không phù hợp'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
    expect(
      container
          .read(employerDemoProvider.notifier)
          .listing('admin-job-uiux-junior')
          ?.status,
      'Từ chối (demo)',
    );
    expect(find.text('Junior UI/UX Designer'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });

  test(
    'admin demo seed uses Employer listing type without changing drafts',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(employerDemoProvider.notifier);
      expect(container.read(employerDemoProvider).listings, isEmpty);
      expect(container.read(employerDemoProvider).adminListings, hasLength(3));
      controller.setJobField('title', 'Phase 8 listing');
      controller.setJobField('department', 'Engineering');
      expect(controller.submitDraft(), isNotNull);
      expect(container.read(employerDemoProvider).listings, hasLength(1));
      expect(container.read(employerDemoProvider).adminListings, hasLength(3));
    },
  );
}

Future<ProviderContainer> _openApp(WidgetTester tester) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const CareerMatchApp(),
    ),
  );
  return container;
}

Finder _mainListScrollable() => find
    .descendant(
      of: find.byType(ListView).last,
      matching: find.byType(Scrollable),
    )
    .first;
