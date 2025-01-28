import '../entities/UserEntity.dart';
import '../repositories/user_repository.dart';

class FetchUsersUseCase {
  final IUserRepository repository;

  FetchUsersUseCase(this.repository);

  Future<List<UserEntity>> call() async {
    return await repository.fetchUsers();
  }
}
