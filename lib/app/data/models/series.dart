import 'package:flutter/material.dart';
import 'package:fluttertest/app/data/models/episode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

/// Series
@JsonSerializable()
class Series {
  late int id;
  late String? backdropPath;
  late DateTime firstAirDate;
  late List genreIds;
  late List? seasons;
  late String name;
  late double? rate;
  late bool isFavorite;
  late int episodesCount;
  late List<Episode>? episodes;

  /// Series constructor
  Series({
    required this.id,
    required this.firstAirDate,
    required this.genreIds,
    required this.name,
    this.backdropPath,
    this.rate,
    this.isFavorite = false,
    this.seasons,
    this.episodesCount = 0,
    this.episodes,
  });

  /// Series from json
  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  /// Series to json
  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}

class SeriesNotifier extends ChangeNotifier {
  final myFavorites = <Series>[];

  // Let's allow the UI to add myFavorites.
  void addFavorite(Series series) {
    myFavorites.add(series);
    series.isFavorite = true;
    notifyListeners();
  }

  // Let's allow removing myFavorites
  void removeFavorite(Series series) {
    myFavorites.remove(myFavorites.firstWhere(
      (element) => element.id == series.id),
    );
    series.isFavorite = false;
    notifyListeners();
  }
}