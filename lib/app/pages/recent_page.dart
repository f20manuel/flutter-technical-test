import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/theme/colors.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';
import 'package:fluttertest/app/data/models/episode.dart';
import 'package:fluttertest/app/widgets/image.dart';

/// Recent arguments
class RecentArguments {
  final String seriesTitle;
  final List<Episode> episodes;

  RecentArguments({
    required this.seriesTitle,
    required this.episodes,
  });
}

/// Recent page
class RecentPage extends ConsumerWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RecentArguments args = ModalRoute.of(context)?.settings.arguments
    as RecentArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.seriesTitle,
          style: Theme.of(context).textTheme.titleSmall
              ?.merge(
            const TextStyle(color: CompanyColors.grey),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: args.episodes.length,
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(),
        itemBuilder: (BuildContext context, int index) {
          final Episode item = args.episodes[index];
          return Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.merge(const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
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
                        path: item.imagePath,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
