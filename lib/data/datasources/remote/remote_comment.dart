import 'package:dio/dio.dart';

import '../../models/comment.dart';

abstract class IRemoteCommentDataSource {
  Future<List<CommentModel>> fetchCommentsByPost(int postId);
  Future<CommentModel> postComment(CommentModel comment);
}

class RemoteCommentDataSource implements IRemoteCommentDataSource {
  final Dio dio;
  RemoteCommentDataSource({required this.dio});

  @override
  Future<List<CommentModel>> fetchCommentsByPost(int postId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts/$postId/comments');
    final data = response.data as List;
    return data.map((json) => CommentModel.fromJson(json)).toList();
  }

  @override
  Future<CommentModel> postComment(CommentModel comment) async {
    final response = await dio.post(
      'https://jsonplaceholder.typicode.com/comments',
      data: comment.toJson(),
    );
    final data = response.data;
    return CommentModel.fromJson(data);
  }
}
