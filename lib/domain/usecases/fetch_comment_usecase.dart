import '../entities/CommentEntity.dart';
import '../repositories/comment_repository.dart';

class FetchCommentsUseCase {
  final ICommentRepository repo;
  FetchCommentsUseCase(this.repo);

  Future<List<CommentEntity>> call(int postId) => repo.fetchCommentsByPost(postId);
}
