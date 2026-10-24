import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/student_home/student_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('the router declares 40 unique screen paths and names', () {
    final screens = appRouter.configuration.routes
        .whereType<GoRoute>()
        .where((route) => route.path != '/')
        .toList();
    final paths = screens.map((route) => route.path).toSet();
    final names = screens.map((route) => route.name).toSet();

    expect(screens, hasLength(40));
    expect(paths, hasLength(40));
    expect(names, hasLength(40));
  });

  testWidgets('all ten named routes build their expected screen', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    const routes = <String, String>{
      '/welcome': 'Định hình tương lai nghề nghiệp của bạn',
      '/onboarding-one': 'Khám phá việc làm phù hợp thực tế',
      '/onboarding-two': 'Nhận diện khoảng trống & lộ trình kỹ năng',
      '/choose-role': 'Bạn là ai?',
      '/student-signup': 'Tạo tài khoản sinh viên',
      '/email-verification': 'Xác thực email của bạn',
      '/student-login': 'Chào mừng trở lại! 👋',
      '/forgot-password': 'Quên mật khẩu?',
      '/reset-password': 'Thiết lập mật khẩu mới',
    };
    appRouter.go('/splash');
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    for (final entry in routes.entries) {
      appRouter.go(entry.key);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget, reason: entry.key);
    }
  });

  testWidgets('welcome start enters onboarding and onboarding advances', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/welcome');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bắt đầu ngay'));
    await tester.tap(find.text('Bắt đầu ngay'));
    await tester.pumpAndSettle();
    expect(find.text('Khám phá việc làm phù hợp thực tế'), findsOneWidget);
    await tester.ensureVisible(find.text('Tiếp tục'));
    await tester.tap(find.text('Tiếp tục'));
    await tester.pumpAndSettle();
    expect(
      find.text('Nhận diện khoảng trống & lộ trình kỹ năng'),
      findsOneWidget,
    );
  });

  testWidgets('unknown routes show the router error screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/not-a-real-route');
    await tester.pumpAndSettle();
    expect(find.textContaining('/not-a-real-route'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('valid demo login routes to the student home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/student-login');
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'student@example.edu',
    );
    await tester.enterText(find.byType(TextFormField).last, 'demo-password');
    final loginButton = find.byType(FilledButton).first;
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(StudentAppShell), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('signup validates required student information', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/student-signup');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(FilledButton).first);
    await tester.tap(find.byType(FilledButton).first);
    await tester.pumpAndSettle();
    expect(find.text('Nhập họ và tên'), findsOneWidget);
    expect(find.text('Nhập email hợp lệ'), findsOneWidget);
  });
}
