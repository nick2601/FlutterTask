import '../entities/AlbumEntity.dart';
import '../repositories/album_repository.dart';

class FetchAlbumsUseCase {
  final IAlbumRepository repo;
  FetchAlbumsUseCase(this.repo);

  Future<List<AlbumEntity>> call(int userId) => repo.fetchAlbumsByUser(userId);
}
