import 'package:flutter/material.dart';
import 'package:fluttertest/app/core/navigation/route_name.dart';
import 'package:fluttertest/app/pages/auth_page.dart';
import 'package:fluttertest/app/pages/details_page.dart';
import 'package:fluttertest/app/pages/home_page.dart';
import 'package:fluttertest/app/pages/popular_series_page.dart';

/// Routes
final Map<String, Widget Function(BuildContext)> routes =
<String, Widget Function(BuildContext)>{
  RouteName.auth: (_) => AuthPage(),
  RouteName.home: (_) => const HomePage(),
  RouteName.popularSeries: (_) => const PopularSeriesPage(),
  RouteName.detailsSeries: (_) => const DetailsPage(),
};
