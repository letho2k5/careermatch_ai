import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/career_guidance/state/career_guidance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final size in [const Size(390, 844), const Size(320, 568)]) {
    testWidgets('CG-01 to CG-10 routes render at $size without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));

      const routes = [
        '/career',
        '/career/skills',
        '/career/skill-gap',
        '/career/missing-skill/docker-containerization',
        '/career/skill-priority',
        '/career/resources',
        '/career/resource/docker-101',
        '/career/goals',
        '/career/goals/backend-developer',
        '/career/roadmap',
      ];
      for (final route in routes) {
        appRouter.go(route);
        await tester.pumpAndSettle();
        final exception = tester.takeException();
        expect(exception, isNull, reason: '$route: $exception');
      }
    });
  }

  testWidgets('career goal selection is shared with detail and roadmap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CareerMatchApp(),
      ),
    );

    appRouter.go('/career/goals');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Data Analyst').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Xác nhận mục tiêu & xem lộ trình'));
    await tester.tap(find.text('Xác nhận mục tiêu & xem lộ trình'));
    await tester.pumpAndSettle();

    expect(
      container.read(careerGuidanceProvider).selectedGoalId,
      'data-analyst',
    );
    expect(find.text('Data Analyst'), findsWidgets);
    appRouter.go('/career/roadmap');
    await tester.pumpAndSettle();
    expect(find.text('Data Analyst'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unknown skill, resource and goal IDs show not found states', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    for (final route in [
      '/career/missing-skill/not-real',
      '/career/resource/not-real',
      '/career/goals/not-real',
    ]) {
      appRouter.go(route);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Không tìm thấy'),
        findsWidgets,
        reason: route,
      );
      expect(tester.takeException(), isNull, reason: route);
    }
  });

  testWidgets('invalid career route uses the router error screen', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/career/not-a-screen');
    await tester.pumpAndSettle();
    expect(find.textContaining('/career/not-a-screen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
