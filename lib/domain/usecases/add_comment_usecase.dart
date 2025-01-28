
import '../entities/CommentEntity.dart';
import '../repositories/comment_repository.dart';

class AddCommentUseCase {
  final ICommentRepository repository;

  AddCommentUseCase(this.repository);

  Future<CommentEntity> call(CommentEntity comment) {
    return repository.addComment(comment);
  }
}
