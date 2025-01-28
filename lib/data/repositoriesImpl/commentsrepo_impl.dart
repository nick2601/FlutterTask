import '../../domain/entities/CommentEntity.dart';
import '../../domain/repositories/comment_repository.dart';
import '../datasources/local/local_comment_data.dart';
import '../datasources/remote/remote_comment.dart';
import '../models/comment.dart';

class CommentRepositoryImpl implements ICommentRepository {
  final IRemoteCommentDataSource remoteDataSource;
  final ILocalCommentDataSource localDataSource;

  CommentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CommentEntity>> fetchCommentsByPost(int postId) async {
    // 1) Local check
    final localComments = await localDataSource.getCachedComments(postId);
    if (localComments != null && localComments.isNotEmpty) {
      return localComments;
    }

    // 2) Remote fetch
    final remoteComments = await remoteDataSource.fetchCommentsByPost(postId);

    // 3) Cache
    await localDataSource.cacheComments(postId, remoteComments);

    // 4) Return
    return remoteComments;
  }


  @override
  Future<CommentEntity> addComment(CommentEntity comment) async {
    // 1) Convert to model
    final model = CommentModel(
      postId: comment.postId,
      id: comment.id,
      name: comment.name,
      email: comment.email,
      body: comment.body,
    );

    // 2) Post to remote
    final posted = await remoteDataSource.postComment(model);

    // 3) Optionally cache or re-fetch. For demonstration, just return posted data.
    // If you wanted to re-fetch, you could do:
    //  localDataSource.appendComment(posted.postId, posted);

    return posted;
  }
}
