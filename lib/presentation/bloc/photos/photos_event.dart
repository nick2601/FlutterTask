abstract class PhotoEvent {}

class LoadPhotosEvent extends PhotoEvent {
  final int albumId;
  LoadPhotosEvent(this.albumId);
}
