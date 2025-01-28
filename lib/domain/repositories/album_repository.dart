// domain/repositories/album_repository.dart

import '../entities/AlbumEntity.dart';

abstract class IAlbumRepository {
  Future<List<AlbumEntity>> fetchAlbumsByUser(int userId);
}
