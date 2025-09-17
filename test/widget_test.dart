import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shunya_runner/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Dummy test just to check widget builds
    expect(find.byType(GameWidget), findsOneWidget);
  });
}
