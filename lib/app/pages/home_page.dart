import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/navigation/route_name.dart';
import 'package:fluttertest/app/core/theme/colors.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';
import 'package:fluttertest/app/data/http/http_client.dart';
import 'package:fluttertest/app/data/models/episode.dart';
import 'package:fluttertest/app/data/models/series.dart';
import 'package:fluttertest/app/pages/details_page.dart';
import 'package:fluttertest/app/pages/popular_series_page.dart';
import 'package:fluttertest/app/pages/recent_page.dart';
import 'package:fluttertest/app/widgets/image.dart';
import 'package:skeletons/skeletons.dart';

/// States
final StateProvider<int> pageIndexProvider = StateProvider<int>((ref) => 0);
final myFavoritesProvider = ChangeNotifierProvider<SeriesNotifier>((ref) {
  return SeriesNotifier();
});

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

/// Get Airing Today
final futureAiringTodayProvider = FutureProvider.autoDispose<List<Series>>(
  (ref) async {
    final Response response = await fetchGet(
      '/tv/airing_today',
      parameters: <String, dynamic>{
        'page': 1,
      },
    );
    final List<Series> series = <Series>[];
    for (final Map<String, dynamic> json in response.data['results']) {
      final Response response2 = await fetchGet('/tv/${json['id']}');
      final Series seriesModel = Series(
        id: json['id'],
        backdropPath: json['backdrop_path'],
        firstAirDate: DateTime.parse(json['first_air_date']),
        genreIds: json['genre_ids'],
        name: json['name'],
        rate: double.parse(json['vote_average'].toString()) / 2,
      );
      if (response2.data['seasons'].isNotEmpty) {
        final Response lastSeason = await fetchGet(
          '/tv/${json['id']}/season/${
            response2.data['seasons'].last['season_number']
          }',
        );
        seriesModel.episodesCount = lastSeason.data['episodes'].length;
        seriesModel.episodes = <Episode>[];
        for(final Map<String, dynamic> json in lastSeason.data['episodes']) {
          final Episode episode = Episode(
            id: json['id'],
            imagePath: json['still_path'],
            number: json['episode_number'],
            name: json['name'],
            year: int.parse(json['air_date'].split('-')[0]),
            seasonNumber: json['season_number'],
            description: json['overview'],
          );
          seriesModel.episodes!.add(episode);
        }
      }
      series.add(seriesModel);
    }
    return series;
  }
);

/// Home page
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);
    final myFavorites = ref.watch(myFavoritesProvider).myFavorites;
    final AsyncValue<List<Series>> series = ref.watch(futureSeriesProvider);
    final AsyncValue<List<Series>> recommendations = ref.watch(
      futureSeriesProvider,
    );
    final AsyncValue<List<Series>> airingToday = ref.watch(
      futureAiringTodayProvider,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageIndex == 1
          ? 'Favorites'
          : pageIndex == 2
            ? 'Recent'
            : pageIndex == 3
              ? 'Search'
              : 'Home',
          style: Theme.of(context).textTheme.titleSmall
          ?.merge(
            const TextStyle(color: CompanyColors.grey),
          ),
        ),
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
      ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: myFavorites.isEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height /2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Icon(
                      Icons.sentiment_dissatisfied_rounded,
                      size: 96,
                      color: CompanyColors.grey,
                    ),
                  ),
                  Text(
                    'No favorites',
                    style: Theme.of(context).textTheme.titleLarge
                    ?.merge(const TextStyle(
                      color: CompanyColors.grey,
                    )),
                  )
                ],
              ),
            )
          : Column(
            children: myFavorites.map((Series item) {
              return Container(
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
                                    'IMDb: ${((item.rate ?? 0) * 2)
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
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              RouteName.detailsSeries,
                                              arguments:
                                              DetailsArguments(
                                                series: item,
                                              ),
                                            );
                                          },
                                          child: const Text('Watch now')
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (item.isFavorite) {
                                          ref.read(
                                              myFavoritesProvider
                                                  .notifier
                                          ).removeFavorite(item);
                                        } else {
                                          ref.read(
                                              myFavoritesProvider
                                                  .notifier
                                          ).addFavorite(item);
                                        }
                                      },
                                      icon: Icon(
                                          item.isFavorite
                                              ? Icons.favorite_rounded
                                              : Icons
                                              .favorite_border_rounded
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
              );
            }).toList(),
          ),
        ),
      )
      : pageIndex == 2
        ? airingToday.when(
            loading: () => Container(),
            data: (List<Series> data) => ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final Series item = data[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AppNetworkImage(
                            pathWidth: ImageWidth.w400,
                            path: item.backdropPath,
                            width: 256,
                            height: 256,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Episodes ${item.episodesCount}',
                          style: Theme.of(context).textTheme.titleSmall
                          ?.merge(const TextStyle(
                            color: CompanyColors.grey,
                          )),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteName.detailsRecentSeason,
                              arguments: RecentArguments(
                                seriesTitle: item.name,
                                episodes: item.episodes ?? [],
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Go to view',
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            ),
            error: (err, stack) => Text('Error: $err'),
          )
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
                  height: 320,
                  child: series.when(
                      loading: () => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: List.generate(2, (_) =>
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                    right: 16,
                                    bottom: 8,
                                  ),
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                      width: 150,
                                      height: 200,
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                  ),
                                ),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    width: 100,
                                    height: 18,
                                    borderRadius: BorderRadius.circular(5),
                                  )
                                ),
                              ],
                            ),
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
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      item.name,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme
                                          .titleSmall,
                                    ),
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
                        ),
                      ),
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
                        children: data.map((Series item) {
                          return Container(
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
                                                'IMDb: ${((item.rate ?? 0) * 2)
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
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        RouteName.detailsSeries,
                                                        arguments:
                                                        DetailsArguments(
                                                          series: item,
                                                        ),
                                                      );
                                                    },
                                                    child: const Text('Watch now')
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    if (item.isFavorite) {
                                                      ref.read(
                                                          myFavoritesProvider
                                                              .notifier
                                                      ).removeFavorite(item);
                                                    } else {
                                                      ref.read(
                                                          myFavoritesProvider
                                                              .notifier
                                                      ).addFavorite(item);
                                                    }
                                                  },
                                                  icon: Icon(
                                                    item.isFavorite
                                                    ? Icons.favorite_rounded
                                                    : Icons
                                                      .favorite_border_rounded
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
                          );
                        }).toList(),
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
