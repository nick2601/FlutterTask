import '../../../domain/entities/AlbumEntity.dart';

/// Abstract class representing the various states of album loading.
abstract class AlbumState {}

/// Represents the initial state of album loading.
class AlbumInitial extends AlbumState {}

/// Represents the loading state of albums.
class AlbumLoading extends AlbumState {}

/// Represents the state when albums are successfully loaded.
class AlbumLoaded extends AlbumState {
  final List<AlbumEntity> albums;
  AlbumLoaded(this.albums);
}

/// Represents an error state when loading albums fails.
class AlbumError extends AlbumState {
  final String message;
  AlbumError(this.message);
}
