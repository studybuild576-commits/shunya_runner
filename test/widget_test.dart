import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shunya_runner/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Bas ye check karega ki app load ho raha hai bina crash ke
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GameWidget(game: ShunyaRunnerGame()),
        ),
      ),
    );

    expect(find.byType(GameWidget), findsOneWidget);
  });
}
