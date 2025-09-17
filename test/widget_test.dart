import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart'; // ✅ for GameWidget
import 'package:shunya_runner/main.dart';

void main() {
  testWidgets('GameWidget loads smoke test', (WidgetTester tester) async {
    // Build our game widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GameWidget(game: ShunyaRunnerGame()),
        ),
      ),
    );

    // Verify that GameWidget is present
    expect(find.byType(GameWidget), findsOneWidget);
  });
}
