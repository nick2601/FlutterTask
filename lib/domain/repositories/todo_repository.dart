// domain/repositories/todo_repository.dart

import '../entities/TodoEntity.dart';

abstract class ITodoRepository {
  Future<List<TodoEntity>> fetchTodosByUser(int userId);
  Future<TodoEntity> updateTodoStatus(int todoId, bool completed);
}
