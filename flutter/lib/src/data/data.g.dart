// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SamplePhoto _$SamplePhotoFromJson(Map<String, dynamic> json) => SamplePhoto(
      json['albumId'] as int?,
      json['id'] as int?,
      json['title'] as String?,
      json['url'] as String?,
      json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$SamplePhotoToJson(SamplePhoto instance) =>
    <String, dynamic>{
      'albumId': instance.albumId,
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
    };
