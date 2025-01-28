import 'package:assignment/presentation/bloc/photos/photos_event.dart';
import 'package:assignment/presentation/bloc/photos/photos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/fetch_photo_usecase.dart';

/// A BLoC class responsible for managing the state of photo-related events and states.
/// It handles loading of photos and emits the corresponding states based on the outcome.
class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final FetchPhotosUseCase fetchPhotosUseCase;

  PhotoBloc({required this.fetchPhotosUseCase}) : super(PhotoInitial()) {
    on<LoadPhotosEvent>(_onLoadPhotos);
  }

  /// Handles loading of photos and emits the appropriate states.
  Future<void> _onLoadPhotos(
    LoadPhotosEvent event,
    Emitter<PhotoState> emit,
  ) async {
    emit(PhotoLoading());
    try {
      final photos = await fetchPhotosUseCase.call(event.albumId);
      emit(PhotoLoaded(photos));
    } catch (e) {
      emit(PhotoError(e.toString()));
    }
  }
}
