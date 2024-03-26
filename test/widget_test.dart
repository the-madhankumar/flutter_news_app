import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_yt/main.dart'; // Assuming this is the correct path to the main.dart file of your News App

void main() {
  testWidgets('Verify News App title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed.
    expect(find.text('News App'), findsOneWidget);
  });
}
