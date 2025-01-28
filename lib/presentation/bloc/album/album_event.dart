/// Abstract class representing events related to albums.
abstract class AlbumEvent {}

/// Event to load albums for a specific user.
class LoadAlbumsEvent extends AlbumEvent {
  final int userId;
  LoadAlbumsEvent(this.userId);
}
