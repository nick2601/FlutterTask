import 'package:dio/dio.dart';
import '../../models/user.dart';

abstract class IRemoteUserDataSource {
  Future<List<UserModel>> fetchUsers();
}

class RemoteUserDataSource implements IRemoteUserDataSource {
  final Dio dio;

  RemoteUserDataSource({required this.dio});

  @override
  Future<List<UserModel>> fetchUsers() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/users');
    final list = response.data as List<dynamic>;
    return list.map((json) => UserModel.fromJson(json)).toList();
  }
}
