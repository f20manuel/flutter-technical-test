import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/app/pages/auth_page.dart';
import 'package:fluttertest/app/pages/details_page.dart';
import 'package:fluttertest/app/pages/home_page.dart';
import 'package:fluttertest/app/pages/popular_series_page.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}){
    return ProviderScope(
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Auth page testing', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: AuthPage()));

    // CheckWidgets
    // Create list of ElevateButton's from screen
    var buttons = tester.widgetList(find.byType(ElevatedButton));
    // Check that list have 3 elements
    expect(buttons.length, 3);

    // Check Text's from screen
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.text('Log in'), findsWidgets);
    expect(find.text('Forgot password?'), findsOneWidget);

    // Check of Icon's from screen
    var icons = tester.widgetList(find.byType(Icon));
    // Check that list have 2 elements
    expect(icons.length, 2);

    // Create list of Text's of screen
    var fields = tester.widgetList(find.byType(TextFormField));
    // Check that list have 2 elements
    expect(fields.length, 2);

    tester.pump();
  });

  testWidgets('Home page testing', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const HomePage()));

    tester.pump();
  });

  testWidgets('Popular details page testing', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PopularSeriesPage(),
    ));

    tester.pump();
  });

  testWidgets('Series details page testing', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const DetailsPage(),
    ));

    tester.pump();
  });
}
