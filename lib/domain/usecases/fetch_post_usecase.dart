import '../entities/PostEntity.dart';
import '../repositories/post_repository.dart';

class FetchPostsUseCase {
  final IPostRepository repository;

  FetchPostsUseCase(this.repository);

  Future<List<PostEntity>> call(int userId) => repository.fetchPostsByUser(userId);
}
