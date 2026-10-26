import 'package:careermatch_ai/features/onboarding/screens/onboarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash remains scrollable with a very short viewport', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 64);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    await tester.pump();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('AI MATCHING ENGINE LIVE'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -24));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
