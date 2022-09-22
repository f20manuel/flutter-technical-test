import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

/// Series
@JsonSerializable()
class Series {
  late int id;
  late String backdropPath;
  late DateTime firstAirDate;
  late List genreIds;
  late String name;
  late double? rate;

  /// Series constructor
  Series({
    required this.id,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.name,
    this.rate,
  });

  /// Series from json
  factory Series.fromJson(Map<String, dynamic> json) =>
      _$SeriesFromJson(json);

  /// Series to json
  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
