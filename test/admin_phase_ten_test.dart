import 'package:careermatch_ai/app/app_router.dart';
import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:careermatch_ai/features/admin/state/admin_operations_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('Phase 10 adds ten unique routes and brings total to 100', () {
    final routes = appRouter.configuration.routes.whereType<GoRoute>().toList();
    final namedRoutes = routes.where((route) => route.path != '/').toList();
    final phaseTen = routes
        .where((route) => route.name?.startsWith('admin-') == true)
        .toList();
    expect(namedRoutes, hasLength(100));
    expect(namedRoutes.map((route) => route.path).toSet(), hasLength(100));
    expect(namedRoutes.map((route) => route.name).toSet(), hasLength(100));
    expect(phaseTen, hasLength(20));
    expect(
      phaseTen.map((route) => route.name).toSet(),
      containsAll([
        'admin-users',
        'admin-user-detail',
        'admin-reports',
        'admin-report-detail',
        'admin-skills',
        'admin-notifications',
        'admin-settings',
        'admin-empty-state',
        'admin-error-state',
        'admin-success-state',
      ]),
    );
  });

  testWidgets('all ten Phase 10 screens open directly', (tester) async {
    await _pump(tester);
    const destinations = <String, String>{
      '/admin/users': 'Quản lý người dùng',
      '/admin/users/user-tran-minh-quan': 'Chi tiết người dùng',
      '/admin/reports': 'Báo cáo vi phạm',
      '/admin/reports/REP-2024-041': 'Chi tiết báo cáo',
      '/admin/skills': 'Danh mục kỹ năng',
      '/admin/notifications': 'Trung tâm thông báo',
      '/admin/settings': 'Cài đặt hệ thống',
      '/admin/empty': 'Trạng thái rỗng',
      '/admin/error': 'Trạng thái lỗi',
      '/admin/success': 'Thao tác hoàn tất',
    };
    for (final entry in destinations.entries) {
      appRouter.go(entry.key);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsWidgets, reason: entry.key);
      expect(tester.takeException(), isNull, reason: entry.key);
    }
  });

  testWidgets('unknown user and report IDs show not found states', (
    tester,
  ) async {
    await _pump(tester);
    appRouter.go('/admin/users/unknown-user');
    await tester.pumpAndSettle();
    expect(
      find.text('Không tìm thấy người dùng: unknown-user'),
      findsOneWidget,
    );
    appRouter.go('/admin/reports/unknown-report');
    await tester.pumpAndSettle();
    expect(find.text('Không tìm thấy báo cáo: unknown-report'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'user search filters, profile warning and lock update session state',
    (tester) async {
      final container = await _pump(tester);
      appRouter.go('/admin/users');
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('admin-user-search')),
        'Quan',
      );
      await tester.pumpAndSettle();
      expect(find.text('Trần Minh Quân'), findsOneWidget);
      expect(find.text('Nguyễn Bích Ngọc'), findsNothing);

      appRouter.go('/admin/users/user-tran-minh-quan');
      await tester.pumpAndSettle();
      expect(find.text('Chi tiết người dùng'), findsOneWidget);
      expect(
        container.read(adminOperationsProvider).users.first.warning,
        isFalse,
      );
      final warning = find.byKey(const ValueKey('admin-user-warning'));
      await tester.scrollUntilVisible(
        warning,
        240,
        scrollable: _mainScrollable(),
      );
      await tester.tap(warning);
      await tester.pumpAndSettle();
      expect(
        container.read(adminOperationsProvider).users.first.warning,
        isTrue,
      );
      final lock = find.byKey(const ValueKey('admin-user-toggle-lock'));
      await tester.scrollUntilVisible(lock, 240, scrollable: _mainScrollable());
      await tester.tap(lock);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Xác nhận'));
      await tester.pumpAndSettle();
      expect(
        container.read(adminOperationsProvider).users.first.status,
        'Đã khóa (demo)',
      );
    },
  );

  testWidgets('report processing updates state before success confirmation', (
    tester,
  ) async {
    final container = await _pump(tester);
    appRouter.go('/admin/reports/REP-2024-041');
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết báo cáo'), findsOneWidget);
    expect(container.read(adminOperationsProvider).reports, isNotEmpty);
    final action = find.byKey(const ValueKey('admin-report-processing'));
    await tester.scrollUntilVisible(action, 240, scrollable: _mainScrollable());
    expect(action, findsOneWidget);
    await tester.tap(action);
    await tester.pumpAndSettle();
    expect(
      container.read(adminOperationsProvider).reports.first.status,
      'Đang xử lý',
    );
    expect(find.text('Đã ghi nhận: Đang xử lý'), findsOneWidget);
    appRouter.pop();
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết báo cáo'), findsOneWidget);
    expect(
      container.read(adminOperationsProvider).reports.first.status,
      'Đang xử lý',
    );
  });

  testWidgets('enforcement report action validates its internal note', (
    tester,
  ) async {
    final container = await _pump(tester);
    appRouter.go('/admin/reports/REP-2024-041');
    await tester.pumpAndSettle();
    expect(find.text('Chi tiết báo cáo'), findsOneWidget);
    final hide = find.byKey(const ValueKey('admin-report-hide'));
    await tester.scrollUntilVisible(hide, 240, scrollable: _mainScrollable());
    expect(hide, findsOneWidget);
    await tester.tap(hide);
    await tester.pumpAndSettle();
    expect(
      find.text('Ghi chú cần có ít nhất 10 ký tự cho biện pháp này.'),
      findsOneWidget,
    );
    expect(
      container.read(adminOperationsProvider).reports.first.status,
      'Chưa xử lý',
    );

    await tester.enterText(
      find.byKey(const ValueKey('admin-report-notes')),
      'Đã kiểm tra bằng chứng',
    );
    await tester.scrollUntilVisible(hide, 240, scrollable: _mainScrollable());
    await tester.tap(hide);
    await tester.pumpAndSettle();
    expect(
      container.read(adminOperationsProvider).reports.first.status,
      'Đã ẩn nội dung (demo)',
    );
    expect(find.textContaining('Đã ghi nhận: Đã ẩn nội dung'), findsOneWidget);
  });

  testWidgets(
    'skill groups can be extended and toggled in shared session state',
    (tester) async {
      final container = await _pump(tester);
      appRouter.go('/admin/skills');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('admin-skill-add')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(1), 'An toàn dữ liệu');
      await tester.enterText(find.byType(TextField).at(2), 'Zero Trust');
      await tester.tap(find.widgetWithText(FilledButton, 'Lưu demo'));
      await tester.pumpAndSettle();
      expect(
        container.read(adminOperationsProvider).skillGroups.last.name,
        'An toàn dữ liệu',
      );
      expect(
        container.read(adminOperationsProvider).skillGroups.last.skills,
        contains('Zero Trust'),
      );

      final software = container
          .read(adminOperationsProvider)
          .skillGroups
          .first;
      container
          .read(adminOperationsProvider.notifier)
          .toggleSkillGroup(software.id, false);
      await tester.pumpAndSettle();
      expect(
        container.read(adminOperationsProvider).skillGroups.first.enabled,
        isFalse,
      );
    },
  );

  testWidgets(
    'notifications can be marked read and navigate to their destination',
    (tester) async {
      final container = await _pump(tester);
      appRouter.go('/admin/notifications');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('admin-notification-notice-report')),
        240,
        scrollable: _mainScrollable(),
      );
      await tester.tap(
        find.byKey(const ValueKey('admin-notifications-read-all')),
      );
      await tester.pumpAndSettle();
      expect(
        container
            .read(adminOperationsProvider)
            .notifications
            .where((item) => !item.read),
        isEmpty,
      );

      appRouter.go('/admin/notifications');
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('admin-notification-notice-report')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Chi tiết báo cáo'), findsOneWidget);
      expect(
        container
            .read(adminOperationsProvider)
            .notifications
            .firstWhere((item) => item.id == 'notice-report')
            .read,
        isTrue,
      );
    },
  );

  testWidgets(
    'settings switches update local state and logout returns to login',
    (tester) async {
      final container = await _pump(tester);
      appRouter.go('/admin/settings');
      await tester.pumpAndSettle();
      final scan = find.byKey(const ValueKey('admin-setting-auto_scan'));
      await tester.scrollUntilVisible(scan, 240, scrollable: _mainScrollable());
      await tester.tap(scan);
      await tester.pumpAndSettle();
      expect(
        container.read(adminOperationsProvider).settings['auto_scan'],
        isFalse,
      );
      final logout = find.text('Đăng xuất demo');
      await tester.scrollUntilVisible(
        logout,
        240,
        scrollable: _mainScrollable(),
      );
      await tester.tap(logout);
      await tester.pumpAndSettle();
      expect(find.text('Đăng nhập quản trị'), findsOneWidget);
    },
  );

  testWidgets('empty, error and success templates provide working actions', (
    tester,
  ) async {
    await _pump(tester);
    appRouter.go('/admin/empty');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('admin-empty-refresh')));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard quản trị'), findsOneWidget);

    appRouter.go('/admin/error');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('admin-error-retry')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đã thử lại 1 lần'), findsOneWidget);
    await tester.tap(find.text('Quay lại'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard quản trị'), findsOneWidget);

    appRouter.go('/admin/success');
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Không có dữ liệu nào được gửi'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('admin-success-continue')));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard quản trị'), findsOneWidget);
  });

  testWidgets('admin screens remain scrollable at mobile viewports', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _pump(tester);
    for (final size in [const Size(390, 844), const Size(320, 568)]) {
      tester.view.physicalSize = size;
      for (final path in [
        '/admin/users',
        '/admin/reports',
        '/admin/skills',
        '/admin/settings',
      ]) {
        appRouter.go(path);
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView).last, const Offset(0, -300));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$path at $size');
      }
    }
  });
}

Finder _mainScrollable() => find
    .descendant(
      of: find.byType(ListView).last,
      matching: find.byType(Scrollable),
    )
    .first;

Future<ProviderContainer> _pump(WidgetTester tester) async {
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
