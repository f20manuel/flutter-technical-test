import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/navigation/routes.dart';
import 'package:fluttertest/app/core/theme/themes.dart';
import 'package:fluttertest/app/pages/auth_page.dart';

void main() async {
  await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Technical Test',
      theme: Themes.mainTheme,
      routes: routes,
    );
  }
}
