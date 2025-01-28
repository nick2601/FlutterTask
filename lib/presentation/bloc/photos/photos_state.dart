
import '../../../domain/entities/PhotoEntity.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<PhotoEntity> photos;
  PhotoLoaded(this.photos);
}

class PhotoError extends PhotoState {
  final String message;
  PhotoError(this.message);
}
