import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/career_guidance/data/career_guidance_demo_data.dart';
import 'package:careermatch_ai/features/career_guidance/state/career_guidance_state.dart';
import 'package:careermatch_ai/features/student_profile/student_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const phaseSixRoutes = <String>[
    '/career/roadmap/milestones',
    '/career/roadmap/milestones/not-a-real-milestone',
    '/career/progress',
    '/career/assessment',
    '/career/assessment/question',
    '/career/assessment/result',
    '/career/interview-practice',
    '/career/interview-practice/question',
    '/career/interview-practice/feedback',
    '/career/ai-privacy',
  ];

  for (final size in const [Size(390, 844), Size(320, 568)]) {
    testWidgets('CG phase 6 routes build at ${size.width}x${size.height}', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
      for (final route in phaseSixRoutes) {
        appRouter.go(route);
        await tester.pumpAndSettle();
        expect(find.byType(Scaffold), findsWidgets, reason: route);
        expect(tester.takeException(), isNull, reason: route);
      }
    });
  }

  testWidgets('assessment retains answers and calculates result from choices', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/career/assessment');
    await tester.pumpAndSettle();
    final consent = find.byType(CheckboxListTile).first;
    await tester.ensureVisible(consent);
    await tester.tap(consent);
    await tester.pumpAndSettle();
    final start = find.text('Bắt đầu tự đánh giá');
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();

    // Pick a deliberately incorrect answer, then move back and verify it is
    // still selected before continuing through the remaining questions.
    var options = find.byType(RadioListTile<int>);
    await tester.ensureVisible(options.at(1));
    await tester.tap(options.at(1));
    await tester.pumpAndSettle();
    final next = find.text('Tiếp theo');
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();

    final previous = find.text('Trước');
    await tester.ensureVisible(previous);
    await tester.tap(previous);
    await tester.pumpAndSettle();
    expect(
      tester.widget<RadioGroup<int>>(find.byType(RadioGroup<int>)).groupValue,
      1,
    );

    final continueButton = find.text('Tiếp theo');
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    for (var i = 1; i < skillAssessmentQuestions.length; i++) {
      // Reacquire the finder on every question because navigation rebuilds the
      // radio group and changes which options are on screen.
      options = find.byType(RadioListTile<int>);
      await tester.ensureVisible(options.first);
      await tester.tap(options.first);
      await tester.pumpAndSettle();
      if (i < skillAssessmentQuestions.length - 1) {
        final nextQuestion = find.text('Tiếp theo');
        await tester.ensureVisible(nextQuestion);
        await tester.tap(nextQuestion);
        await tester.pumpAndSettle();
      }
    }
    final showResult = find.text('Xem kết quả');
    await tester.ensureVisible(showResult);
    await tester.tap(showResult);
    await tester.pumpAndSettle();
    expect(find.text('9/${skillAssessmentQuestions.length}'), findsOneWidget);
    expect(find.text('Bạn chọn: Mở cổng mạng cho container'), findsOneWidget);
    expect(
      find.textContaining('Kết quả demo từ đáp án bạn chọn'),
      findsOneWidget,
    );
  });

  testWidgets('interview response is preserved in local session feedback', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/career/interview-practice/question');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField),
      'Tôi tìm vấn đề, thêm index và đo kết quả.',
    );
    await tester.pump();
    final action = find.text('Xem phản hồi demo');
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Tôi tìm vấn đề, thêm index và đo kết quả.'),
      findsOneWidget,
    );
    expect(find.textContaining('không phải AI'), findsOneWidget);
  });

  testWidgets('milestone task state is shared with progress tracking', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    const milestoneId =
        'backend-developer-docker-containerization-cicd-pipeline';
    appRouter.go('/career/roadmap/milestones/$milestoneId');
    await tester.pumpAndSettle();
    expect(find.textContaining('Milestone này không có'), findsNothing);
    final taskTitle = find.text('1. Cài đặt Docker và kiến trúc container');
    await tester.ensureVisible(taskTitle);
    final taskCheckbox = find.ancestor(
      of: taskTitle,
      matching: find.byType(CheckboxListTile),
    );
    await tester.ensureVisible(taskCheckbox);
    await tester.tap(taskCheckbox);
    await tester.pumpAndSettle();
    expect(find.textContaining('1/5 nhiệm vụ'), findsOneWidget);
    appRouter.go('/career/progress');
    await tester.pumpAndSettle();
    final totalTasks = milestonesForGoal(
      careerGoals.first,
      const CareerDraft(),
    ).fold<int>(0, (total, milestone) => total + milestone.tasks.length);
    expect(find.text('1 / $totalTasks nhiệm vụ tự đánh dấu'), findsOneWidget);
  });

  test(
    'default milestone demo data and assessment question set are available',
    () {
      final milestones = milestonesForGoal(
        careerGoals.first,
        const CareerDraft(),
      );
      expect(milestones, isNotEmpty);
      expect(skillAssessmentQuestions, hasLength(10));
      expect(const CareerGuidanceState().assessmentAnswers, isEmpty);
    },
  );
}
