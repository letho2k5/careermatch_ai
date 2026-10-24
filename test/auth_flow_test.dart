import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
