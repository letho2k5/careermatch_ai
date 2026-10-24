import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/student_profile/screens/education_screen.dart';
import 'package:careermatch_ai/features/student_profile/student_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('draft values remain in memory across route changes', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(careerDraftProvider.notifier)
        .update(
          container.read(careerDraftProvider).copyWith(fullName: 'An Nguyen'),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CareerMatchApp(),
      ),
    );
    appRouter.go('/student-profile-setup-1');
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller
          ?.text,
      'An Nguyen',
    );

    appRouter.go('/education');
    await tester.pumpAndSettle();
    appRouter.go('/student-profile-setup-1');
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller
          ?.text,
      'An Nguyen',
    );
  });

  testWidgets('education records can be added, edited, and deleted', (
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
        child: const MaterialApp(home: EducationScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    var fields = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), 'Audit university');
    await tester.enterText(fields.at(1), 'Bachelor');
    await tester.enterText(fields.at(2), '2022-2026');
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(FilledButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(container.read(careerDraftProvider).educationHistory, hasLength(1));
    expect(find.text('Audit university'), findsOneWidget);

    final editButton = find.byTooltip('Sửa học vấn');
    await tester.ensureVisible(editButton);
    await tester.tap(editButton);
    await tester.pumpAndSettle();
    fields = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(fields.at(0), 'Updated university');
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(FilledButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      container.read(careerDraftProvider).educationHistory.single.school,
      'Updated university',
    );

    await tester.tap(find.byTooltip('Xóa học vấn'));
    await tester.pumpAndSettle();
    expect(container.read(careerDraftProvider).educationHistory, isEmpty);
  });
}
