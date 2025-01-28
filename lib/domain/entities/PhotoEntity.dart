/// Entity class representing a photo with properties such as albumId, id, title, url, and thumbnailUrl.
///
/// This class is used to represent a photo entity in the domain layer.
class PhotoEntity {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const PhotoEntity({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });
}
