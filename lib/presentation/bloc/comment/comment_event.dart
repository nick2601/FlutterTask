import '../../../domain/entities/CommentEntity.dart';

abstract class CommentEvent {}

class LoadCommentsEvent extends CommentEvent {
  final int postId;
  LoadCommentsEvent(this.postId);
}
class AddCommentEvent extends CommentEvent {
  final CommentEntity newComment;
  AddCommentEvent(this.newComment);
}