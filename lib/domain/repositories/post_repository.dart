import 'package:assignment/domain/entities/PostEntity.dart';



abstract class IPostRepository {
  Future<List<PostEntity>> fetchPostsByUser(int userId);
}

