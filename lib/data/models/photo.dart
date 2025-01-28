// data/models/photo_model.dart

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/PhotoEntity.dart';
part 'photo.g.dart';

@JsonSerializable()
class PhotoModel extends PhotoEntity {
  const PhotoModel({
    required super.albumId,
    required super.id,
    required super.title,
    required super.url,
    required super.thumbnailUrl,
  });

  //From json method
  factory PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);

  //To json method
  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);
}
