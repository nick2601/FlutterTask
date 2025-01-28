import 'package:assignment/data/datasources/local/local_user_data.dart';
import 'package:assignment/data/datasources/remote/remote_user.dart';
import 'package:assignment/data/models/user.dart';
import 'package:assignment/data/repositoriesImpl/userrepo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockRemoteUserDataSource extends Mock implements IRemoteUserDataSource {}
class MockLocalUserDataSource extends Mock implements ILocalUserDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockRemoteUserDataSource mockRemote;
  late MockLocalUserDataSource mockLocal;

  setUp(() {
    mockRemote = MockRemoteUserDataSource();
    mockLocal = MockLocalUserDataSource();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('fetchUsers', () {
    final tUserModels = [
      UserModel(
        id: 1,
        name: 'TestUser1',
        username: 'test1',
        email: 'test1@example.com',
      )
    ];

    test('should return cached data when present', () async {
      when(() => mockLocal.getCachedUsers())
          .thenAnswer((_) async => tUserModels);

      // act
      final result = await repository.fetchUsers();

      // assert
      expect(result, tUserModels);
      verify(() => mockLocal.getCachedUsers()).called(1);
      verifyNoMoreInteractions(mockRemote);
      verifyNoMoreInteractions(mockLocal);
    });

    test('should fetch from remote when no local data', () async {
      when(() => mockLocal.getCachedUsers()).thenAnswer((_) async => null);
      when(() => mockRemote.fetchUsers()).thenAnswer((_) async => tUserModels);
      when(() => mockLocal.cacheUsers(tUserModels)).thenAnswer((_) async => {});

      final result = await repository.fetchUsers();

      expect(result, tUserModels);
      verify(() => mockLocal.getCachedUsers()).called(1);
      verify(() => mockRemote.fetchUsers()).called(1);
      verify(() => mockLocal.cacheUsers(tUserModels)).called(1);
    });
  });
}
