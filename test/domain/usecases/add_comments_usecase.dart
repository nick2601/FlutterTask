// test/domain/usecases/add_comments_usecase_test.dart

import 'package:assignment/domain/entities/CommentEntity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:assignment/domain/repositories/comment_repository.dart';
import 'package:assignment/domain/usecases/add_comment_usecase.dart';

class MockCommentRepository extends Mock implements ICommentRepository {}

// Step A1: Create a Fake that extends `CommentEntity`
class FakeCommentEntity extends Fake implements CommentEntity {}

void main() {
  late MockCommentRepository mockRepo;
  late AddCommentUseCase useCase;

  // Step A2: Register fallback
  setUpAll(() {
    registerFallbackValue(FakeCommentEntity());
  });

  setUp(() {
    mockRepo = MockCommentRepository();
    useCase = AddCommentUseCase(mockRepo);
  });

  test('should post a new comment via repository', () async {
    final newComment = CommentEntity(
      postId: 123,
      id: 9999,
      name: 'TestUser',
      email: 'test@example.com',
      body: 'My test comment',
    );

    when(() => mockRepo.addComment(any())).thenAnswer((_) async => newComment);

    final result = await useCase(newComment);

    expect(result, equals(newComment));
    verify(() => mockRepo.addComment(newComment)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
