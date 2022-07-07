import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class SamplePhoto {
  @JsonKey(name: 'albumId')
  final int? albumId;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'thumbnailUrl')
  final String? thumbnailUrl;

  const SamplePhoto(
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  );

  factory SamplePhoto.fromJson(Map<String, dynamic> json) =>
      _$SamplePhotoFromJson(json);

  Map<String, dynamic> toJson() => _$SamplePhotoToJson(this);
}
