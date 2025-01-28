import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/comment.dart';

abstract class ILocalCommentDataSource {
  Future<List<CommentModel>?> getCachedComments(int postId);
  Future<void> cacheComments(int postId, List<CommentModel> comments);
}

class LocalCommentDataSource implements ILocalCommentDataSource {
  final SharedPreferences prefs;
  LocalCommentDataSource(this.prefs);

  String _cacheKey(int postId) => 'CACHED_COMMENTS_$postId';

  @override
  Future<List<CommentModel>?> getCachedComments(int postId) async {
    final jsonString = prefs.getString(_cacheKey(postId));
    if (jsonString == null) return null;

    final List list = jsonDecode(jsonString);
    return list.map((item) => CommentModel.fromJson(item)).toList();
  }

  @override
  Future<void> cacheComments(int postId, List<CommentModel> comments) async {
    final listMap = comments.map((c) => {
      'postId': c.postId,
      'id': c.id,
      'name': c.name,
      'email': c.email,
      'body': c.body,
    }).toList();

    await prefs.setString(_cacheKey(postId), jsonEncode(listMap));
  }
}
