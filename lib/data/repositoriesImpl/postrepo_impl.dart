import '../../domain/entities/PostEntity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/local/local_post_data.dart';
import '../datasources/remote/remote_post.dart';


class PostRepositoryImpl implements IPostRepository {
  final IRemotePostDataSource remoteDataSource;
  final ILocalPostDataSource localDataSource;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<PostEntity>> fetchPostsByUser(int userId) async {
    // 1) Local check
    final localPosts = await localDataSource.getCachedPosts(userId);
    if (localPosts != null && localPosts.isNotEmpty) {
      return localPosts;
    }

    // 2) Remote fetch
    final remotePosts = await remoteDataSource.fetchPostsByUser(userId);

    // 3) Cache
    await localDataSource.cachePosts(userId, remotePosts);

    // 4) Return
    return remotePosts;
  }
}
