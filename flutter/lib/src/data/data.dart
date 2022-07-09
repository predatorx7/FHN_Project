import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart' as quiver;

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

class SampleItem extends SamplePhoto {
  final double? price;

  const SampleItem(
    this.price,
    super.albumId,
    super.id,
    super.title,
    super.url,
    super.thumbnailUrl,
  );

  SampleItem.fromPhoto(
    this.price,
    SamplePhoto photo,
  ) : super(
          photo.albumId,
          photo.id,
          photo.title,
          photo.url,
          photo.thumbnailUrl,
        );

  @override
  bool operator ==(Object? other) {
    return other is SampleItem && id == other.id && albumId == other.albumId;
  }

  @override
  int get hashCode => quiver.hash2(id.hashCode, albumId.hashCode);
}
