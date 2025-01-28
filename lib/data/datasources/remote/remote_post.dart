import 'package:dio/dio.dart';
import '../../models/post.dart';

abstract class IRemotePostDataSource {
  Future<List<PostModel>> fetchPostsByUser(int userId);


}

class RemotePostDataSource implements IRemotePostDataSource {
  final Dio dio;
  RemotePostDataSource({required this.dio});

  @override
  Future<List<PostModel>> fetchPostsByUser(int userId) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/users/$userId/posts');
    final data = response.data as List;
    return data.map((json) => PostModel.fromJson(json)).toList();
  }
}
