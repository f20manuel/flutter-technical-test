import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/navigation/route_name.dart';
import 'package:fluttertest/app/core/theme/colors.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';
import 'package:fluttertest/app/data/http/http_client.dart';
import 'package:fluttertest/app/data/models/series.dart';
import 'package:fluttertest/app/pages/popular_series_page.dart';
import 'package:fluttertest/app/widgets/image.dart';
import 'package:skeletons/skeletons.dart';

/// States
final StateProvider<int> pageIndexProvider = StateProvider<int>((ref) => 0);

/// Get popular series
final futureSeriesProvider = FutureProvider.autoDispose<List<Series>>(
(ref) async {
  final Response response = await fetchGet(
    '/tv/popular',
    parameters: <String, dynamic>{
      'page': 1,
    },
  );
  final List<Series> series = <Series>[];
  for (final Map<String, dynamic> json in response.data['results']) {
    final Series seriesModel = Series(
      id: json['id'],
      backdropPath: json['backdrop_path'],
      firstAirDate: DateTime.parse(json['first_air_date']),
      genreIds: json['genre_ids'],
      name: json['name'],
      rate: double.parse(json['vote_average'].toString()) / 2,
    );
    series.add(seriesModel);
  }
  return series;
});

/// Get recommendations
final futureRecommendationsProvider = FutureProvider.autoDispose<List<Series>>(
(ref) async {
  final Response response = await fetchGet(
    '/tv/top_rated',
    parameters: <String, dynamic>{
      'page': 1,
    },
  );
  final List<Series> series = <Series>[];
  for (final Map<String, dynamic> json in response.data['results']) {
    final Series seriesModel = Series(
      id: json['id'],
      backdropPath: json['backdrop_path'],
      firstAirDate: DateTime.parse(json['first_air_date']),
      genreIds: json['genre_ids'],
      name: json['name'],
      rate: double.parse(json['vote_average'].toString()) / 2,
    );
    series.add(seriesModel);
  }
  return series;
});

/// Get recommendations


/// Home page
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);
    final AsyncValue<List<Series>> series = ref.watch(futureSeriesProvider);
    final AsyncValue<List<Series>> recommendations = ref.watch(
      futureSeriesProvider,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.auth,
              (route) => false,
            ),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: pageIndex == 1
      ? Container()
      : pageIndex == 2
        ? Container()
        : pageIndex == 3
          ? Container()
          : SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Popular',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.merge(const TextStyle(
                      color: Colors.white,
                    )),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                  child: series.when(
                      loading: () => SkeletonListView(
                        itemCount: 4,
                        item: const SkeletonLine(
                          style: SkeletonLineStyle(
                            width: 150,
                            height: 300,
                          ),
                        ),
                      ),
                      error: (err, stack) => Text('Error: $err'),
                      data: (List<Series> data) {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (BuildContext context, int index) =>
                              Container(
                                width: 24,
                              ),
                          itemCount: data.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (BuildContext context, int index) {
                            Series item = data[index];
                            return SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteName.popularSeries,
                                        arguments: PopularSeriesArguments(
                                          series: item,
                                        ),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.zero,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AppNetworkImage(
                                        pathWidth: ImageWidth.w400,
                                        path: item.backdropPath,
                                        width: 150,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.name,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme
                                        .titleSmall,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: RatingBar.builder(
                                      initialRating: item.rate ?? 3,
                                      itemCount: 5,
                                      allowHalfRating: true,
                                      itemPadding: const EdgeInsets
                                          .symmetric(horizontal: 1.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star_rounded,
                                        color: CompanyColors.grey
                                            .withOpacity(0.7),
                                      ),
                                      itemSize: 12,
                                      onRatingUpdate: (_) {},
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Text(
                                'See All',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.merge(const TextStyle(
                                  color: CompanyColors.primary,
                                )),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: CompanyColors.primary,
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Recommendations',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.merge(const TextStyle(
                      color: Colors.white,
                    )),
                  ),
                ),
                recommendations.when(
                  loading: () => Container(),
                  data: (List<Series> data) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: data.map((Series item) => Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AppNetworkImage(
                                      pathWidth: ImageWidth.w300,
                                      path: item.backdropPath,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text(
                                            item.name,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context).textTheme
                                                .titleSmall,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 8),
                                            child: RatingBar.builder(
                                              initialRating: item.rate ?? 3,
                                              itemCount: 5,
                                              allowHalfRating: true,
                                              itemPadding: const EdgeInsets
                                                  .symmetric(horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star_rounded,
                                                color: CompanyColors.grey
                                                    .withOpacity(0.7),
                                              ),
                                              itemSize: 12,
                                              onRatingUpdate: (_) {},
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 28,
                                            ),
                                            child: Text(
                                              'IMDb: ${(item.rate ?? 0 * 2)
                                                  .toString()}',
                                              style: Theme.of(context).textTheme
                                                  .titleSmall
                                              ?.merge(const TextStyle(
                                                color: CompanyColors.grey,
                                                fontSize: 9,
                                              )),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 128,
                                                height: 39,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text('Watch now')
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.favorite_border_rounded,
                                                ),
                                                color: CompanyColors.grey,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Divider(),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    );
                  },
                  error: (err, stack) => Text('Error: $err'),
                )
              ]
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons. home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.replay_rounded),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
        ],
        onTap: (int index) {
          ref.read(pageIndexProvider.notifier).state = index;
        }
      ),
    );
  }
}
