import 'package:assignment/domain/entities/UserEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()

/// Model class representing a user with methods for JSON serialization.
///
/// This class extends the UserEntity and provides methods for JSON serialization.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.email,
  });

  /// Creates a UserModel instance from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts the UserModel instance into a JSON object.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
