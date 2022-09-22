import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/theme/colors.dart';
import 'package:fluttertest/app/data/models/series.dart';

/// Popular series arguments
class PopularSeriesArguments {
  final Series series;
  final List<Series>? othersSeries;

  PopularSeriesArguments({
    required this.series,
    this.othersSeries,
  });
}

/// Popular series page
class PopularSeriesPage extends ConsumerWidget {
  const PopularSeriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PopularSeriesArguments args = ModalRoute.of(context)!.settings
        .arguments as PopularSeriesArguments;
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                CompanyColors.primary.withOpacity(0.005),
                CompanyColors.black,
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Popular'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[

              ],
            ),
          ),
        ),
      ],
    );
  }
}
