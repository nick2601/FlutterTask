import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_comment_usecase.dart';
import '../../../domain/usecases/fetch_comment_usecase.dart';
import 'comment_event.dart';
import 'comment_state.dart';

/// BLoC class that manages the state of comment events and states.
///
/// This class extends the Bloc class from the flutter_bloc package and
/// handles the business logic for comment-related events and states.
///
/// It uses the FetchCommentsUseCase and AddCommentUseCase to interact with
/// the domain layer and retrieve or add comments.
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final FetchCommentsUseCase fetchCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;

  CommentBloc({
    required this.fetchCommentsUseCase,
    required this.addCommentUseCase,
  }) : super(CommentInitial()) {
    on<LoadCommentsEvent>(_onLoadComments);
    on<AddCommentEvent>(_onAddComment);
  }

  /// Handles loading of comments and emits the appropriate states.
  Future<void> _onLoadComments(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    try {
      final comments = await fetchCommentsUseCase.call(event.postId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  /// Handles adding a new comment and emits the appropriate states.
  Future<void> _onAddComment(
      AddCommentEvent event, Emitter<CommentState> emit) async {
    try {
      emit(AddingComment());
      final posted = await addCommentUseCase.call(event.newComment);
      emit(CommentAdded(posted));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
