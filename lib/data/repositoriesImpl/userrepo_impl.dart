import '../../domain/entities/UserEntity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/local_user_data.dart';
import '../datasources/remote/remote_user.dart';


class UserRepositoryImpl implements IUserRepository {
  final IRemoteUserDataSource remoteDataSource;
  final ILocalUserDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<UserEntity>> fetchUsers() async {
    // 1) Try local cache first
    final local = await localDataSource.getCachedUsers();
    if (local != null && local.isNotEmpty) {
      return local;
    }

    // 2) Otherwise fetch from remote
    final remote = await remoteDataSource.fetchUsers();

    // 3) Cache
    await localDataSource.cacheUsers(remote);

    return remote;
  }
}
