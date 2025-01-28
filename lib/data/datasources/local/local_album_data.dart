import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/album.dart';

abstract class ILocalAlbumDataSource {
  /// Returns cached albums for [userId], or null if none is cached.
  Future<List<AlbumModel>?> getCachedAlbums(int userId);

  /// Caches the given albums for [userId].
  Future<void> cacheAlbums(int userId, List<AlbumModel> albums);
}

class LocalAlbumDataSource implements ILocalAlbumDataSource {
  final SharedPreferences prefs;
  LocalAlbumDataSource(this.prefs);

  String _cacheKey(int userId) => 'CACHED_ALBUMS_$userId';

  @override
  Future<List<AlbumModel>?> getCachedAlbums(int userId) async {
    final jsonString = prefs.getString(_cacheKey(userId));
    if (jsonString == null) return null;

    final List list = jsonDecode(jsonString);
    return list.map((item) => AlbumModel.fromJson(item)).toList();
  }

  @override
  Future<void> cacheAlbums(int userId, List<AlbumModel> albums) async {
    final listMap = albums.map((a) => {
      'userId': a.userId,
      'id': a.id,
      'title': a.title,
    }).toList();

    await prefs.setString(_cacheKey(userId), jsonEncode(listMap));
  }
}
