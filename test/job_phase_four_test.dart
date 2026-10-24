import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/jobs/state/job_application_state.dart';
import 'package:careermatch_ai/features/jobs/state/job_discovery_state.dart';
import 'package:careermatch_ai/features/student_profile/student_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('JB-11 to JB-20 routes build at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
      final routes = [
        '/jobs/fpt-backend/compare-skills',
        '/jobs/saved',
        '/jobs/fpt-backend/save-confirmation',
        '/jobs/fpt-backend/apply',
        '/jobs/fpt-backend/select-cv',
        '/jobs/fpt-backend/application-review',
        '/applications/demo-id/success',
        '/applications',
        '/applications/demo-id',
        '/applications/demo-id/timeline',
      ];

      for (final route in routes) {
        appRouter.go(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: route);
      }
    });
  }

  testWidgets('application flow creates a local demo record and timeline', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(careerDraftProvider.notifier)
        .update(
          container
              .read(careerDraftProvider)
              .copyWith(
                fullName: 'Nguyen Van An',
                university: 'HCMUT',
                phone: '0912345678',
                cvName: 'resume.pdf',
                cvBytes: 1024,
              ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CareerMatchApp(),
      ),
    );
    appRouter.go('/jobs/fpt-backend/apply');
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(1), 'an@example.edu');
    await tester.ensureVisible(find.text('Tiếp tục: Chọn CV nộp đơn'));
    await tester.tap(find.text('Tiếp tục: Chọn CV nộp đơn'));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có CV trong bộ nhớ phiên này.'), findsNothing);
    await tester.tap(find.text('resume.pdf'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tiếp tục: Xem lại hồ sơ'));
    await tester.tap(find.text('Tiếp tục: Xem lại hồ sơ'));
    await tester.pumpAndSettle();

    expect(find.text('Nguyen Van An'), findsWidgets);
    await tester.ensureVisible(find.text('Xác nhận tạo bản ghi demo'));
    await tester.tap(find.text('Xác nhận tạo bản ghi demo'));
    await tester.pumpAndSettle();

    expect(find.text('Đã tạo bản ghi ứng tuyển demo'), findsOneWidget);
    expect(container.read(jobApplicationProvider).applications, hasLength(1));
    expect(
      container.read(jobApplicationProvider).applications.single.cvName,
      'resume.pdf',
    );

    final id = container.read(jobApplicationProvider).applications.single.id;
    appRouter.go('/applications/$id/timeline');
    await tester.pumpAndSettle();
    expect(find.text('Đã tạo bản ghi ứng tuyển demo'), findsOneWidget);
    expect(find.text('Phỏng vấn'), findsOneWidget);
    expect(find.text('Chưa có lịch phỏng vấn.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('application record and timeline reject unknown IDs', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    for (final route in [
      '/applications/unknown',
      '/applications/unknown/timeline',
      '/applications/unknown/success',
    ]) {
      appRouter.go(route);
      await tester.pumpAndSettle();
      expect(find.textContaining('Không tìm thấy'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'saved-job state is shared and confirmation reflects the update',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const CareerMatchApp(),
        ),
      );
      container.read(jobDiscoveryProvider.notifier).toggleSaved('fpt-backend');
      appRouter.go('/jobs/saved');
      await tester.pumpAndSettle();
      expect(find.text('Thực tập sinh Lập trình Backend'), findsOneWidget);

      appRouter.go('/jobs/fpt-backend/save-confirmation');
      await tester.pumpAndSettle();
      expect(find.text('Đã lưu việc làm'), findsOneWidget);
      expect(
        container.read(jobDiscoveryProvider).savedIds,
        contains('fpt-backend'),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
