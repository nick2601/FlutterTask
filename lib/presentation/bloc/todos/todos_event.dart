/// Abstract class representing events related to todos.
///
/// Events are used to trigger actions in the BLoC.
abstract class TodoEvent {}

/// Event to load todos for a specific user.
///
/// This event is triggered when the user requests to load their todos.
class LoadTodosEvent extends TodoEvent {
  /// The ID of the user whose todos are to be loaded.
  final int userId;
  LoadTodosEvent(this.userId);
}

/// Event to update a specific todo's completion status.
///
/// This event is triggered when the user updates the completion status of a todo.
class UpdateTodoEvent extends TodoEvent {
  /// The ID of the todo whose completion status is to be updated.
  final int todoId;

  /// The new completion status of the todo.
  final bool completed;
  UpdateTodoEvent(this.todoId, this.completed);
}
