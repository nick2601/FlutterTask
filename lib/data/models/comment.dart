import '../../domain/entities/CommentEntity.dart';

/// A data model representing a comment.
///
/// This class extends the CommentEntity and provides methods for JSON serialization.
class CommentModel extends CommentEntity {
  const CommentModel({
    required super.postId,
    required super.id,
    required super.name,
    required super.email,
    required super.body,
  });

  /// Creates a CommentModel instance from a JSON object.
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  /// Converts the CommentModel instance into a JSON object.
  Map<String, dynamic> toJson() => {
        'postId': postId,
        'id': id,
        'name': name,
        'email': email,
        'body': body,
      };
}
