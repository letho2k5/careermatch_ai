import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/jobs/state/job_discovery_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('job filters and sort update the shared demo result list', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(jobDiscoveryProvider.notifier);

    expect(controller.results(), hasLength(6));
    controller.updateFilters(
      controller.state.filters.copyWith(types: {'Thực tập'}),
    );
    expect(controller.results(), hasLength(6));
    expect(controller.results(useDraftFilters: true), hasLength(4));
    controller.applyFilters();
    expect(controller.results(), hasLength(4));

    controller.updateFilters(
      controller.state.filters.copyWith(minimumMatch: 95),
    );
    expect(controller.results(), hasLength(4));
    expect(controller.results(useDraftFilters: true), hasLength(1));
    controller.applyFilters();
    expect(controller.results(), hasLength(1));
    expect(controller.results().single.id, 'fpt-backend');

    controller.updateFilters(JobFilters.defaults);
    controller.applyFilters();
    controller.setSort(JobSortOption.salary);
    expect(controller.results().first.salaryMax, 12000000);
    expect(controller.results().first.id, anyOf('vng-golang', 'axon-backend'));

    controller.toggleSaved('fpt-backend');
    expect(
      container.read(jobDiscoveryProvider).savedIds,
      contains('fpt-backend'),
    );
  });

  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('JB-01 to JB-10 routes render without overflow at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
      const routes = [
        '/jobs/home',
        '/jobs/search',
        '/jobs/suggestions?q=Back',
        '/jobs/results',
        '/jobs/filters',
        '/jobs/sort',
        '/jobs/fpt-backend',
        '/companies/fpt-software',
        '/jobs/recommended',
        '/jobs/fpt-backend/match',
      ];

      for (final route in routes) {
        appRouter.go(route);
        await tester.pumpAndSettle();
        final exception = tester.takeException();
        expect(
          exception,
          isNull,
          reason:
              '$route\n${exception is FlutterError ? exception.toStringDeep() : exception}',
        );
      }
    });
  }

  testWidgets('search suggestion updates query and opens matching results', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/jobs/suggestions?q=Back');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Backend Developer Intern'));
    await tester.pumpAndSettle();

    expect(find.text('1 việc làm'), findsOneWidget);
    expect(find.text('Thực tập sinh Lập trình Backend'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown job and company IDs show not found states', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));

    for (final route in [
      '/jobs/missing-job',
      '/jobs/missing-job/match',
      '/companies/missing-company',
    ]) {
      appRouter.go(route);
      await tester.pumpAndSettle();
      expect(find.textContaining('không tồn tại'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
