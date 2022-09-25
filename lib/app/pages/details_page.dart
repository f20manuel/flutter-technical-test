import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/theme/colors.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';
import 'package:fluttertest/app/data/http/http_client.dart';
import 'package:fluttertest/app/data/models/episode.dart';
import 'package:fluttertest/app/data/models/series.dart';
import 'package:fluttertest/app/widgets/image.dart';

/// Details arguments
class DetailsArguments {
  final Series series;

  DetailsArguments({
    required this.series,
  });
}

/// States
final myFavoritesProvider = ChangeNotifierProvider<SeriesNotifier>((ref) {
  return SeriesNotifier();
});
final episodeProvider = ChangeNotifierProvider<EpisodeNotifier>((ref) {
  return EpisodeNotifier();
});

/// Get series
final futureDetailsProvider = FutureProvider
.autoDispose
.family<Series, int>((ref, id) async {
  final Response response = await fetchGet('/tv/$id');
  final json = response.data;

  return Series(
    id: json['id'],
    backdropPath: json['backdrop_path'],
    firstAirDate: DateTime.parse(json['first_air_date']),
    genreIds: json['genres'],
    name: json['name'],
    rate: double.parse(json['vote_average'].toString()) / 2,
    seasons: json['seasons'],
    episodesCount: json['last_episode_to_air']['episode_number'],
  );
});

/// Get episode
final futureEpisodeProvider = FutureProvider
.autoDispose
.family<Episode, String>((ref, url) async {
  final Response response = await fetchGet(url);
  final json = response.data;

  return Episode(
    id: json['id'],
    imagePath: json['still_path'],
    number: json['episode_number'],
    name: json['name'],
    year: int.parse(json['air_date'].split('-')[0]),
    seasonNumber: json['season_number'],
    description: json['overview'],
  );
});

/// Details page
class DetailsPage extends ConsumerWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DetailsArguments args = ModalRoute.of(context)?.settings.arguments as
    DetailsArguments;
    final details = ref.watch(futureDetailsProvider(args.series.id).future);
    final AsyncValue<Episode> episode = ref.watch(futureEpisodeProvider(
      '/tv/${args.series.id}/season/1/episode/1',
    ));
    ref.watch(myFavoritesProvider);
    ref.watch(episodeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.series.name,
          style: Theme.of(context).textTheme.titleSmall
              ?.merge(
            const TextStyle(color: CompanyColors.grey),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (args.series.isFavorite) {
                ref.read(
                    myFavoritesProvider
                        .notifier
                ).removeFavorite(args.series);
              } else {
                ref.read(
                    myFavoritesProvider
                        .notifier
                ).addFavorite(args.series);
              }
            },
            icon: Icon(
              args.series.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
            color: CompanyColors.grey,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: episode.when(
            loading: () => const CircularProgressIndicator(),
            data: (Episode episode) => Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Episode ${episode.number}',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.merge(const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      InkWell(
                        onTap: () async {
                          final Series series = await details;
                          if (episode.number < series.episodesCount) {
                            await ref.read(episodeProvider.notifier)
                                .next(episode, args.series.id);
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Next',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.merge(const TextStyle(
                                color: Colors.white,
                              )),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 64),
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AppNetworkImage(
                          pathWidth: ImageWidth.original,
                          path: episode.imagePath,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Center(
                          child: MaterialButton(
                            minWidth: 40,
                            height: 40,
                            padding: EdgeInsets.zero,
                            color: CompanyColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            onPressed: () {},
                            child: const Icon(Icons.play_arrow_rounded),
                          )
                        )
                      )
                    ]
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    episode.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'IMDb: 7.0',
                        style: Theme.of(context).textTheme.titleSmall
                        ?.merge(const TextStyle(
                          color: CompanyColors.grey,
                          fontSize: 9,
                        )),
                      ),
                      const VerticalDivider(color: CompanyColors.grey),
                      Text(
                        '${episode.year}',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.merge(const TextStyle(
                          color: CompanyColors.grey,
                          fontSize: 9,
                        )),
                      ),
                      const VerticalDivider(color: CompanyColors.grey),
                      Text(
                        '${episode.seasonNumber} season',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.merge(const TextStyle(
                          color: CompanyColors.grey,
                          fontSize: 9,
                        )),
                      ),
                    ],
                  )
                ),
                const Divider(),
                Text(
                  episode.description,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.merge(const TextStyle(
                    color: CompanyColors.grey,
                  )),
                ),
              ],
            ),
            error: (err, _) => Text('Error: $err', style: const TextStyle(
              color: Colors.white,
            )),
          ),
        ),
      ),
    );
  }
}
