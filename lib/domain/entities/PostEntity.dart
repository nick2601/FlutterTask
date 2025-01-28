/// Entity class representing a post with properties such as userId, id, title, and body.
///
/// This class is used to represent a post entity in the domain layer.
class PostEntity {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostEntity({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
}
