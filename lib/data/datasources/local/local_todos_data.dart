// data/datasources/local/todo_local_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/todos.dart';

abstract class ILocalTodoDataSource {
  Future<List<TodoModel>?> getCachedTodos(int userId);
  Future<void> cacheTodos(int userId, List<TodoModel> todos);
}

class LocalTodoDataSource implements ILocalTodoDataSource {
  final SharedPreferences prefs;
  LocalTodoDataSource(this.prefs);

  String _cacheKey(int userId) => 'CACHED_TODOS_$userId';

  @override
  Future<List<TodoModel>?> getCachedTodos(int userId) async {
    final jsonString = prefs.getString(_cacheKey(userId));
    if (jsonString == null) return null;

    final List list = jsonDecode(jsonString);
    return list.map((item) => TodoModel.fromJson(item)).toList();
  }

  @override
  Future<void> cacheTodos(int userId, List<TodoModel> todos) async {
    final listMap = todos.map((t) => {
      'userId': t.userId,
      'id': t.id,
      'title': t.title,
      'completed': t.completed,
    }).toList();

    await prefs.setString(_cacheKey(userId), jsonEncode(listMap));
  }
}
