// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:careermatch_ai/app/career_match_app.dart';

void main() {
  testWidgets('foundation app starts with the shared theme and shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    expect(find.text('CareerMatch AI'), findsOneWidget);
    expect(find.text('Nền tảng giao diện đã sẵn sàng'), findsOneWidget);
    expect(find.text('Giai đoạn 0 hoàn tất'), findsOneWidget);
  });
}
