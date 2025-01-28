/// Abstract class representing events related to posts.
///
/// This class serves as a base for all events related to posts.
abstract class PostEvent {}

/// Event to load posts for a specific user.
///
/// This event is triggered when the user requests to load posts for a specific user.
///
/// [userId] is the ID of the user for whom to load posts.
class LoadPostsEvent extends PostEvent {
  final int userId;
  LoadPostsEvent(this.userId);
}
