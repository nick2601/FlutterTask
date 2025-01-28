/// Entity class representing a todo item with properties such as userId, id, title, and completion status.
///
/// This class is used to represent a single todo item in the application. It contains properties for the user ID,
/// unique ID, title, and completion status of the todo item.
class TodoEntity {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const TodoEntity({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });
}
