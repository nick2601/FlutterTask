import 'package:assignment/domain/entities/UserEntity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


import 'package:assignment/domain/usecases/fetch_users_usecase.dart';
import 'package:assignment/presentation/bloc/user/user_bloc.dart';
import 'package:assignment/presentation/bloc/user/user_event.dart';
import 'package:assignment/presentation/bloc/user/user_state.dart';

class MockFetchUsersUseCase extends Mock implements FetchUsersUseCase {}

void main() {
  late MockFetchUsersUseCase mockUseCase;
  late UserBloc bloc;

  setUp(() {
    mockUseCase = MockFetchUsersUseCase();
    bloc = UserBloc(fetchUsersUseCase: mockUseCase);
  });

  final tUsers = [
    UserEntity(id: 1, name: 'Alice', username: 'alice', email: 'alice@test.com'),
    UserEntity(id: 2, name: 'Bob', username: 'bob', email: 'bob@test.com'),
  ];

  group('UserBloc', () {
    blocTest<UserBloc, UserState>(
      'loads users successfully',
      setUp: () {
        // STUB the happy path
        when(() => mockUseCase()).thenAnswer((_) async => tUsers);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [
        const UserLoading(),
        UserLoaded(tUsers),
      ],
      verify: (_) {
        // Verify that use case was called
        verify(() => mockUseCase()).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserError] when LoadUsersEvent fails',
      build: () {
        when(() => mockUseCase()).thenThrow(Exception('Failed to load'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [
        const UserLoading(),
        isA<UserError>(), // or  UserError('Exception: Failed to load') if you prefer matching the exact string
      ],
    );

    blocTest<UserBloc, UserState>(
      'sorts users by name when SortUsersEvent is added',
      build: () {
        bloc.emit(UserLoaded(tUsers));
        return bloc;
      },
      act: (bloc) => bloc.add(SortUsersEvent()),
      expect: () => [
        UserLoaded([
          // sorted => Alice, Bob
          UserEntity(id: 1, name: 'Alice', username: 'alice', email: 'alice@test.com'),
          UserEntity(id: 2, name: 'Bob', username: 'bob', email: 'bob@test.com'),
        ]),
      ],
    );

    blocTest<UserBloc, UserState>(
      'filters users by username substring when FilterUsersEvent is added',
      build: () {
        bloc.emit(UserLoaded(tUsers));
        return bloc;
      },
      act: (bloc) => bloc.add(FilterUsersEvent('bob')),
      expect: () => [
        UserLoaded([
          UserEntity(id: 2, name: 'Bob', username: 'bob', email: 'bob@test.com'),
        ]),
      ],
    );
  });
}
