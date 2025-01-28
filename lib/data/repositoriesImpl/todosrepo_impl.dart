import '../../domain/entities/TodoEntity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/local_todos_data.dart';
import '../datasources/remote/remote_todos.dart';

class TodoRepositoryImpl implements ITodoRepository {
  final IRemoteTodoDataSource remoteDataSource;
  final ILocalTodoDataSource localDataSource;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<TodoEntity>> fetchTodosByUser(int userId) async {
    // 1) Local check
    final localTodos = await localDataSource.getCachedTodos(userId);
    if (localTodos != null && localTodos.isNotEmpty) {
      return localTodos;
    }

    // 2) Remote fetch
    final remoteTodos = await remoteDataSource.fetchTodosByUser(userId);

    // 3) Cache
    await localDataSource.cacheTodos(userId, remoteTodos);

    // 4) Return
    return remoteTodos;
  }

  @override
  Future<TodoEntity> updateTodoStatus(int todoId, bool completed) async {

    final updatedModel = await remoteDataSource.updateTodoStatus(todoId, completed);

    return updatedModel;
  }
}
