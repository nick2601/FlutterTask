// data/datasources/local/post_local_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/post.dart';

abstract class ILocalPostDataSource {
  Future<List<PostModel>?> getCachedPosts(int userId);
  Future<void> cachePosts(int userId, List<PostModel> posts);
}

class LocalPostDataSource implements ILocalPostDataSource {
  final SharedPreferences prefs;
  LocalPostDataSource(this.prefs);

  String _cacheKey(int userId) => 'CACHED_POSTS_$userId';

  @override
  Future<List<PostModel>?> getCachedPosts(int userId) async {
    final jsonString = prefs.getString(_cacheKey(userId));
    if (jsonString == null) return null;

    final List list = jsonDecode(jsonString);
    return list.map((item) => PostModel.fromJson(item)).toList();
  }

  @override
  Future<void> cachePosts(int userId, List<PostModel> posts) async {
    final listMap = posts.map((p) => {
      'userId': p.userId,
      'id': p.id,
      'title': p.title,
      'body': p.body,
    }).toList();

    await prefs.setString(_cacheKey(userId), jsonEncode(listMap));
  }
}
