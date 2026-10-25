import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('ten employer routes have distinct paths and names', () {
    final routes = appRouter.configuration.routes
        .whereType<GoRoute>()
        .where((route) => route.name?.startsWith('employer-') == true)
        .toList();
    expect(routes, hasLength(10));
    expect(routes.map((route) => route.path).toSet(), hasLength(10));
    expect(routes.map((route) => route.name).toSet(), hasLength(10));
  });

  testWidgets('employer signup validates required fields and email', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/employer/signup');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tạo tài khoản'));
    await tester.tap(find.text('Tạo tài khoản').last);
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập Người đại diện'), findsOneWidget);

    final email = find.byType(TextFormField).at(1);
    await tester.ensureVisible(email);
    await tester.enterText(email, 'invalid');
    await tester.ensureVisible(find.text('Tạo tài khoản').last);
    await tester.tap(find.text('Tạo tài khoản').last);
    await tester.pumpAndSettle();
    expect(find.text('Email chưa hợp lệ'), findsOneWidget);
  });

  testWidgets('employer login validates and opens demo dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/employer/login');
    await tester.pumpAndSettle();
    final submitButton = find.widgetWithText(FilledButton, 'Đăng nhập');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập Email công việc'), findsOneWidget);

    final email = find.byType(TextFormField).first;
    await tester.enterText(email, 'recruiter@example.com');
    final password = find.byType(TextFormField).last;
    await tester.enterText(password, 'demo-password');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    expect(find.text('Quản trị cơ hội nghề nghiệp'), findsOneWidget);
    expect(
      find.textContaining('không phải analytics trực tiếp'),
      findsOneWidget,
    );
  });

  testWidgets(
    'employer dashboard renders and job search filters demo listings',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
      appRouter.go('/employer/dashboard');
      await tester.pumpAndSettle();
      expect(find.text('Quản trị cơ hội nghề nghiệp'), findsOneWidget);
      expect(find.text('142'), findsOneWidget);

      appRouter.go('/employer/jobs');
      await tester.pumpAndSettle();
      expect(find.text('Backend Developer Intern'), findsOneWidget);
      expect(find.text('DevOps / Cloud Engineer'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'DevOps');
      await tester.pumpAndSettle();
      expect(find.text('DevOps / Cloud Engineer'), findsOneWidget);
      expect(find.text('Backend Developer Intern'), findsNothing);
      await tester.enterText(find.byType(TextField).first, 'no matching title');
      await tester.pumpAndSettle();
      expect(
        find.text('Không có tin nào khớp từ khóa tìm kiếm.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('company setup requires fields and shows saved demo profile', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/employer/company/setup');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu hồ sơ công ty'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập Tên pháp lý công ty'), findsOneWidget);

    const values = <String, String>{
      'Tên pháp lý công ty': 'Công ty Demo',
      'Mã số thuế': '0123456789',
      'Quy mô nhân sự': '50-200',
      'Lĩnh vực hoạt động': 'Công nghệ',
      'Địa chỉ trụ sở': 'TP. Hồ Chí Minh',
    };
    for (final entry in values.entries) {
      final field = find
          .byType(TextFormField)
          .at(values.keys.toList().indexOf(entry.key));
      await tester.ensureVisible(field);
      await tester.enterText(field, entry.value);
    }
    await tester.tap(find.text('Lưu hồ sơ công ty'));
    await tester.pumpAndSettle();
    expect(find.text('Công ty Demo'), findsOneWidget);
    expect(find.text('TP. Hồ Chí Minh'), findsOneWidget);
    expect(find.textContaining('không được xác minh'), findsOneWidget);
  });

  testWidgets('job creation retains entered fields and preview reflects them', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    appRouter.go('/employer/jobs/create/step-1');
    await tester.pumpAndSettle();
    await _enterJobField(tester, 0, 'Backend Developer Intern');
    await _enterJobField(tester, 1, 'Global Cloud & AI Solutions');
    await _enterJobField(tester, 2, 'TP. Hồ Chí Minh');
    await _enterJobField(tester, 3, '8.000.000');
    await _enterJobField(tester, 4, '12.000.000');
    await _enterJobField(tester, 5, '5');
    await _enterJobField(tester, 6, '31/12/2026');
    await _enterJobField(tester, 7, 'Phát triển dịch vụ backend demo');
    await tester.ensureVisible(find.text('Tiếp tục: Kỹ năng & AI Match'));
    await tester.tap(find.text('Tiếp tục: Kỹ năng & AI Match'));
    await tester.pumpAndSettle();
    expect(find.text('Trọng số Kỹ năng & AI Match Score'), findsOneWidget);

    await _enterJobField(tester, 0, 'Python / FastAPI, PostgreSQL');
    await _enterJobField(tester, 1, '80');
    await tester.ensureVisible(find.text('Xem trước tin tuyển dụng'));
    await tester.tap(find.text('Xem trước tin tuyển dụng'));
    await tester.pumpAndSettle();
    expect(find.text('Backend Developer Intern'), findsOneWidget);
    expect(find.text('Python / FastAPI'), findsOneWidget);
    expect(find.textContaining('chưa được xuất bản'), findsOneWidget);
  });
}

Future<void> _enterJobField(
  WidgetTester tester,
  int index,
  String value,
) async {
  final field = find.byType(TextFormField).at(index);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pump();
}
