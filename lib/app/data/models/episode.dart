import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/app/data/http/http_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

/// Episode
@JsonSerializable()
class Episode {
  late int id;
  late String? imagePath;
  late int number;
  late String name;
  late int year;
  late int seasonNumber;
  late String description;

  /// Episode constructor
  Episode({
    required this.id,
    required this.number,
    required this.name,
    required this.year,
    required this.seasonNumber,
    required this.description,
    this.imagePath,
  });

  /// Episode from json
  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  /// Episode to json
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

class EpisodeNotifier extends ChangeNotifier {
  Future<void> next(Episode episode, int tvId) async {
    final Response response = await fetchGet(
      '/tv/$tvId/season/1/episode/${episode.number + 1}'
    );
    final json = response.data;

    episode..id = json['id']
    ..imagePath = json['still_path']
    ..number = json['episode_number']
    ..name = json['name']
    ..year = int.parse(json['air_date'].split('-')[0])
    ..seasonNumber = json['season_number']
    ..description = json['overview'];
    notifyListeners();
  }
}
