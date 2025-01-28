// domain/repositories/photo_repository.dart

import '../entities/PhotoEntity.dart';

abstract class IPhotoRepository {
  Future<List<PhotoEntity>> fetchPhotosByAlbum(int albumId);
}
