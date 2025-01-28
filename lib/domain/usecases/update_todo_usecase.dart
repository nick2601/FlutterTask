
import '../entities/TodoEntity.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final ITodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<TodoEntity> call(int todoId, bool completed) {
    return repository.updateTodoStatus(todoId, completed);
  }
}
