// data/datasources/local/photo_local_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/photo.dart';

abstract class ILocalPhotoDataSource {
  Future<List<PhotoModel>?> getCachedPhotos(int albumId);
  Future<void> cachePhotos(int albumId, List<PhotoModel> photos);
}

class LocalPhotoDataSource implements ILocalPhotoDataSource {
  final SharedPreferences prefs;
  LocalPhotoDataSource(this.prefs);

  String _cacheKey(int albumId) => 'CACHED_PHOTOS_$albumId';

  @override
  Future<List<PhotoModel>?> getCachedPhotos(int albumId) async {
    final jsonString = prefs.getString(_cacheKey(albumId));
    if (jsonString == null) return null;

    final List list = jsonDecode(jsonString);
    return list.map((item) => PhotoModel.fromJson(item)).toList();
  }

  @override
  Future<void> cachePhotos(int albumId, List<PhotoModel> photos) async {
    final listMap = photos.map((p) => {
      'albumId': p.albumId,
      'id': p.id,
      'title': p.title,
      'url': p.url,
      'thumbnailUrl': p.thumbnailUrl,
    }).toList();

    await prefs.setString(_cacheKey(albumId), jsonEncode(listMap));
  }
}
