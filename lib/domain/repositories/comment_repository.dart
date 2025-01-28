// domain/repositories/comment_repository.dart

import '../entities/CommentEntity.dart';

abstract class ICommentRepository {
  Future<List<CommentEntity>> fetchCommentsByPost(int postId);

  Future<CommentEntity> addComment(CommentEntity comment);
}
