import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/fetch_album_usecase.dart';
import 'album_event.dart';
import 'album_state.dart';

/// BLoC class that manages the state of album events and states.
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final FetchAlbumsUseCase fetchAlbumsUseCase;

  AlbumBloc({required this.fetchAlbumsUseCase}) : super(AlbumInitial()) {
    on<LoadAlbumsEvent>(_onLoadAlbums);
  }

  /// Handles loading of albums and emits the appropriate states.
  Future<void> _onLoadAlbums(
    LoadAlbumsEvent event,
    Emitter<AlbumState> emit,
  ) async {
    emit(AlbumLoading());
    try {
      final albums = await fetchAlbumsUseCase.call(event.userId);
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}
