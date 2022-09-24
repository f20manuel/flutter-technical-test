import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/navigation/route_name.dart';
import 'package:fluttertest/app/core/theme/colors.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';
import 'package:fluttertest/app/data/models/series.dart';
import 'package:fluttertest/app/pages/details_page.dart';
import 'package:fluttertest/app/widgets/image.dart';

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
            title: Text(
              'Popular',
              style: Theme.of(context).textTheme.titleSmall
                  ?.merge(
                const TextStyle(color: CompanyColors.grey),
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AppNetworkImage(
                      pathWidth: ImageWidth.w500,
                      path: args.series.backdropPath,
                      width: 240,
                      height: 340,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  args.series.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme
                      .titleLarge,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: RatingBar.builder(
                    initialRating: args.series.rate ?? 3,
                    itemCount: 5,
                    allowHalfRating: true,
                    itemPadding: const EdgeInsets
                        .symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_rounded,
                      color: CompanyColors.grey
                          .withOpacity(0.7),
                    ),
                    itemSize: 24,
                    onRatingUpdate: (_) {},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 8,
                    bottom: 28,
                  ),
                  child: Text(
                    'IMDb: ${((args.series.rate ?? 0) * 2)
                        .toString()}',
                    style: Theme.of(context).textTheme
                        .titleSmall
                        ?.merge(const TextStyle(
                      color: CompanyColors.grey,
                    )),
                  ),
                ),
                SizedBox(
                  width: 128,
                  height: 39,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.detailsSeries,
                          arguments:
                          DetailsArguments(
                            series: args.series,
                          ),
                        );
                      },
                      child: const Text('Watch now')
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
