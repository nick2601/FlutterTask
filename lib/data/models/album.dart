import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/AlbumEntity.dart';
part 'album.g.dart';

/// Model class representing an album with methods for JSON serialization.
///
/// This class provides a concrete implementation of the AlbumEntity,
/// allowing for serialization and deserialization of album data.
@JsonSerializable()
class AlbumModel extends AlbumEntity {
  const AlbumModel({
    required super.userId,
    required super.id,
    required super.title,
  });

  /// Creates an AlbumModel instance from a JSON object.
  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

  /// Converts the AlbumModel instance into a JSON object.
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
      };
}
