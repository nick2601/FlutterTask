// data/models/todos.dart

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/TodoEntity.dart';
part 'todos.g.dart';

/// Model class representing a todo with methods for JSON serialization.
@JsonSerializable()
class TodoModel extends TodoEntity {
  const TodoModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.completed,
  });
  //From json method
  /// Creates a TodoModel instance from a JSON object.
  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  //To json method
  /// Converts the TodoModel instance into a JSON object.
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);
}

/// Model class representing a collection of todos with methods for JSON serialization.
class TodosModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const TodosModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  /// Creates a TodosModel instance from a JSON object.
  factory TodosModel.fromJson(Map<String, dynamic> json) {
    return TodosModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  /// Converts the TodosModel instance into a JSON object.
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'completed': completed,
      };
}
