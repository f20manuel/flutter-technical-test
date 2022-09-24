// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
      id: json['id'] as int,
      firstAirDate: DateTime.parse(json['firstAirDate'] as String),
      genreIds: json['genreIds'] as List<dynamic>,
      name: json['name'] as String,
      backdropPath: json['backdropPath'] as String?,
      rate: (json['rate'] as num?)?.toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      seasons: json['seasons'] as List<dynamic>?,
      episodesCount: json['episodesCount'] as int,
    );

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'backdropPath': instance.backdropPath,
      'firstAirDate': instance.firstAirDate.toIso8601String(),
      'genreIds': instance.genreIds,
      'seasons': instance.seasons,
      'name': instance.name,
      'rate': instance.rate,
      'isFavorite': instance.isFavorite,
      'episodesCount': instance.episodesCount,
    };
