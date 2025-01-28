// test/domain/usecases/fetch_users_usecase_test.dart
import 'package:assignment/domain/entities/UserEntity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:assignment/domain/repositories/user_repository.dart';
import 'package:assignment/domain/usecases/fetch_users_usecase.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockRepo;
  late FetchUsersUseCase useCase;

  setUp(() {
    mockRepo = MockUserRepository();
    useCase = FetchUsersUseCase(mockRepo);
  });

  test('should fetch users from the repository', () async {
    // arrange
    final tUsers = [
      const UserEntity(id: 1, name: 'Alice', username: 'alice', email: 'alice@test.com'),
      const UserEntity(id: 2, name: 'Bob', username: 'bob', email: 'bob@test.com'),
    ];
    when(() => mockRepo.fetchUsers()).thenAnswer((_) async => tUsers);

    // act
    final result = await useCase();

    // assert
    expect(result, equals(tUsers));
    verify(() => mockRepo.fetchUsers()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
