import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_post_usecase.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FetchPostsUseCase fetchPostsUseCase;

  PostBloc({required this.fetchPostsUseCase}) : super(PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(
      LoadPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostLoading());
    try {
      final posts = await fetchPostsUseCase.call(event.userId);
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
