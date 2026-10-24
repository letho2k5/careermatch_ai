import 'package:careermatch_ai/app/career_match_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts on the splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CareerMatchApp()));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('CareerMatch AI'), findsOneWidget);
  });
}
