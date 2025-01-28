import 'package:assignment/domain/entities/UserEntity.dart';


abstract class IUserRepository {
  Future<List<UserEntity>> fetchUsers();
}


