
import '../../../domain/entities/TodoEntity.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;
  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}
class UpdatingTodo extends TodoState {}

class TodoUpdated extends TodoState {
  final TodoEntity updated;
  TodoUpdated(this.updated);
}