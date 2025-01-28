import 'package:assignment/domain/entities/PostEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostModel extends PostEntity {
  const PostModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.body,
  });

  //from json
  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  //to json
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
