// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
      id: json['id'] as int,
      number: json['number'] as int,
      name: json['name'] as String,
      year: json['year'] as int,
      seasonNumber: json['seasonNumber'] as int,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'id': instance.id,
      'imagePath': instance.imagePath,
      'number': instance.number,
      'name': instance.name,
      'year': instance.year,
      'seasonNumber': instance.seasonNumber,
      'description': instance.description,
    };
