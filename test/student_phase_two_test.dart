import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/student_home/student_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    appRouter.go('/student-home');
  });

  testWidgets('ST-11 to ST-20 routes render their student shell', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));

    const routes = <String>[
      '/student-home',
      '/student-profile-setup-1',
      '/student-profile-setup-2',
      '/education',
      '/student-skills',
      '/student-experience',
      '/cv-upload',
      '/cv-progress',
      '/cv-analysis-result',
      '/cv-edit-skills',
    ];

    for (final route in routes) {
      appRouter.go(route);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(StudentAppShell), findsOneWidget, reason: route);
      expect(tester.takeException(), isNull, reason: route);
    }
  });

  testWidgets('profile setup exposes editable form fields and actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/student-profile-setup-1');
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsAtLeastNWidgets(3));
    expect(find.byType(FilledButton), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile setup remains scrollable with the keyboard open', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/student-profile-setup-1');
    await tester.pumpAndSettle();
    final firstField = find.byType(TextFormField).first;
    await tester.ensureVisible(firstField);
    await tester.tap(firstField);
    await tester.showKeyboard(firstField);
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pump();

    final primaryAction = find.byType(FilledButton).first;
    await tester.ensureVisible(primaryAction);
    expect(primaryAction, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ST-01 to ST-20 do not overflow on a short narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    const routes = <String>[
      '/splash',
      '/welcome',
      '/onboarding-one',
      '/onboarding-two',
      '/choose-role',
      '/student-signup',
      '/email-verification',
      '/student-login',
      '/forgot-password',
      '/reset-password',
      '/student-home',
      '/student-profile-setup-1',
      '/student-profile-setup-2',
      '/education',
      '/student-skills',
      '/student-experience',
      '/cv-upload',
      '/cv-progress',
      '/cv-analysis-result',
      '/cv-edit-skills',
    ];

    for (final route in routes) {
      appRouter.go(route);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(tester.takeException(), isNull, reason: route);
    }
  });
}
