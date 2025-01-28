import '../entities/TodoEntity.dart';
import '../repositories/todo_repository.dart';

class FetchTodosUseCase {
  final ITodoRepository repo;
  FetchTodosUseCase(this.repo);

  Future<List<TodoEntity>> call(int userId) => repo.fetchTodosByUser(userId);
}
