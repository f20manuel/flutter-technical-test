// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
      id: json['id'] as int,
      backdropPath: json['backdropPath'] as String,
      firstAirDate: DateTime.parse(json['firstAirDate'] as String),
      genreIds:
          (json['genreIds'] as List<dynamic>).map((e) => e as int).toList(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'backdropPath': instance.backdropPath,
      'firstAirDate': instance.firstAirDate.toIso8601String(),
      'genreIds': instance.genreIds,
      'name': instance.name,
    };
