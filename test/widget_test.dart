import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_browser_app/main.dart';
import 'package:recipe_browser_app/screens/welcome_screen.dart';

void main() {
  testWidgets('App starts with WelcomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that WelcomeScreen is shown
    expect(find.text('Recipe Browser'), findsOneWidget);
    expect(find.text('Discover delicious recipes'), findsOneWidget);
    expect(find.text('Start Browsing'), findsOneWidget);
  });

  testWidgets('WelcomeScreen has correct UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Check for main elements
    expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    expect(find.text('Recipe Browser'), findsOneWidget);
    expect(find.text('Start Browsing'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Start Browsing button exists and is tappable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    // Find the button
    final button = find.text('Start Browsing');
    expect(button, findsOneWidget);

    // Verify it's tappable (though we won't navigate in test)
    await tester.tap(button);
    await tester.pump();
    // In a full test, we'd verify navigation
  });
}
