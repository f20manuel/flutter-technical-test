import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/app/data/models/series.dart';
import 'package:fluttertest/app/pages/auth_page.dart';
import 'package:fluttertest/app/pages/details_page.dart';
import 'package:fluttertest/app/pages/home_page.dart';
import 'package:fluttertest/app/pages/popular_series_page.dart';

void main() {
  Widget createWidgetForTesting({
    required Widget child,
    Object? arguments,
  }){
    return ProviderScope(
      child: MaterialApp(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            settings: RouteSettings(arguments: arguments),
            builder: (context) {
              return child;
            },
          );
        },
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

    // Check empty form
    await tester.tap(find.byKey(const Key('log_in_1')));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const Key('log_in_2')));
    await tester.pump();
    expect(find.text('This field is required'), findsWidgets);

    // Enter fail name
    await tester.enterText(find.byKey(const Key('name_field')), 'manuel');
    await tester.tap(find.byKey(const Key('log_in_2')));
    await tester.pump();
    expect(find.text('Not found name: manuel in our database'), findsOneWidget);

    // Enter incorrect password
    await tester.enterText(find.byKey(const Key('name_field')), 'maria');
    await tester.enterText(find.byKey(const Key('password_field')), '123456');
    await tester.tap(find.byKey(const Key('log_in_2')));
    await tester.pump();
    expect(find.text('Not found name: maria in our database'), findsNothing);
    expect(find.text('Password is incorrect'), findsOneWidget);
  });

  testWidgets('Home page testing', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const HomePage()));

    // Check titles sections
    expect(find.text('Home'), findsWidgets);

    tester.pump();
  });

  testWidgets('Popular details page testing', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const PopularSeriesPage(),
      arguments: PopularSeriesArguments(
        series: Series(
          id: 1,
          firstAirDate: DateTime.now(),
          genreIds: [],
          name: 'Series test',
        ),
      ),
    ));

    // Check series name
    expect(find.text('Series test'), findsWidgets);

    tester.pump();
  });

  testWidgets('Series details page testing', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(
      child: const DetailsPage(),
      arguments: DetailsArguments(
        series: Series(
          id: 1,
          firstAirDate: DateTime.now(),
          genreIds: [],
          name: 'Series test',
        ),
      ),
    ));

    // Check series name
    expect(find.text('Series test'), findsWidgets);

    tester.pump();
  });
}
