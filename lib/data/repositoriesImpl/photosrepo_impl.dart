import '../../domain/entities/PhotoEntity.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/local/local_photo_data.dart';
import '../datasources/remote/remote_photo.dart';

class PhotoRepositoryImpl implements IPhotoRepository {
  final IRemotePhotoDataSource remoteDataSource;
  final ILocalPhotoDataSource localDataSource;

  PhotoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<PhotoEntity>> fetchPhotosByAlbum(int albumId) async {
    // 1) Local check
    final localPhotos = await localDataSource.getCachedPhotos(albumId);
    if (localPhotos != null && localPhotos.isNotEmpty) {
      return localPhotos;
    }

    // 2) Remote fetch
    final remotePhotos = await remoteDataSource.fetchPhotosByAlbum(albumId);

    // 3) Cache
    await localDataSource.cachePhotos(albumId, remotePhotos);

    // 4) Return
    return remotePhotos;
  }
}
