import '../../domain/entities/AlbumEntity.dart';
import '../../domain/repositories/album_repository.dart';
import '../datasources/local/local_album_data.dart';
import '../datasources/remote/remote_album.dart';

class AlbumRepositoryImpl implements IAlbumRepository {
  final IRemoteAlbumDataSource remoteDataSource;
  final ILocalAlbumDataSource localDataSource;

  AlbumRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<AlbumEntity>> fetchAlbumsByUser(int userId) async {
    // 1) Check local cache
    final localAlbums = await localDataSource.getCachedAlbums(userId);
    if (localAlbums != null && localAlbums.isNotEmpty) {
      return localAlbums;
    }

    // 2) Otherwise fetch remote
    final remoteAlbums = await remoteDataSource.fetchAlbumsByUser(userId);

    // 3) Cache
    await localDataSource.cacheAlbums(userId, remoteAlbums);

    // 4) Return
    return remoteAlbums;
  }
}
