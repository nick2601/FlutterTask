// domain/usecases/fetch_photos_usecase.dart
import '../entities/PhotoEntity.dart';
import '../repositories/photo_repository.dart';

class FetchPhotosUseCase {
  final IPhotoRepository repo;
  FetchPhotosUseCase(this.repo);

  Future<List<PhotoEntity>> call(int albumId) => repo.fetchPhotosByAlbum(albumId);
}
