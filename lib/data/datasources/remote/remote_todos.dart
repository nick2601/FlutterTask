import 'package:dio/dio.dart';
import '../../models/todos.dart';

abstract class IRemoteTodoDataSource {
  Future<List<TodoModel>> fetchTodosByUser(int userId);
  Future<TodoModel> updateTodoStatus(int todoId, bool completed);
}

class RemoteTodoDataSource implements IRemoteTodoDataSource {
  final Dio dio;
  RemoteTodoDataSource({required this.dio});
  

  @override
  Future<List<TodoModel>> fetchTodosByUser(int userId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/users/$userId/todos');
    final data = response.data as List;
    return data.map((json) => TodoModel.fromJson(json)).toList();
  }



  @override
  Future<TodoModel> updateTodoStatus(int todoId, bool completed) async {
    final response = await dio.patch(
      'https://jsonplaceholder.typicode.com/todos/$todoId',
      data: {'completed': completed},
    );
    // The response might contain the updated object
    return TodoModel.fromJson(response.data);
  }
}
